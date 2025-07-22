import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8000'; // Gateway URL
  
  // Chat with Sahayak
  static Future<Map<String, dynamic>> sendMessage(String message, String farmerId) async {
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
          'intent': 'error'
        };
      }
    } catch (e) {
      return {
        'response': 'Connection error. Please check your internet connection.',
        'intent': 'error'
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
      final response = await http.get(
        Uri.parse('$baseUrl/market/prices'),
      );
      
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
      return {
        'temperature': 28,
        'humidity': 65,
        'conditions': 'Partly Cloudy'
      };
    } catch (e) {
      print('Error fetching weather: $e');
      return {
        'temperature': 28,
        'humidity': 65,
        'conditions': 'Partly Cloudy'
      };
    }
  }
}