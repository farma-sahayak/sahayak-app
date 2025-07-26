import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/core/constants/app_constants.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/data/source/base/auth_remote_datasource.dart';
import 'package:mobile/domain/models/auth_request.dart';
import 'package:mobile/domain/models/auth_response.dart';
import 'package:mobile/shared/common/error.dart';
import 'package:mobile/shared/common/result.dart';
import 'package:synchronized/synchronized.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final ApiClient _apiClient;
  final FlutterSecureStorage _secureStorage;
  final _lock = Lock();
  final _queue = <Future Function()>[];
  bool _isRefreshing = false;

  AuthRemoteDatasourceImpl(this._apiClient, this._secureStorage);

  @override
  Future<Result<AuthResponse>> signup({AuthRequest? authRequest}) async {
    try {
      final response = await _apiClient.post(
        '/auth/signup',
        data: {
          'phone_number': authRequest!.phoneNumber,
          'mpin': authRequest.mpin,
        },
      );

      if (response.data!.statusCode == 201) {
        final authToken = AuthResponse.fromJson(response.data!.data);
        await _saveTokens(authToken);
        return Result.success(authToken);
      }

      return const Result.failure(
        AppError(
          errorCode: ErrorCode.networkError,
          message: "Failed to sign up",
        ),
      );
    } catch (e) {
      return const Result.failure(
        AppError(
          errorCode: ErrorCode.networkError,
          message: "Failed to sign up",
        ),
      );
    }
  }

  @override
  Future<Result<AuthResponse>> login({AuthRequest? authRequest}) async {
    try {
      final response = await _apiClient.post(
        '/auth/login',
        data: {
          'phone_number': authRequest!.phoneNumber,
          'mpin': authRequest.mpin,
        },
      );

      if (response.data!.statusCode == 200) {
        final authToken = AuthResponse.fromJson(response.data!.data);
        await _saveTokens(authToken);
        return Result.success(authToken);
      }

      return const Result.failure(
        AppError(
          errorCode: ErrorCode.networkError,
          message: "Failed to log in",
        ),
      );
    } catch (e) {
      return const Result.failure(
        AppError(
          errorCode: ErrorCode.networkError,
          message: "Failed to log in",
        ),
      );
    }
  }

  @override
  Future<Result> logout() async {
    try {
      final accessToken = await _secureStorage.read(
        key: AppConstants.accessTokenKey,
      );
      final refreshToken = await _secureStorage.read(
        key: AppConstants.refreshTokenKey,
      );

      if (accessToken == null || refreshToken == null) {
        return const Result.failure(
          AppError(
            errorCode: ErrorCode.authenticationError,
            message: "Token expired or missing",
          ),
        );
      }

      final response = await _apiClient.post(
        '/auth/logout',
        data: {'refresh_token': refreshToken},
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.data!.statusCode == 200 ||
          response.data!.statusCode == 205) {
        await _clearTokens();
        return const Result.success(null);
      }

      return const Result.failure(
        AppError(errorCode: ErrorCode.serverError, message: 'Server error'),
      );
    } catch (e) {
      return const Result.failure(
        AppError(errorCode: ErrorCode.networkError, message: 'Network error'),
      );
    }
  }

  @override
  Future<Result<AuthResponse>> refreshToken(String refreshToken) async {
    if (_isRefreshing) {
      return const Result.failure(
        AppError(
          errorCode: ErrorCode.authenticationError,
          message: "Token refresh already in progress",
        ),
      );
    }

    try {
      _isRefreshing = true;
      final response = await _apiClient.post(
        '/auth/token/refresh',
        data: {'refresh': refreshToken},
      );

      if (response.data!.statusCode == 200) {
        final newTokens = AuthResponse.fromJson(response.data!.data);
        await _saveTokens(newTokens);
        return Result.success(newTokens);
      }

      return const Result.failure(
        AppError(
          errorCode: ErrorCode.authenticationError,
          message: "Failed to refresh token",
        ),
      );
    } catch (e) {
      return const Result.failure(
        AppError(
          errorCode: ErrorCode.networkError,
          message: "Failed to refresh token",
        ),
      );
    } finally {
      _isRefreshing = false;
      processQueue();
    }
  }

  @override
  Future<Result> validateToken(String accessToken) async {
    try {
      final response = await _apiClient.get(
        '/auth/validate-token/',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.data!.statusCode == 200) {
        return const Result.success(null);
      }

      return const Result.failure(
        AppError(
          errorCode: ErrorCode.authenticationError,
          message: "Token validation failed",
        ),
      );
    } catch (e) {
      return const Result.failure(
        AppError(
          errorCode: ErrorCode.networkError,
          message: "Failed to validate token",
        ),
      );
    }
  }

  @override
  Future<T> retryRequest<T>(Future<T> Function() request) async {
    if (_isRefreshing) {
      return _lock.synchronized(() async {
        Completer<T> completer = Completer();
        _queue.add(() async {
          try {
            final result = await request();
            completer.complete(result);
          } catch (e) {
            completer.completeError(e);
          }
        });
        return completer.future;
      });
    }

    try {
      return await request();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final refreshToken = await _secureStorage.read(
          key: AppConstants.refreshTokenKey,
        );
        if (refreshToken == null) {
          await _clearTokens();
          throw DioException(
            requestOptions: e.requestOptions,
            error: 'Authentication failed',
            response: e.response,
          );
        }

        final refreshResult = await _lock.synchronized(() async {
          if (!_isRefreshing) {
            return await this.refreshToken(refreshToken);
          }
          return const Result.failure(
            AppError(
              errorCode: ErrorCode.authenticationError,
              message: "Token refresh failed",
            ),
          );
        });

        if (refreshResult.isSuccess) {
          return await request();
        } else {
          await _clearTokens();
          throw DioException(
            requestOptions: e.requestOptions,
            error: 'Authentication failed',
            response: e.response,
          );
        }
      }
      rethrow;
    }
  }

  void processQueue() {
    while (_queue.isNotEmpty) {
      final request = _queue.removeAt(0);
      request();
    }
  }

  Future<void> _saveTokens(AuthResponse tokens) async {
    await Future.wait([
      _secureStorage.write(
        key: AppConstants.accessTokenKey,
        value: tokens.accessToken,
      ),
      _secureStorage.write(
        key: AppConstants.refreshTokenKey,
        value: tokens.refreshToken,
      ),
    ]);
  }

  Future<void> _clearTokens() async {
    await Future.wait([
      _secureStorage.delete(key: AppConstants.accessTokenKey),
      _secureStorage.delete(key: AppConstants.refreshTokenKey),
    ]);
  }
}
