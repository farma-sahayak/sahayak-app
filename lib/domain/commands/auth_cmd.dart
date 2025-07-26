import 'package:mobile/domain/models/auth_request.dart';
import 'package:mobile/domain/repositories/auth_repository.dart';
import 'package:mobile/shared/common/result.dart';

class AuthCmd {
  final AuthRepository authReppository;

  const AuthCmd(this.authReppository);

  Future<Result<bool>> isAuthenticated() {
    return authReppository.isAuthenticated();
  }

  Future<Result<bool>> signup(AuthRequest authRequest) async {
    final result = await authReppository.signup(authRequest: authRequest);
    if (result.isFailure) {
      return Result.failure(result.error!);
    }
    return Result.success(true);
  }

  Future<Result<bool>> logout() async {
    final result = await authReppository.logout();
    if (result.isFailure) {
      return Result.failure(result.error!);
    }
    return const Result.success(true);
  }
}
