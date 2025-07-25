import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8000'; // Gateway URL

  // Chat with Sahayak
  static Future<Map<String, dynamic>> sendMessage(
    String message,
    String farmerId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'message': message,
          'farmer_id': farmerId,
          'language': 'english',
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'response': 'Sorry, I am having trouble right now. Please try again.',
          'intent': 'error',
        };
      }
    } catch (e) {
      return {
        'response': 'Connection error. Please check your internet connection.',
        'intent': 'error',
      };
    }
  }

  // Get crops for farmer
  static Future<List<dynamic>> getCrops(String farmerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/crops?farmer_id=$farmerId'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return [];
    } catch (e) {
      print('Error fetching crops: $e');
      return [];
    }
  }

  // Get market prices
  static Future<Map<String, dynamic>> getMarketPrices() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/market/prices'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {'prices': []};
    } catch (e) {
      print('Error fetching market prices: $e');
      return {'prices': []};
    }
  }

  // Get weather
  static Future<Map<String, dynamic>> getWeather(String location) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/weather?location=$location'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {'temperature': 28, 'humidity': 65, 'conditions': 'Partly Cloudy'};
    } catch (e) {
      print('Error fetching weather: $e');
      return {'temperature': 28, 'humidity': 65, 'conditions': 'Partly Cloudy'};
    }
  }

  bool isAuthError(Exception e) {
    // Implement logic to check if the exception is related to authentication
    // For example, check if the error message contains "Unauthorized" or similar
    return e.toString().contains('Unauthorized') ||
        e.toString().contains('Token expired');
  }

  Future getCurrentUser() async {
    // Implement logic to fetch the current user
    // This is a placeholder implementation
    return null;
    // return User(
    //   userId: '123',
    //   phoneNumber: '9876543210',
    //   firebaseUid: 'firebase_uid',
    //   farmerId: 'farmer_id',
    //   profileCompleted: true,
    //   createdAt: DateTime.now(),
    //   updatedAt: DateTime.now(),
    // );
  }

  Future verifyOTP(String phoneNumber, String otpCode) async {
    // Implement logic to verify OTP
    // This is a placeholder implementation
    if (otpCode == '123456') {
      return {
        'token': 'auth_token',
        'sessionId': 'session_id',
        'user': {
          'user_id': '123',
          'phone_number': phoneNumber,
          'firebase_uid': 'firebase_uid',
          'farmer_id': 'farmer_id',
          'profile_completed': true,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
      };
    } else {
      throw Exception('Invalid OTP');
    }
  }

  Future sendOTP(String phoneNumber) async {
    // Implement logic to send OTP
    // This is a placeholder implementation
    return {
      'message': 'OTP sent successfully to $phoneNumber',
      'phoneNumber': phoneNumber,
    };
  }

  Future<void> clearAuthToken() async {
    // Implement logic to clear authentication token
    // This is a placeholder implementation
    print('Auth token cleared');
  }
}
