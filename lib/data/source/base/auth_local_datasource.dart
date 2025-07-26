import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/core/constants/app_constants.dart';
import 'package:mobile/data/source/base/auth_datasource.dart';
import 'package:mobile/domain/models/auth_response.dart';

class AuthLocalDatasource implements AuthDatasource {
  final FlutterSecureStorage secureStorage;

  const AuthLocalDatasource({required this.secureStorage});

  @override
  Future<void> clearTokens() async {
    await secureStorage.delete(key: AppConstants.accessTokenKey);
    await secureStorage.delete(key: AppConstants.refreshTokenKey);
  }

  @override
  Future<String?> getAccessToken() {
    return secureStorage.read(key: AppConstants.accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() {
    return secureStorage.read(key: AppConstants.refreshTokenKey);
  }

  @override
  Future<void> saveTokens(AuthResponse authToken) async {
    await secureStorage.write(
      key: AppConstants.accessTokenKey,
      value: authToken.accessToken,
    );
    await secureStorage.write(
      key: AppConstants.refreshTokenKey,
      value: authToken.refreshToken,
    );
  }
}
