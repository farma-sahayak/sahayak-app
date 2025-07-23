import 'package:equatable/equatable.dart';
import '../../data/models/scheme.dart';
import '../../data/models/benefits_overview.dart';

enum SchemesStatus { initial, loading, success, failure }

class SchemesState extends Equatable {
  final SchemesStatus status;
  final List<Scheme> schemes;
  final List<Scheme> filteredSchemes;
  final BenefitsOverview? benefitsOverview;
  final String? errorMessage;
  final bool isRefreshing;
  final Map<String, dynamic>? eligibilityResult;
  final Map<String, dynamic>? applicationResult;
  final List<Map<String, dynamic>> notifications;
  final SchemeStatus? selectedStatusFilter;
  final SchemeCategory? selectedCategoryFilter;
  final String? searchQuery;

  const SchemesState({
    this.status = SchemesStatus.initial,
    this.schemes = const [],
    this.filteredSchemes = const [],
    this.benefitsOverview,
    this.errorMessage,
    this.isRefreshing = false,
    this.eligibilityResult,
    this.applicationResult,
    this.notifications = const [],
    this.selectedStatusFilter,
    this.selectedCategoryFilter,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [
    status,
    schemes,
    filteredSchemes,
    benefitsOverview,
    errorMessage,
    isRefreshing,
    eligibilityResult,
    applicationResult,
    notifications,
    selectedStatusFilter,
    selectedCategoryFilter,
    searchQuery,
  ];

  SchemesState copyWith({
    SchemesStatus? status,
    List<Scheme>? schemes,
    List<Scheme>? filteredSchemes,
    BenefitsOverview? benefitsOverview,
    String? errorMessage,
    bool? isRefreshing,
    Map<String, dynamic>? eligibilityResult,
    Map<String, dynamic>? applicationResult,
    List<Map<String, dynamic>>? notifications,
    SchemeStatus? selectedStatusFilter,
    SchemeCategory? selectedCategoryFilter,
    String? searchQuery,
  }) {
    return SchemesState(
      status: status ?? this.status,
      schemes: schemes ?? this.schemes,
      filteredSchemes: filteredSchemes ?? this.filteredSchemes,
      benefitsOverview: benefitsOverview ?? this.benefitsOverview,
      errorMessage: errorMessage ?? this.errorMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      eligibilityResult: eligibilityResult ?? this.eligibilityResult,
      applicationResult: applicationResult ?? this.applicationResult,
      notifications: notifications ?? this.notifications,
      selectedStatusFilter: selectedStatusFilter ?? this.selectedStatusFilter,
      selectedCategoryFilter:
          selectedCategoryFilter ?? this.selectedCategoryFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  // Helper getters
  List<Scheme> get eligibleSchemes =>
      schemes.where((s) => s.status == SchemeStatus.eligible).toList();
  List<Scheme> get appliedSchemes =>
      schemes.where((s) => s.status == SchemeStatus.applied).toList();
  List<Scheme> get notEligibleSchemes =>
      schemes.where((s) => s.status == SchemeStatus.notEligible).toList();
  List<Scheme> get approvedSchemes =>
      schemes.where((s) => s.status == SchemeStatus.approved).toList();
  List<Scheme> get rejectedSchemes =>
      schemes.where((s) => s.status == SchemeStatus.rejected).toList();

  bool get hasError => status == SchemesStatus.failure;
  bool get isLoading => status == SchemesStatus.loading;
  bool get isLoaded => status == SchemesStatus.success;
  bool get isEmpty => schemes.isEmpty && status == SchemesStatus.success;
}
