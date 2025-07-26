import 'package:mobile/domain/models/auth_response.dart';

abstract class AuthDatasource {
  Future<void> saveTokens(AuthResponse authToken);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> clearTokens();
}
