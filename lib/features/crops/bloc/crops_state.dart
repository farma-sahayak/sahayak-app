import 'package:equatable/equatable.dart';
import '../models/crop_detailed.dart';
import '../models/financial_dashboard.dart';

abstract class CropsState extends Equatable {
  const CropsState();

  @override
  List<Object?> get props => [];
}

class CropsInitial extends CropsState {}

class CropsLoading extends CropsState {}

class CropsLoaded extends CropsState {
  final List<CropDetailed> crops;
  final FinancialDashboard? financialDashboard;

  const CropsLoaded({
    required this.crops,
    this.financialDashboard,
  });

  @override
  List<Object?> get props => [crops, financialDashboard];

  CropsLoaded copyWith({
    List<CropDetailed>? crops,
    FinancialDashboard? financialDashboard,
  }) {
    return CropsLoaded(
      crops: crops ?? this.crops,
      financialDashboard: financialDashboard ?? this.financialDashboard,
    );
  }
}

class CropsError extends CropsState {
  final String message;

  const CropsError(this.message);

  @override
  List<Object> get props => [message];
}

class CropAdding extends CropsState {}

class CropAdded extends CropsState {
  final CropDetailed crop;

  const CropAdded(this.crop);

  @override
  List<Object> get props => [crop];
}

class CropAddError extends CropsState {
  final String message;

  const CropAddError(this.message);

  @override
  List<Object> get props => [message];
}

class MilestoneUpdating extends CropsState {}

class MilestoneUpdated extends CropsState {
  final String cropId;
  final String milestoneId;

  const MilestoneUpdated(this.cropId, this.milestoneId);

  @override
  List<Object> get props => [cropId, milestoneId];
}

class ExpenseAdding extends CropsState {}

class ExpenseAdded extends CropsState {
  final String message;

  const ExpenseAdded(this.message);

  @override
  List<Object> get props => [message];
}

class SaleAdding extends CropsState {}

class SaleAdded extends CropsState {
  final String message;

  const SaleAdded(this.message);

  @override
  List<Object> get props => [message];
}

class ImageUploading extends CropsState {}

class ImageUploaded extends CropsState {
  final String cropId;
  final String imageUrl;

  const ImageUploaded(this.cropId, this.imageUrl);

  @override
  List<Object> get props => [cropId, imageUrl];
}