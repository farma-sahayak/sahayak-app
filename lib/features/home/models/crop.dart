class Crop {
  final String id;
  final String name;
  final String emoji;
  final CropStatus status;
  final int healthPercentage;
  final DateTime plantedDate;
  final DateTime? expectedHarvestDate;
  final String? imageUrl;

  const Crop({
    required this.id,
    required this.name,
    required this.emoji,
    required this.status,
    required this.healthPercentage,
    required this.plantedDate,
    this.expectedHarvestDate,
    this.imageUrl,
  });

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      id: json['id'],
      name: json['name'],
      emoji: json['emoji'],
      status: CropStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => CropStatus.growing,
      ),
      healthPercentage: json['healthPercentage'],
      plantedDate: DateTime.parse(json['plantedDate']),
      expectedHarvestDate: json['expectedHarvestDate'] != null
          ? DateTime.parse(json['expectedHarvestDate'])
          : null,
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'emoji': emoji,
      'status': status.name,
      'healthPercentage': healthPercentage,
      'plantedDate': plantedDate.toIso8601String(),
      'expectedHarvestDate': expectedHarvestDate?.toIso8601String(),
      'imageUrl': imageUrl,
    };
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
        return 'Ready';
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