import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/core/constants/app_constants.dart';
import 'package:mobile/data/source/base/auth_local_datasource.dart';
import 'package:mobile/data/source/base/auth_remote_datasource.dart';
import 'package:mobile/domain/models/auth_request.dart';
import 'package:mobile/domain/repositories/auth_repository.dart';
import 'package:mobile/shared/common/error.dart';
import 'package:mobile/shared/common/result.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDatasource localDatasource;
  final AuthRemoteDatasource remoteDatasource;
  final FlutterSecureStorage secureStorage;

  const AuthRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.secureStorage,
  });

  @override
  Future<Result> signup({AuthRequest? authRequest}) async {
    try {
      final remoteResult = await remoteDatasource.signup(
        authRequest: authRequest,
      );

      if (!remoteResult.isFailure &&
          (remoteResult.data!.accessToken != null &&
              remoteResult.data!.refreshToken != null)) {
        // save tokens locally
        await localDatasource.saveTokens(remoteResult.data!);

        return const Result.success(null);
      }

      return Result.failure(remoteResult.error!);
    } catch (e) {
      return const Result.failure(
        AppError(
          errorCode: ErrorCode.unknown,
          message: "an unexpected error occurred",
        ),
      );
    }
  }

  @override
  Future<Result> login({AuthRequest? authRequest}) async {
    try {
      // call remote data source to log in
      final remoteResult = await remoteDatasource.login(
        authRequest: authRequest,
      );

      if (!remoteResult.isFailure) {
        // if succeeds, overwrite local storage refresh tokens
        // ?? do I need to delete before that?
        await localDatasource.saveTokens(remoteResult.data!);

        return const Result.success(null);
      }

      return Result.failure(remoteResult.error);
    } catch (e) {
      return const Result.failure(
        AppError(
          errorCode: ErrorCode.unknown,
          message: "an unexpected error occurred",
        ),
      );
    }
  }

  @override
  Future<Result> logout() async {
    try {
      final remoteResult = await remoteDatasource.logout();
      if (remoteResult.isSuccess) {
        await secureStorage.delete(key: AppConstants.accessTokenKey);
        await secureStorage.delete(key: AppConstants.refreshTokenKey);

        return const Result.success(null);
      }

      return const Result.failure(
        AppError(
          errorCode: ErrorCode.unknown,
          message: 'auth repo failed to logout',
        ),
      );
    } catch (e) {
      return const Result.failure(
        AppError(
          errorCode: ErrorCode.unknown,
          message: 'auth repo failed to logout',
        ),
      );
    }
  }

  @override
  Future<Result<bool>> isAuthenticated() async {
    try {
      final accessToken = await localDatasource.getAccessToken();
      if (accessToken == null) {
        return const Result.failure(
          AppError(
            errorCode: ErrorCode.authenticationError,
            message: "no access token found",
          ),
        );
      }

      // First try to validate the access token
      final validationResult = await remoteDatasource.validateToken(
        accessToken,
      );
      if (validationResult.isSuccess) {
        return const Result.success(true);
      }

      // If validation fails, try to refresh the token
      final refreshToken = await localDatasource.getRefreshToken();
      if (refreshToken == null) {
        await localDatasource.clearTokens();
        return const Result.success(false);
      }

      final refreshResult = await remoteDatasource.refreshToken(refreshToken);
      if (refreshResult.isSuccess) {
        // Save the new tokens
        await localDatasource.saveTokens(refreshResult.data!);
        return const Result.success(true);
      }

      // If refresh also fails, clear tokens and return false
      await localDatasource.clearTokens();
      return const Result.success(false);
    } catch (e) {
      return const Result.failure(
        AppError(
          errorCode: ErrorCode.unknown,
          message: "Failed to check authentication status",
        ),
      );
    }
  }
}
