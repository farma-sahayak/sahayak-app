import 'package:mobile/core/constants/app_constants.dart';

class AuthResponse {
  final String? accessToken;
  final String? refreshToken;

  const AuthResponse({required this.accessToken, required this.refreshToken});

  static AuthResponse fromJson(Map<String, dynamic> jsonData) {
    return AuthResponse(
      accessToken: jsonData[AppConstants.accessTokenKey],
      refreshToken: jsonData[AppConstants.refreshTokenKey],
    );
  }
}
