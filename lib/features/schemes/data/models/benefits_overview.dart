import 'package:equatable/equatable.dart';

class BenefitsOverview extends Equatable {
  final double totalPotentialBenefit;
  final String currency;
  final int availableNow;
  final int eligible;
  final int applied;
  final int notEligible;
  final int approved;
  final int rejected;

  const BenefitsOverview({
    required this.totalPotentialBenefit,
    this.currency = '₹',
    required this.availableNow,
    required this.eligible,
    required this.applied,
    required this.notEligible,
    this.approved = 0,
    this.rejected = 0,
  });

  @override
  List<Object?> get props => [
        totalPotentialBenefit,
        currency,
        availableNow,
        eligible,
        applied,
        notEligible,
        approved,
        rejected,
      ];

  BenefitsOverview copyWith({
    double? totalPotentialBenefit,
    String? currency,
    int? availableNow,
    int? eligible,
    int? applied,
    int? notEligible,
    int? approved,
    int? rejected,
  }) {
    return BenefitsOverview(
      totalPotentialBenefit: totalPotentialBenefit ?? this.totalPotentialBenefit,
      currency: currency ?? this.currency,
      availableNow: availableNow ?? this.availableNow,
      eligible: eligible ?? this.eligible,
      applied: applied ?? this.applied,
      notEligible: notEligible ?? this.notEligible,
      approved: approved ?? this.approved,
      rejected: rejected ?? this.rejected,
    );
  }

  factory BenefitsOverview.fromJson(Map<String, dynamic> json) {
    return BenefitsOverview(
      totalPotentialBenefit: (json['totalPotentialBenefit'] as num).toDouble(),
      currency: json['currency'] as String? ?? '₹',
      availableNow: json['availableNow'] as int,
      eligible: json['eligible'] as int,
      applied: json['applied'] as int,
      notEligible: json['notEligible'] as int,
      approved: json['approved'] as int? ?? 0,
      rejected: json['rejected'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPotentialBenefit': totalPotentialBenefit,
      'currency': currency,
      'availableNow': availableNow,
      'eligible': eligible,
      'applied': applied,
      'notEligible': notEligible,
      'approved': approved,
      'rejected': rejected,
    };
  }
}