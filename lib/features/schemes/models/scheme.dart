import 'package:equatable/equatable.dart';

enum SchemeStatus { eligible, applied, notEligible, approved, rejected }

enum SchemeCategory { income, insurance, subsidy, loan, training, other }

class Scheme extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String provider;
  final double benefitAmount;
  final String benefitCurrency;
  final SchemeStatus status;
  final SchemeCategory category;
  final DateTime deadline;
  final List<String> eligibilityCriteria;
  final List<String> tags;
  final List<String> requiredDocuments;
  final String? applicationLink;
  final String? brochureUrl;
  final String? audioGuideUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? applicationId;
  final double? progressPercentage;

  const Scheme({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.provider,
    required this.benefitAmount,
    this.benefitCurrency = '₹',
    required this.status,
    required this.category,
    required this.deadline,
    required this.eligibilityCriteria,
    required this.tags,
    required this.requiredDocuments,
    this.applicationLink,
    this.brochureUrl,
    this.audioGuideUrl,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.applicationId,
    this.progressPercentage,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        description,
        provider,
        benefitAmount,
        benefitCurrency,
        status,
        category,
        deadline,
        eligibilityCriteria,
        tags,
        requiredDocuments,
        applicationLink,
        brochureUrl,
        audioGuideUrl,
        isActive,
        createdAt,
        updatedAt,
        applicationId,
        progressPercentage,
      ];

  Scheme copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    String? provider,
    double? benefitAmount,
    String? benefitCurrency,
    SchemeStatus? status,
    SchemeCategory? category,
    DateTime? deadline,
    List<String>? eligibilityCriteria,
    List<String>? tags,
    List<String>? requiredDocuments,
    String? applicationLink,
    String? brochureUrl,
    String? audioGuideUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? applicationId,
    double? progressPercentage,
  }) {
    return Scheme(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      provider: provider ?? this.provider,
      benefitAmount: benefitAmount ?? this.benefitAmount,
      benefitCurrency: benefitCurrency ?? this.benefitCurrency,
      status: status ?? this.status,
      category: category ?? this.category,
      deadline: deadline ?? this.deadline,
      eligibilityCriteria: eligibilityCriteria ?? this.eligibilityCriteria,
      tags: tags ?? this.tags,
      requiredDocuments: requiredDocuments ?? this.requiredDocuments,
      applicationLink: applicationLink ?? this.applicationLink,
      brochureUrl: brochureUrl ?? this.brochureUrl,
      audioGuideUrl: audioGuideUrl ?? this.audioGuideUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      applicationId: applicationId ?? this.applicationId,
      progressPercentage: progressPercentage ?? this.progressPercentage,
    );
  }

  factory Scheme.fromJson(Map<String, dynamic> json) {
    return Scheme(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      description: json['description'] as String,
      provider: json['provider'] as String,
      benefitAmount: (json['benefitAmount'] as num).toDouble(),
      benefitCurrency: json['benefitCurrency'] as String? ?? '₹',
      status: SchemeStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => SchemeStatus.eligible,
      ),
      category: SchemeCategory.values.firstWhere(
        (e) => e.toString().split('.').last == json['category'],
        orElse: () => SchemeCategory.other,
      ),
      deadline: DateTime.parse(json['deadline'] as String),
      eligibilityCriteria: List<String>.from(json['eligibilityCriteria'] as List),
      tags: List<String>.from(json['tags'] as List),
      requiredDocuments: List<String>.from(json['requiredDocuments'] as List),
      applicationLink: json['applicationLink'] as String?,
      brochureUrl: json['brochureUrl'] as String?,
      audioGuideUrl: json['audioGuideUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      applicationId: json['applicationId'] as String?,
      progressPercentage: (json['progressPercentage'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'provider': provider,
      'benefitAmount': benefitAmount,
      'benefitCurrency': benefitCurrency,
      'status': status.toString().split('.').last,
      'category': category.toString().split('.').last,
      'deadline': deadline.toIso8601String(),
      'eligibilityCriteria': eligibilityCriteria,
      'tags': tags,
      'requiredDocuments': requiredDocuments,
      'applicationLink': applicationLink,
      'brochureUrl': brochureUrl,
      'audioGuideUrl': audioGuideUrl,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'applicationId': applicationId,
      'progressPercentage': progressPercentage,
    };
  }
}