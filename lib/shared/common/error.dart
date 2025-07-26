import 'package:dio/dio.dart';

enum ErrorCode {
  unknown,
  networkError,
  serverError,
  validationError,
  authenticationError,
  permissionDenied,
  resourceNotFound,
  timeout,
  conflict,
  rateLimitExceeded,
  unsupportedOperation,
  dataIntegrityError,
  serviceUnavailable,
  cancelled,
}

class AppError {
  final ErrorCode errorCode;
  final String message;

  const AppError({required this.errorCode, required this.message});
}

ErrorCode mapDioErrorToAppError(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return ErrorCode.timeout;
    case DioExceptionType.cancel:
      return ErrorCode.cancelled;
    case DioExceptionType.badResponse:
      return ErrorCode.networkError;
    default:
      return ErrorCode.unknown;
  }
}
