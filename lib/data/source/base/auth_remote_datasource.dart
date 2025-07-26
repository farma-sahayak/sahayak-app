import 'package:mobile/domain/models/auth_request.dart';
import 'package:mobile/domain/models/auth_response.dart';
import 'package:mobile/shared/common/result.dart';

abstract class AuthRemoteDatasource {
  Future<Result<AuthResponse>> signup({AuthRequest? authRequest});
  Future<Result<AuthResponse>> login({AuthRequest? authRequest});
  Future<Result> logout();
  Future<Result<AuthResponse>> refreshToken(String refreshToken);
  Future<Result> validateToken(String accessToken);
  Future<T> retryRequest<T>(Future<T> Function() request);
}
