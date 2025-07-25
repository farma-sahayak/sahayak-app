import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/schemes_repository.dart';
import '../../data/models/scheme.dart';
import 'schemes_event.dart';
import 'schemes_state.dart';

class SchemesBloc extends Bloc<SchemesEvent, SchemesState> {
  final SchemesRepository _repository;

  SchemesBloc({required SchemesRepository repository})
    : _repository = repository,
      super(const SchemesState()) {
    on<LoadSchemes>(_onLoadSchemes);
    on<LoadBenefitsOverview>(_onLoadBenefitsOverview);
    on<RefreshSchemes>(_onRefreshSchemes);
    on<ApplyForScheme>(_onApplyForScheme);
    on<CheckSchemeEligibility>(_onCheckSchemeEligibility);
    on<FilterSchemes>(_onFilterSchemes);
    on<PlayAudioGuide>(_onPlayAudioGuide);
    on<DownloadBrochure>(_onDownloadBrochure);
    on<LoadNotifications>(_onLoadNotifications);
  }

  Future<void> _onLoadSchemes(
    LoadSchemes event,
    Emitter<SchemesState> emit,
  ) async {
    emit(state.copyWith(status: SchemesStatus.loading));

    try {
      final schemes = await _repository.getSchemes(
        farmerId: event.farmerId,
        state: event.state,
        crop: event.crop,
        category: event.category,
      );

      emit(
        state.copyWith(
          status: SchemesStatus.success,
          schemes: schemes,
          filteredSchemes: _applyFilters(schemes, state),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: SchemesStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadBenefitsOverview(
    LoadBenefitsOverview event,
    Emitter<SchemesState> emit,
  ) async {
    try {
      final benefitsOverview = await _repository.getBenefitsOverview(
        event.farmerId,
      );
      emit(state.copyWith(benefitsOverview: benefitsOverview));
    } catch (error) {
      emit(state.copyWith(errorMessage: error.toString()));
    }
  }

  Future<void> _onRefreshSchemes(
    RefreshSchemes event,
    Emitter<SchemesState> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true));

    try {
      final schemes = await _repository.getSchemes(
        farmerId: event.farmerId,
        state: event.state,
        crop: event.crop,
        category: event.category,
      );

      emit(
        state.copyWith(
          status: SchemesStatus.success,
          schemes: schemes,
          filteredSchemes: _applyFilters(schemes, state),
          isRefreshing: false,
        ),
      );
    } catch (error) {
      emit(state.copyWith(errorMessage: error.toString(), isRefreshing: false));
    }
  }

  Future<void> _onApplyForScheme(
    ApplyForScheme event,
    Emitter<SchemesState> emit,
  ) async {
    try {
      final result = await _repository.applyForScheme(
        event.farmerId,
        event.schemeId,
      );

      // Update the scheme status to applied
      final updatedSchemes = state.schemes.map((scheme) {
        if (scheme.id == event.schemeId) {
          return scheme.copyWith(
            status: SchemeStatus.applied,
            applicationId: result['tracking_id'],
            progressPercentage: 0.0,
          );
        }
        return scheme;
      }).toList();

      emit(
        state.copyWith(
          schemes: updatedSchemes,
          filteredSchemes: _applyFilters(updatedSchemes, state),
          applicationResult: result,
        ),
      );
    } catch (error) {
      emit(state.copyWith(errorMessage: error.toString()));
    }
  }

  Future<void> _onCheckSchemeEligibility(
    CheckSchemeEligibility event,
    Emitter<SchemesState> emit,
  ) async {
    try {
      final result = await _repository.checkEligibility(
        event.farmerId,
        event.schemeId,
      );

      emit(state.copyWith(eligibilityResult: result));
    } catch (error) {
      emit(state.copyWith(errorMessage: error.toString()));
    }
  }

  void _onFilterSchemes(FilterSchemes event, Emitter<SchemesState> emit) {
    final filteredSchemes = _applyFilters(
      state.schemes,
      state.copyWith(
        selectedStatusFilter: event.status,
        selectedCategoryFilter: event.category,
        searchQuery: event.searchQuery,
      ),
    );

    emit(
      state.copyWith(
        filteredSchemes: filteredSchemes,
        selectedStatusFilter: event.status,
        selectedCategoryFilter: event.category,
        searchQuery: event.searchQuery,
      ),
    );
  }

  void _onPlayAudioGuide(PlayAudioGuide event, Emitter<SchemesState> emit) {
    // TODO: Implement audio playback functionality
    // This would typically involve using an audio player package
    // For now, we'll just emit a success state
    print('Playing audio guide: ${event.audioUrl}');
  }

  void _onDownloadBrochure(DownloadBrochure event, Emitter<SchemesState> emit) {
    // TODO: Implement brochure download functionality
    // This would typically involve downloading the file and saving it locally
    // For now, we'll just emit a success state
    print('Downloading brochure: ${event.brochureUrl}');
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<SchemesState> emit,
  ) async {
    try {
      final notifications = await _repository.getNotifications(event.farmerId);
      emit(state.copyWith(notifications: notifications));
    } catch (error) {
      emit(state.copyWith(errorMessage: error.toString()));
    }
  }

  List<Scheme> _applyFilters(List<Scheme> schemes, SchemesState currentState) {
    var filtered = schemes;

    // Apply status filter
    if (currentState.selectedStatusFilter != null) {
      filtered = filtered
          .where((scheme) => scheme.status == currentState.selectedStatusFilter)
          .toList();
    }

    // Apply category filter
    if (currentState.selectedCategoryFilter != null) {
      filtered = filtered
          .where(
            (scheme) => scheme.category == currentState.selectedCategoryFilter,
          )
          .toList();
    }

    // Apply search query
    if (currentState.searchQuery != null &&
        currentState.searchQuery!.isNotEmpty) {
      final query = currentState.searchQuery!.toLowerCase();
      filtered = filtered.where((scheme) {
        return scheme.title.toLowerCase().contains(query) ||
            scheme.description.toLowerCase().contains(query) ||
            scheme.provider.toLowerCase().contains(query) ||
            scheme.tags.any((tag) => tag.toLowerCase().contains(query));
      }).toList();
    }

    return filtered;
  }

  @override
  Future<void> close() {
    _repository.dispose();
    return super.close();
  }
}
