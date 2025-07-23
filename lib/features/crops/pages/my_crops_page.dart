import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/crops_bloc.dart';
import '../bloc/crops_event.dart';
import '../bloc/crops_state.dart';
import '../widgets/financial_dashboard_card.dart';
import '../widgets/crop_detailed_card.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/add_crop_dialog.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/widgets/app_header.dart';

class MyCropsPage extends StatelessWidget {
  const MyCropsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CropsBloc, CropsState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<CropsBloc>().add(const RefreshCrops());
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppConstants.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title and add button
                AppHeader(
                  title: '🌾 My Crops',
                  subtitle: state is CropsLoaded 
                      ? 'Manage ${state.crops.length} crops • ${state.crops.fold<double>(0, (sum, crop) => sum + crop.acres).toStringAsFixed(1)} acres'
                      : null,
                  actions: [
                    IconButton(
                      onPressed: () => _showAddCropDialog(context),
                      icon: const Icon(
                        Icons.add_circle,
                        color: Color(0xFF388E3C),
                        size: 28,
                      ),
                      tooltip: 'Add Crop',
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.largePadding),
                
                // Farm Overview (Financial Dashboard)
                if (state is CropsLoaded && state.financialDashboard != null)
                                      FinancialDashboardCard(
                      dashboard: state.financialDashboard!,
                    ),
                const SizedBox(height: AppConstants.largePadding),
                
                // My Crops Section
                _buildMyCropsSection(context, state),
                const SizedBox(height: AppConstants.largePadding),
                
                // Quick Actions
                const QuickActionsGrid(),
                const SizedBox(height: AppConstants.largePadding),
              ],
            ),
          ),
        );
      },
    );
  }



  Widget _buildMyCropsSection(BuildContext context, CropsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Crops',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF388E3C),
          ),
        ),
        const SizedBox(height: AppConstants.mediumPadding),
        
        if (state is CropsLoading)
          const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF388E3C),
            ),
          )
        else if (state is CropsLoaded)
          state.crops.isEmpty
              ? _buildEmptyState(context)
              : Column(
                  children: state.crops
                      .map((crop) => Padding(
                            padding: const EdgeInsets.only(bottom: AppConstants.screenPadding),
                            child: CropDetailedCard(crop: crop),
                          ))
                      .toList(),
                )
        else if (state is CropsError)
          _buildErrorState(context, state.message)
        else
          _buildEmptyState(context),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.agriculture,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No crops yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start by adding your first crop to track its progress and manage your farm',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _showAddCropDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF388E3C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add Your First Crop'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red[400],
          ),
          const SizedBox(height: 12),
          Text(
            'Error Loading Crops',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.red[700],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<CropsBloc>().add(const LoadCrops());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showAddCropDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<CropsBloc>(),
        child: const AddCropDialog(),
      ),
    );
  }
}