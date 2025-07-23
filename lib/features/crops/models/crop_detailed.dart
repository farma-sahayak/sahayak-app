class CropDetailed {
  final String id;
  final String name;
  final String emoji;
  final double acres;
  final CropStatus status;
  final int healthPercentage;
  final DateTime plantedDate;
  final DateTime? expectedHarvestDate;
  final String? imageUrl;
  
  // Financial data according to PRD
  final double totalInvestment;
  final double expectedRevenue;
  final double actualSales;
  final double profit;
  final double profitPercentage;
  
  // Milestone and task management
  final List<CropMilestone> milestones;
  final String? nextAction;
  final DateTime? nextActionDate;
  final List<CropIssue> issues;
  
  const CropDetailed({
    required this.id,
    required this.name,
    required this.emoji,
    required this.acres,
    required this.status,
    required this.healthPercentage,
    required this.plantedDate,
    this.expectedHarvestDate,
    this.imageUrl,
    required this.totalInvestment,
    required this.expectedRevenue,
    this.actualSales = 0.0,
    required this.profit,
    required this.profitPercentage,
    this.milestones = const [],
    this.nextAction,
    this.nextActionDate,
    this.issues = const [],
  });

  factory CropDetailed.fromJson(Map<String, dynamic> json) {
    return CropDetailed(
      id: json['id'],
      name: json['name'],
      emoji: json['emoji'],
      acres: json['acres']?.toDouble() ?? 0.0,
      status: CropStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => CropStatus.growing,
      ),
      healthPercentage: json['healthPercentage'] ?? 0,
      plantedDate: DateTime.parse(json['plantedDate']),
      expectedHarvestDate: json['expectedHarvestDate'] != null
          ? DateTime.parse(json['expectedHarvestDate'])
          : null,
      imageUrl: json['imageUrl'],
      totalInvestment: json['totalInvestment']?.toDouble() ?? 0.0,
      expectedRevenue: json['expectedRevenue']?.toDouble() ?? 0.0,
      actualSales: json['actualSales']?.toDouble() ?? 0.0,
      profit: json['profit']?.toDouble() ?? 0.0,
      profitPercentage: json['profitPercentage']?.toDouble() ?? 0.0,
      milestones: (json['milestones'] as List<dynamic>?)
              ?.map((milestone) => CropMilestone.fromJson(milestone))
              .toList() ??
          [],
      nextAction: json['nextAction'],
      nextActionDate: json['nextActionDate'] != null
          ? DateTime.parse(json['nextActionDate'])
          : null,
      issues: (json['issues'] as List<dynamic>?)
              ?.map((issue) => CropIssue.fromJson(issue))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'emoji': emoji,
      'acres': acres,
      'status': status.name,
      'healthPercentage': healthPercentage,
      'plantedDate': plantedDate.toIso8601String(),
      'expectedHarvestDate': expectedHarvestDate?.toIso8601String(),
      'imageUrl': imageUrl,
      'totalInvestment': totalInvestment,
      'expectedRevenue': expectedRevenue,
      'actualSales': actualSales,
      'profit': profit,
      'profitPercentage': profitPercentage,
      'milestones': milestones.map((milestone) => milestone.toJson()).toList(),
      'nextAction': nextAction,
      'nextActionDate': nextActionDate?.toIso8601String(),
      'issues': issues.map((issue) => issue.toJson()).toList(),
    };
  }

  bool get isReadyForHarvest => status == CropStatus.ready;
  bool get hasIssues => issues.isNotEmpty;
  bool get hasNextAction => nextAction != null;
  
  String get statusDisplayText {
    if (isReadyForHarvest) return 'Ready for Harvest';
    return status.displayName;
  }
}

class CropMilestone {
  final String id;
  final String title;
  final String description;
  final DateTime scheduledDate;
  final bool isCompleted;
  final DateTime? completedDate;
  final MilestoneType type;

  const CropMilestone({
    required this.id,
    required this.title,
    required this.description,
    required this.scheduledDate,
    this.isCompleted = false,
    this.completedDate,
    required this.type,
  });

  factory CropMilestone.fromJson(Map<String, dynamic> json) {
    return CropMilestone(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      scheduledDate: DateTime.parse(json['scheduledDate']),
      isCompleted: json['isCompleted'] ?? false,
      completedDate: json['completedDate'] != null
          ? DateTime.parse(json['completedDate'])
          : null,
      type: MilestoneType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () => MilestoneType.other,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'scheduledDate': scheduledDate.toIso8601String(),
      'isCompleted': isCompleted,
      'completedDate': completedDate?.toIso8601String(),
      'type': type.name,
    };
  }
}

enum MilestoneType {
  planting,
  watering,
  fertilizing,
  pestControl,
  pruning,
  harvesting,
  other,
}

extension MilestoneTypeExtension on MilestoneType {
  String get displayName {
    switch (this) {
      case MilestoneType.planting:
        return 'Planting';
      case MilestoneType.watering:
        return 'Watering';
      case MilestoneType.fertilizing:
        return 'Fertilizing';
      case MilestoneType.pestControl:
        return 'Pest Control';
      case MilestoneType.pruning:
        return 'Pruning';
      case MilestoneType.harvesting:
        return 'Harvesting';
      case MilestoneType.other:
        return 'Other';
    }
  }

  String get iconData {
    switch (this) {
      case MilestoneType.planting:
        return 'eco';
      case MilestoneType.watering:
        return 'water_drop';
      case MilestoneType.fertilizing:
        return 'grass';
      case MilestoneType.pestControl:
        return 'bug_report';
      case MilestoneType.pruning:
        return 'content_cut';
      case MilestoneType.harvesting:
        return 'agriculture';
      case MilestoneType.other:
        return 'task_alt';
    }
  }
}

class CropIssue {
  final String id;
  final String title;
  final String description;
  final IssueType type;
  final IssueSeverity severity;
  final DateTime detectedDate;
  final bool isResolved;
  final DateTime? resolvedDate;

  const CropIssue({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.severity,
    required this.detectedDate,
    this.isResolved = false,
    this.resolvedDate,
  });

  factory CropIssue.fromJson(Map<String, dynamic> json) {
    return CropIssue(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: IssueType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () => IssueType.other,
      ),
      severity: IssueSeverity.values.firstWhere(
        (severity) => severity.name == json['severity'],
        orElse: () => IssueSeverity.medium,
      ),
      detectedDate: DateTime.parse(json['detectedDate']),
      isResolved: json['isResolved'] ?? false,
      resolvedDate: json['resolvedDate'] != null
          ? DateTime.parse(json['resolvedDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'severity': severity.name,
      'detectedDate': detectedDate.toIso8601String(),
      'isResolved': isResolved,
      'resolvedDate': resolvedDate?.toIso8601String(),
    };
  }
}

enum IssueType {
  disease,
  pest,
  weather,
  nutrient,
  water,
  other,
}

enum IssueSeverity {
  low,
  medium,
  high,
  critical,
}

extension IssueTypeExtension on IssueType {
  String get displayName {
    switch (this) {
      case IssueType.disease:
        return 'Disease';
      case IssueType.pest:
        return 'Pest';
      case IssueType.weather:
        return 'Weather';
      case IssueType.nutrient:
        return 'Nutrient Deficiency';
      case IssueType.water:
        return 'Water Issue';
      case IssueType.other:
        return 'Other';
    }
  }
}

extension IssueSeverityExtension on IssueSeverity {
  String get displayName {
    switch (this) {
      case IssueSeverity.low:
        return 'Low';
      case IssueSeverity.medium:
        return 'Medium';
      case IssueSeverity.high:
        return 'High';
      case IssueSeverity.critical:
        return 'Critical';
    }
  }

  String get colorHex {
    switch (this) {
      case IssueSeverity.low:
        return '#FFF9C4';
      case IssueSeverity.medium:
        return '#FFE0B2';
      case IssueSeverity.high:
        return '#FFCDD2';
      case IssueSeverity.critical:
        return '#F8BBD9';
    }
  }
}

enum CropStatus {
  planting,
  growing,
  flowering,
  ready,
  harvested,
}

extension CropStatusExtension on CropStatus {
  String get displayName {
    switch (this) {
      case CropStatus.planting:
        return 'Planting';
      case CropStatus.growing:
        return 'Growing';
      case CropStatus.flowering:
        return 'Flowering';
      case CropStatus.ready:
        return 'Ready for Harvest';
      case CropStatus.harvested:
        return 'Harvested';
    }
  }

  String get statusColor {
    switch (this) {
      case CropStatus.planting:
        return '#9E9E9E';
      case CropStatus.growing:
        return '#FFA726';
      case CropStatus.flowering:
        return '#AB47BC';
      case CropStatus.ready:
        return '#66BB6A';
      case CropStatus.harvested:
        return '#42A5F5';
    }
  }
}