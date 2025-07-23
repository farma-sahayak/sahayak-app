import 'package:equatable/equatable.dart';

class MarketPrice extends Equatable {
  final String crop;
  final String cropEmoji;
  final double price;
  final String unit;
  final String market;
  final String region;
  final DateTime lastUpdated;
  final String trend; // 'up', 'down', 'stable'
  final double changePercent;
  final String quality; // 'premium', 'good', 'average'
  final String status; // 'HOLD', 'SELL', 'NEUTRAL'

  const MarketPrice({
    required this.crop,
    required this.cropEmoji,
    required this.price,
    required this.unit,
    required this.market,
    required this.region,
    required this.lastUpdated,
    required this.trend,
    required this.changePercent,
    required this.quality,
    required this.status,
  });

  factory MarketPrice.fromJson(Map<String, dynamic> json) {
    return MarketPrice(
      crop: json['crop'] ?? '',
      cropEmoji: json['crop_emoji'] ?? '🌾',
      price: (json['price'] ?? 0.0).toDouble(),
      unit: json['unit'] ?? 'kg',
      market: json['market'] ?? '',
      region: json['region'] ?? '',
      lastUpdated: DateTime.tryParse(json['last_updated'] ?? '') ?? DateTime.now(),
      trend: json['trend'] ?? 'stable',
      changePercent: (json['change_percent'] ?? 0.0).toDouble(),
      quality: json['quality'] ?? 'good',
      status: json['status'] ?? 'NEUTRAL',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'crop': crop,
      'crop_emoji': cropEmoji,
      'price': price,
      'unit': unit,
      'market': market,
      'region': region,
      'last_updated': lastUpdated.toIso8601String(),
      'trend': trend,
      'change_percent': changePercent,
      'quality': quality,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [
    crop,
    cropEmoji,
    price,
    unit,
    market,
    region,
    lastUpdated,
    trend,
    changePercent,
    quality,
    status,
  ];
}