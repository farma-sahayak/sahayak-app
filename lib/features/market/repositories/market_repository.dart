import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/market_price.dart';
import '../models/market_insight.dart';

class MarketRepository {
  static const String baseUrl = 'http://localhost:8000';

  // Get current market prices
  Future<List<MarketPrice>> getCurrentPrices({String? region}) async {
    try {
      final queryParams = region != null ? '?region=$region' : '';
      final response = await http.get(
        Uri.parse('$baseUrl/market/prices/current$queryParams'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> pricesJson = data['prices'] ?? [];
        return pricesJson.map((json) => MarketPrice.fromJson(json)).toList();
      }
      
      // Return mock data if API fails
      return _getMockPrices();
    } catch (e) {
      print('Error fetching current prices: $e');
      return _getMockPrices();
    }
  }

  // Get historical prices for a specific crop
  Future<List<MarketPrice>> getHistoricalPrices({
    required String crop,
    String? region,
    int days = 7,
  }) async {
    try {
      final queryParams = '?crop=$crop&days=$days${region != null ? '&region=$region' : ''}';
      final response = await http.get(
        Uri.parse('$baseUrl/market/prices/history$queryParams'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> pricesJson = data['prices'] ?? [];
        return pricesJson.map((json) => MarketPrice.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      print('Error fetching historical prices: $e');
      return [];
    }
  }

  // Search crop prices
  Future<List<MarketPrice>> searchCropPrices(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/market/prices/search?q=$query'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> pricesJson = data['prices'] ?? [];
        return pricesJson.map((json) => MarketPrice.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      print('Error searching crop prices: $e');
      return [];
    }
  }

  // Get market insights
  Future<List<MarketInsight>> getMarketInsights() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/market/insights'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> insightsJson = data['insights'] ?? [];
        return insightsJson.map((json) => MarketInsight.fromJson(json)).toList();
      }
      
      return _getMockInsights();
    } catch (e) {
      print('Error fetching market insights: $e');
      return _getMockInsights();
    }
  }

  // Subscribe to price alerts
  Future<bool> subscribeToPriceAlert({
    required String farmerId,
    required String crop,
    required double threshold,
    required String condition, // '>=', '<=', '=='
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/market/alerts/subscribe'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'farmer_id': farmerId,
          'crop': crop,
          'threshold': threshold,
          'condition': condition,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error subscribing to price alert: $e');
      return false;
    }
  }

  // Mock data for development
  List<MarketPrice> _getMockPrices() {
    final now = DateTime.now();
    return [
      MarketPrice(
        crop: 'Tomato',
        cropEmoji: '🍅',
        price: 25.0,
        unit: 'kg',
        market: 'APMC Bangalore',
        region: 'Karnataka',
        lastUpdated: now.subtract(const Duration(hours: 2)),
        trend: 'up',
        changePercent: 8.0,
        quality: 'good',
        status: 'HOLD',
      ),
      MarketPrice(
        crop: 'Brinjal',
        cropEmoji: '🍆',
        price: 18.0,
        unit: 'kg',
        market: 'APMC Bangalore',
        region: 'Karnataka',
        lastUpdated: now.subtract(const Duration(hours: 1)),
        trend: 'down',
        changePercent: -5.0,
        quality: 'premium',
        status: 'SELL',
      ),
      MarketPrice(
        crop: 'Chili',
        cropEmoji: '🌶️',
        price: 45.0,
        unit: 'kg',
        market: 'APMC Bangalore',
        region: 'Karnataka',
        lastUpdated: now.subtract(const Duration(minutes: 30)),
        trend: 'up',
        changePercent: 12.0,
        quality: 'good',
        status: 'HOLD',
      ),
      MarketPrice(
        crop: 'Onion',
        cropEmoji: '🧅',
        price: 15.0,
        unit: 'kg',
        market: 'APMC Bangalore',
        region: 'Karnataka',
        lastUpdated: now.subtract(const Duration(hours: 1)),
        trend: 'stable',
        changePercent: 0.0,
        quality: 'average',
        status: 'NEUTRAL',
      ),
    ];
  }

  List<MarketInsight> _getMockInsights() {
    final now = DateTime.now();
    return [
      MarketInsight(
        title: 'Best Time',
        description: 'Morning hours',
        type: 'best_time',
        severity: 'medium',
        validUntil: now.add(const Duration(days: 1)),
      ),
      MarketInsight(
        title: 'Festival Spike',
        description: 'Higher demand',
        type: 'festival_spike',
        severity: 'high',
        validUntil: now.add(const Duration(days: 3)),
      ),
    ];
  }
}