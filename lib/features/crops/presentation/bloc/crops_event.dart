import 'package:equatable/equatable.dart';

abstract class CropsEvent extends Equatable {
  const CropsEvent();

  @override
  List<Object?> get props => [];
}

class LoadCrops extends CropsEvent {
  const LoadCrops();
}

class RefreshCrops extends CropsEvent {
  const RefreshCrops();
}

class LoadFinancialDashboard extends CropsEvent {
  final String farmerId;
  final String? seasonId;

  const LoadFinancialDashboard({
    required this.farmerId,
    this.seasonId,
  });

  @override
  List<Object?> get props => [farmerId, seasonId];
}

class AddCrop extends CropsEvent {
  final String name;
  final String emoji;
  final double acres;
  final DateTime plantedDate;
  final DateTime? expectedHarvestDate;
  final double totalInvestment;
  final double expectedRevenue;

  const AddCrop({
    required this.name,
    required this.emoji,
    required this.acres,
    required this.plantedDate,
    this.expectedHarvestDate,
    required this.totalInvestment,
    required this.expectedRevenue,
  });

  @override
  List<Object?> get props => [
        name,
        emoji,
        acres,
        plantedDate,
        expectedHarvestDate,
        totalInvestment,
        expectedRevenue,
      ];
}

class UpdateCropMilestone extends CropsEvent {
  final String cropId;
  final String milestoneId;
  final bool isCompleted;

  const UpdateCropMilestone({
    required this.cropId,
    required this.milestoneId,
    required this.isCompleted,
  });

  @override
  List<Object> get props => [cropId, milestoneId, isCompleted];
}

class AddCropMilestone extends CropsEvent {
  final String cropId;
  final String title;
  final String description;
  final DateTime scheduledDate;
  final String milestoneType;

  const AddCropMilestone({
    required this.cropId,
    required this.title,
    required this.description,
    required this.scheduledDate,
    required this.milestoneType,
  });

  @override
  List<Object> get props => [cropId, title, description, scheduledDate, milestoneType];
}

class ResolveCropIssue extends CropsEvent {
  final String cropId;
  final String issueId;

  const ResolveCropIssue({
    required this.cropId,
    required this.issueId,
  });

  @override
  List<Object> get props => [cropId, issueId];
}

class AddExpense extends CropsEvent {
  final String farmerId;
  final String? cropId;
  final String category;
  final double amount;
  final DateTime date;
  final String notes;

  const AddExpense({
    required this.farmerId,
    this.cropId,
    required this.category,
    required this.amount,
    required this.date,
    required this.notes,
  });

  @override
  List<Object?> get props => [farmerId, cropId, category, amount, date, notes];
}

class AddSale extends CropsEvent {
  final String farmerId;
  final String cropId;
  final double quantity;
  final double pricePerUnit;
  final String buyerName;
  final DateTime date;

  const AddSale({
    required this.farmerId,
    required this.cropId,
    required this.quantity,
    required this.pricePerUnit,
    required this.buyerName,
    required this.date,
  });

  @override
  List<Object> get props => [farmerId, cropId, quantity, pricePerUnit, buyerName, date];
}

class UploadCropImage extends CropsEvent {
  final String cropId;
  final String imagePath;

  const UploadCropImage({
    required this.cropId,
    required this.imagePath,
  });

  @override
  List<Object> get props => [cropId, imagePath];
}