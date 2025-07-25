import 'package:flutter_bloc/flutter_bloc.dart';
import 'crops_event.dart';
import 'crops_state.dart';
import '../../data/repositories/crops_repository.dart';

class CropsBloc extends Bloc<CropsEvent, CropsState> {
  final CropsRepository repository;

  CropsBloc({required this.repository}) : super(CropsInitial()) {
    on<LoadCrops>(_onLoadCrops);
    on<RefreshCrops>(_onRefreshCrops);
    on<LoadFinancialDashboard>(_onLoadFinancialDashboard);
    on<AddCrop>(_onAddCrop);
    on<UpdateCropMilestone>(_onUpdateCropMilestone);
    on<AddCropMilestone>(_onAddCropMilestone);
    on<ResolveCropIssue>(_onResolveCropIssue);
    on<AddExpense>(_onAddExpense);
    on<AddSale>(_onAddSale);
    on<UploadCropImage>(_onUploadCropImage);
  }

  Future<void> _onLoadCrops(LoadCrops event, Emitter<CropsState> emit) async {
    emit(CropsLoading());
    try {
      final crops = await repository.getCrops();
      final financialDashboard = await repository.getFinancialDashboard(
        'farmer_123',
      );
      emit(CropsLoaded(crops: crops, financialDashboard: financialDashboard));
    } catch (e) {
      emit(CropsError(e.toString()));
    }
  }

  Future<void> _onRefreshCrops(
    RefreshCrops event,
    Emitter<CropsState> emit,
  ) async {
    try {
      final crops = await repository.getCrops();
      final financialDashboard = await repository.getFinancialDashboard(
        'farmer_123',
      );
      emit(CropsLoaded(crops: crops, financialDashboard: financialDashboard));
    } catch (e) {
      emit(CropsError(e.toString()));
    }
  }

  Future<void> _onLoadFinancialDashboard(
    LoadFinancialDashboard event,
    Emitter<CropsState> emit,
  ) async {
    try {
      final financialDashboard = await repository.getFinancialDashboard(
        event.farmerId,
        event.seasonId,
      );

      if (state is CropsLoaded) {
        final currentState = state as CropsLoaded;
        emit(currentState.copyWith(financialDashboard: financialDashboard));
      } else {
        final crops = await repository.getCrops();
        emit(CropsLoaded(crops: crops, financialDashboard: financialDashboard));
      }
    } catch (e) {
      emit(CropsError(e.toString()));
    }
  }

  Future<void> _onAddCrop(AddCrop event, Emitter<CropsState> emit) async {
    emit(CropAdding());
    try {
      final newCrop = await repository.addCrop(
        name: event.name,
        emoji: event.emoji,
        acres: event.acres,
        plantedDate: event.plantedDate,
        expectedHarvestDate: event.expectedHarvestDate,
        totalInvestment: event.totalInvestment,
        expectedRevenue: event.expectedRevenue,
      );

      emit(CropAdded(newCrop));

      // Reload crops to show the updated list
      add(const LoadCrops());
    } catch (e) {
      emit(CropAddError(e.toString()));
    }
  }

  Future<void> _onUpdateCropMilestone(
    UpdateCropMilestone event,
    Emitter<CropsState> emit,
  ) async {
    emit(MilestoneUpdating());
    try {
      await repository.updateMilestone(
        event.cropId,
        event.milestoneId,
        event.isCompleted,
      );
      emit(MilestoneUpdated(event.cropId, event.milestoneId));

      // Reload crops to show the updated milestones
      add(const RefreshCrops());
    } catch (e) {
      emit(CropsError(e.toString()));
    }
  }

  Future<void> _onAddCropMilestone(
    AddCropMilestone event,
    Emitter<CropsState> emit,
  ) async {
    try {
      // In a real implementation, this would call repository.addMilestone
      // For now, we'll just refresh the crops
      add(const RefreshCrops());
    } catch (e) {
      emit(CropsError(e.toString()));
    }
  }

  Future<void> _onResolveCropIssue(
    ResolveCropIssue event,
    Emitter<CropsState> emit,
  ) async {
    try {
      // In a real implementation, this would call repository.resolveIssue
      // For now, we'll just refresh the crops
      add(const RefreshCrops());
    } catch (e) {
      emit(CropsError(e.toString()));
    }
  }

  Future<void> _onAddExpense(AddExpense event, Emitter<CropsState> emit) async {
    emit(ExpenseAdding());
    try {
      await repository.addExpense(
        farmerId: event.farmerId,
        cropId: event.cropId,
        category: event.category,
        amount: event.amount,
        date: event.date,
        notes: event.notes,
      );

      emit(const ExpenseAdded('Expense added successfully'));

      // Reload financial dashboard
      add(LoadFinancialDashboard(farmerId: event.farmerId));
    } catch (e) {
      emit(CropsError(e.toString()));
    }
  }

  Future<void> _onAddSale(AddSale event, Emitter<CropsState> emit) async {
    emit(SaleAdding());
    try {
      await repository.addSale(
        farmerId: event.farmerId,
        cropId: event.cropId,
        quantity: event.quantity,
        pricePerUnit: event.pricePerUnit,
        buyerName: event.buyerName,
        date: event.date,
      );

      emit(const SaleAdded('Sale recorded successfully'));

      // Reload financial dashboard
      add(LoadFinancialDashboard(farmerId: event.farmerId));
    } catch (e) {
      emit(CropsError(e.toString()));
    }
  }

  Future<void> _onUploadCropImage(
    UploadCropImage event,
    Emitter<CropsState> emit,
  ) async {
    emit(ImageUploading());
    try {
      final imageUrl = await repository.uploadCropImage(
        event.cropId,
        event.imagePath,
      );
      emit(ImageUploaded(event.cropId, imageUrl));

      // Reload crops to show the updated image
      add(const RefreshCrops());
    } catch (e) {
      emit(CropsError(e.toString()));
    }
  }
}
