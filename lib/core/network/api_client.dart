import 'package:dio/dio.dart';
import 'package:mobile/shared/common/error.dart';
import 'package:mobile/shared/common/result.dart';

class ApiClient {
  final Dio _dio;
  final Map<String, Future<Response>> _inFlightRequests = {};

  ApiClient(this._dio);

  Future<Result<Response>> _safeRequest(
    String requestKey,
    Future<Response> Function() requestFn, {
    Duration timeout = const Duration(seconds: 6),
  }) async {
    if (_inFlightRequests.containsKey(requestKey)) {
      return Result.success(await _inFlightRequests[requestKey]!);
    }

    final future = requestFn().timeout(
      timeout,
      onTimeout: () => throw DioException(
        requestOptions: RequestOptions(path: requestKey),
        type: DioExceptionType.connectionTimeout,
        error: 'Request timed out',
      ),
    );

    _inFlightRequests[requestKey] = future;
    try {
      final response = await future;
      return Result.success(response);
    } on DioException catch (e) {
      return Result.failure(
        AppError(
          errorCode: mapDioErrorToAppError(e),
          message: "exception occured",
        ),
      );
    } catch (e) {
      return Result.failure(
        AppError(
          errorCode: ErrorCode.unknown,
          message: "exception occured: $e",
        ),
      );
    } finally {
      _inFlightRequests.remove(requestKey);
    }
  }

  Future<Result<Response>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    final key = 'GET:$path:${queryParameters.toString()}';
    return _safeRequest(
      key,
      () => _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  Future<Result<Response>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    final key = 'POST:$path:${data.hashCode}:${queryParameters.toString()}';
    return _safeRequest(
      key,
      () => _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  Future<Result<Response>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    final key = 'PUT:$path:${data.hashCode}:${queryParameters.toString()}';
    return _safeRequest(
      key,
      () => _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  Future<Result<Response>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    final key = 'DELETE:$path:${data.hashCode}:${queryParameters.toString()}';
    return _safeRequest(
      key,
      () => _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }
}
