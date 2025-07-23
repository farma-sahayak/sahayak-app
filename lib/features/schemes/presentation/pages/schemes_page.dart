import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_header.dart';
import '../../../../core/theme/sahayak_theme.dart';
import '../bloc/schemes_bloc.dart';
import '../bloc/schemes_event.dart';
import '../bloc/schemes_state.dart';
import '../../data/models/scheme.dart';
import '../../data/repositories/schemes_repository.dart';
import '../widgets/benefits_overview_card.dart';
import '../widgets/scheme_card.dart';
import '../widgets/help_documents_section.dart';

class SchemesPage extends StatelessWidget {
  const SchemesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SchemesBloc(repository: SchemesRepository())
        ..add(const LoadSchemes(farmerId: 'farmer_123'))
        ..add(const LoadBenefitsOverview(farmerId: 'farmer_123')),
      child: const _SchemesPageView(),
    );
  }
}

class _SchemesPageView extends StatefulWidget {
  const _SchemesPageView();

  @override
  State<_SchemesPageView> createState() => _SchemesPageViewState();
}

class _SchemesPageViewState extends State<_SchemesPageView> {
  SchemeStatus? _selectedStatusFilter;
  SchemeCategory? _selectedCategoryFilter;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<SchemesBloc>().add(
              const RefreshSchemes(farmerId: 'farmer_123'),
            );
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                AppHeader(
                  title: 'Government Schemes',
                  subtitle: 'Discover & apply for benefits',
                  leadingIcon: Icons.policy,
                  actions: [
                    IconButton(
                      onPressed: () => _showFilterBottomSheet(context),
                      icon: Icon(
                        Icons.filter_list,
                        color: primaryColor,
                        size: AppConstants.iconLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.largePadding),

                // Benefits Overview
                BlocBuilder<SchemesBloc, SchemesState>(
                  builder: (context, state) {
                    if (state.benefitsOverview != null) {
                      return Column(
                        children: [
                          BenefitsOverviewCard(
                            benefitsOverview: state.benefitsOverview!,
                          ),
                          const SizedBox(height: AppConstants.largePadding),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                // Search bar
                _SearchBar(
                  controller: _searchController,
                  onChanged: (query) {
                    context.read<SchemesBloc>().add(
                      FilterSchemes(
                        status: _selectedStatusFilter,
                        category: _selectedCategoryFilter,
                        searchQuery: query,
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppConstants.largePadding),

                // Filter chips
                BlocBuilder<SchemesBloc, SchemesState>(
                  builder: (context, state) {
                    return _FilterChips(
                      selectedStatus: _selectedStatusFilter,
                      selectedCategory: _selectedCategoryFilter,
                      onStatusChanged: (status) {
                        setState(() {
                          _selectedStatusFilter = status;
                        });
                        context.read<SchemesBloc>().add(
                          FilterSchemes(
                            status: status,
                            category: _selectedCategoryFilter,
                            searchQuery: _searchController.text,
                          ),
                        );
                      },
                      onCategoryChanged: (category) {
                        setState(() {
                          _selectedCategoryFilter = category;
                        });
                        context.read<SchemesBloc>().add(
                          FilterSchemes(
                            status: _selectedStatusFilter,
                            category: category,
                            searchQuery: _searchController.text,
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: AppConstants.mediumPadding),

                // Section header
                Row(
                  children: [
                    Icon(
                      Icons.list_alt,
                      color: primaryColor,
                      size: AppConstants.iconMedium,
                    ),
                    const SizedBox(width: AppConstants.smallPadding),
                    Text(
                      'Available Schemes',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.mediumPadding),

                // Schemes list
                BlocBuilder<SchemesBloc, SchemesState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const _LoadingView();
                    }

                    if (state.hasError) {
                      return _ErrorView(
                        message: state.errorMessage ?? 'Failed to load schemes',
                        onRetry: () {
                          context.read<SchemesBloc>().add(
                            const LoadSchemes(farmerId: 'farmer_123'),
                          );
                        },
                      );
                    }

                    if (state.isEmpty) {
                      return const _EmptyView();
                    }

                    final schemesToShow =
                        state.filteredSchemes.isNotEmpty || _hasActiveFilters()
                        ? state.filteredSchemes
                        : state.schemes;

                    if (schemesToShow.isEmpty && _hasActiveFilters()) {
                      return const _NoResultsView();
                    }

                    return Column(
                      children: [
                        // View all button if there are more schemes
                        if (schemesToShow.length < state.schemes.length) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(
                              AppConstants.mediumPadding,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(
                                AppConstants.mediumRadius,
                              ),
                              border: Border.all(
                                color: primaryColor.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Showing ${schemesToShow.length} of ${state.schemes.length} schemes',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: textSecondary,
                                  ),
                                ),
                                const SizedBox(
                                  height: AppConstants.smallPadding,
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Clear filters to show all schemes
                                    setState(() {
                                      _selectedStatusFilter = null;
                                      _selectedCategoryFilter = null;
                                    });
                                    _searchController.clear();
                                    context.read<SchemesBloc>().add(
                                      const FilterSchemes(),
                                    );
                                  },
                                  child: const Text('View All Schemes'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppConstants.mediumPadding),
                        ],

                        // Schemes
                        ...schemesToShow.map(
                          (scheme) => SchemeCard(
                            scheme: scheme,
                            onApply: () =>
                                _handleApplyForScheme(context, scheme),
                            onTrack: () =>
                                _handleTrackApplication(context, scheme),
                            onInfo: () =>
                                _handleShowSchemeInfo(context, scheme),
                            onPlayAudio: () =>
                                _handlePlayAudio(context, scheme),
                            onDownloadBrochure: () =>
                                _handleDownloadBrochure(context, scheme),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppConstants.largePadding),

                // Help & Documents Section
                HelpDocumentsSection(
                  onDocumentsList: () => _handleDocumentsList(context),
                  onForms: () => _handleForms(context),
                  onAudioGuide: () => _handleAudioGuide(context),
                  onApplicationGuide: () => _handleApplicationGuide(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _hasActiveFilters() {
    return _selectedStatusFilter != null ||
        _selectedCategoryFilter != null ||
        _searchController.text.isNotEmpty;
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _FilterBottomSheet(
        selectedStatus: _selectedStatusFilter,
        selectedCategory: _selectedCategoryFilter,
        onApply: (status, category) {
          setState(() {
            _selectedStatusFilter = status;
            _selectedCategoryFilter = category;
          });
          context.read<SchemesBloc>().add(
            FilterSchemes(
              status: status,
              category: category,
              searchQuery: _searchController.text,
            ),
          );
        },
      ),
    );
  }

  void _handleApplyForScheme(BuildContext context, Scheme scheme) {
    context.read<SchemesBloc>().add(
      ApplyForScheme(farmerId: 'farmer_123', schemeId: scheme.id),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Application submitted for ${scheme.title}'),
        backgroundColor: successColor,
      ),
    );
  }

  void _handleTrackApplication(BuildContext context, Scheme scheme) {
    // TODO: Navigate to tracking page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tracking ${scheme.title} application')),
    );
  }

  void _handleShowSchemeInfo(BuildContext context, Scheme scheme) {
    // TODO: Show scheme details modal or navigate to details page
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(scheme.title),
        content: Text(scheme.description),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handlePlayAudio(BuildContext context, Scheme scheme) {
    if (scheme.audioGuideUrl != null) {
      context.read<SchemesBloc>().add(
        PlayAudioGuide(audioUrl: scheme.audioGuideUrl!),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Playing audio guide...')));
    }
  }

  void _handleDownloadBrochure(BuildContext context, Scheme scheme) {
    if (scheme.brochureUrl != null) {
      context.read<SchemesBloc>().add(
        DownloadBrochure(
          brochureUrl: scheme.brochureUrl!,
          schemeName: scheme.title,
        ),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Downloading brochure...')));
    }
  }

  void _handleDocumentsList(BuildContext context) {
    // TODO: Navigate to documents list page
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Opening documents list...')));
  }

  void _handleForms(BuildContext context) {
    // TODO: Navigate to forms page
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Opening forms...')));
  }

  void _handleAudioGuide(BuildContext context) {
    // TODO: Play general audio guide
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Playing audio guide...')));
  }

  void _handleApplicationGuide(BuildContext context) {
    // TODO: Play application guide
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Playing application guide...')),
    );
  }
}

// Search Bar Widget
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.pillRadius),
        border: Border.all(color: theme.dividerColor),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search schemes...',
          prefixIcon: Icon(
            Icons.search,
            color: textSecondary,
            size: AppConstants.iconMedium,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                  icon: Icon(
                    Icons.clear,
                    color: textSecondary,
                    size: AppConstants.iconMedium,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.mediumPadding,
            vertical: AppConstants.mediumPadding,
          ),
        ),
      ),
    );
  }
}

// Filter Chips Widget
class _FilterChips extends StatelessWidget {
  final SchemeStatus? selectedStatus;
  final SchemeCategory? selectedCategory;
  final ValueChanged<SchemeStatus?> onStatusChanged;
  final ValueChanged<SchemeCategory?> onCategoryChanged;

  const _FilterChips({
    this.selectedStatus,
    this.selectedCategory,
    required this.onStatusChanged,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status filters
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _FilterChip(
                label: 'All',
                isSelected: selectedStatus == null,
                onTap: () => onStatusChanged(null),
              ),
              const SizedBox(width: AppConstants.smallPadding),
              _FilterChip(
                label: 'Eligible',
                isSelected: selectedStatus == SchemeStatus.eligible,
                onTap: () => onStatusChanged(SchemeStatus.eligible),
              ),
              const SizedBox(width: AppConstants.smallPadding),
              _FilterChip(
                label: 'Applied',
                isSelected: selectedStatus == SchemeStatus.applied,
                onTap: () => onStatusChanged(SchemeStatus.applied),
              ),
              const SizedBox(width: AppConstants.smallPadding),
              _FilterChip(
                label: 'Approved',
                isSelected: selectedStatus == SchemeStatus.approved,
                onTap: () => onStatusChanged(SchemeStatus.approved),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),
        // Category filters
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _FilterChip(
                label: 'All Categories',
                isSelected: selectedCategory == null,
                onTap: () => onCategoryChanged(null),
              ),
              const SizedBox(width: AppConstants.smallPadding),
              _FilterChip(
                label: 'Income',
                isSelected: selectedCategory == SchemeCategory.income,
                onTap: () => onCategoryChanged(SchemeCategory.income),
              ),
              const SizedBox(width: AppConstants.smallPadding),
              _FilterChip(
                label: 'Insurance',
                isSelected: selectedCategory == SchemeCategory.insurance,
                onTap: () => onCategoryChanged(SchemeCategory.insurance),
              ),
              const SizedBox(width: AppConstants.smallPadding),
              _FilterChip(
                label: 'Subsidy',
                isSelected: selectedCategory == SchemeCategory.subsidy,
                onTap: () => onCategoryChanged(SchemeCategory.subsidy),
              ),
              const SizedBox(width: AppConstants.smallPadding),
              _FilterChip(
                label: 'Loan',
                isSelected: selectedCategory == SchemeCategory.loan,
                onTap: () => onCategoryChanged(SchemeCategory.loan),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.mediumPadding,
          vertical: AppConstants.smallPadding,
        ),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppConstants.pillRadius),
          border: Border.all(
            color: isSelected ? primaryColor : theme.dividerColor,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isSelected ? Colors.white : textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// Loading View
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: AppConstants.mediumPadding),
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

// Error View
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.largePadding),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 64, color: errorColor),
          const SizedBox(height: AppConstants.mediumPadding),
          Text(
            'Oops! Something went wrong',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(color: textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.largePadding),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}

// Empty View
class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.largePadding),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: textSecondary),
          const SizedBox(height: AppConstants.mediumPadding),
          Text(
            'No schemes available',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            'Check back later for new schemes',
            style: theme.textTheme.bodyMedium?.copyWith(color: textSecondary),
          ),
        ],
      ),
    );
  }
}

// No Results View
class _NoResultsView extends StatelessWidget {
  const _NoResultsView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.largePadding),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 64, color: textSecondary),
          const SizedBox(height: AppConstants.mediumPadding),
          Text(
            'No schemes found',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            'Try adjusting your filters or search terms',
            style: theme.textTheme.bodyMedium?.copyWith(color: textSecondary),
          ),
        ],
      ),
    );
  }
}

// Filter Bottom Sheet
class _FilterBottomSheet extends StatefulWidget {
  final SchemeStatus? selectedStatus;
  final SchemeCategory? selectedCategory;
  final Function(SchemeStatus?, SchemeCategory?) onApply;

  const _FilterBottomSheet({
    this.selectedStatus,
    this.selectedCategory,
    required this.onApply,
  });

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  SchemeStatus? _tempStatus;
  SchemeCategory? _tempCategory;

  @override
  void initState() {
    super.initState();
    _tempStatus = widget.selectedStatus;
    _tempCategory = widget.selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.largePadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Filter Schemes',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  setState(() {
                    _tempStatus = null;
                    _tempCategory = null;
                  });
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.largePadding),

          // Status filter
          Text(
            'Status',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Wrap(
            spacing: AppConstants.smallPadding,
            children: [
              for (final status in SchemeStatus.values)
                ChoiceChip(
                  label: Text(_getStatusLabel(status)),
                  selected: _tempStatus == status,
                  onSelected: (selected) {
                    setState(() {
                      _tempStatus = selected ? status : null;
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: AppConstants.largePadding),

          // Category filter
          Text(
            'Category',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Wrap(
            spacing: AppConstants.smallPadding,
            children: [
              for (final category in SchemeCategory.values)
                ChoiceChip(
                  label: Text(_getCategoryLabel(category)),
                  selected: _tempCategory == category,
                  onSelected: (selected) {
                    setState(() {
                      _tempCategory = selected ? category : null;
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: AppConstants.largePadding),

          // Apply button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(_tempStatus, _tempCategory);
                Navigator.of(context).pop();
              },
              child: const Text('Apply Filters'),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  String _getStatusLabel(SchemeStatus status) {
    switch (status) {
      case SchemeStatus.eligible:
        return 'Eligible';
      case SchemeStatus.applied:
        return 'Applied';
      case SchemeStatus.approved:
        return 'Approved';
      case SchemeStatus.rejected:
        return 'Rejected';
      case SchemeStatus.notEligible:
        return 'Not Eligible';
    }
  }

  String _getCategoryLabel(SchemeCategory category) {
    switch (category) {
      case SchemeCategory.income:
        return 'Income';
      case SchemeCategory.insurance:
        return 'Insurance';
      case SchemeCategory.subsidy:
        return 'Subsidy';
      case SchemeCategory.loan:
        return 'Loan';
      case SchemeCategory.training:
        return 'Training';
      case SchemeCategory.other:
        return 'Other';
    }
  }
}
