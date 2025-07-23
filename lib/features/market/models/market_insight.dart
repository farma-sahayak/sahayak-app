import 'package:equatable/equatable.dart';

class MarketInsight extends Equatable {
  final String title;
  final String description;
  final String type; // 'festival_spike', 'best_time', 'demand_high', etc.
  final String severity; // 'high', 'medium', 'low'
  final DateTime validUntil;

  const MarketInsight({
    required this.title,
    required this.description,
    required this.type,
    required this.severity,
    required this.validUntil,
  });

  factory MarketInsight.fromJson(Map<String, dynamic> json) {
    return MarketInsight(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? 'general',
      severity: json['severity'] ?? 'medium',
      validUntil: DateTime.tryParse(json['valid_until'] ?? '') ?? DateTime.now().add(const Duration(days: 7)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'type': type,
      'severity': severity,
      'valid_until': validUntil.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [title, description, type, severity, validUntil];
}