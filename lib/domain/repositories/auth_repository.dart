import 'package:mobile/domain/models/auth_request.dart';
import 'package:mobile/shared/common/result.dart';

abstract class AuthRepository {
  Future<Result> signup({AuthRequest? authRequest});
  Future<Result> login({AuthRequest? authRequest});
  Future<Result> logout();
  Future<Result<bool>> isAuthenticated();
}
