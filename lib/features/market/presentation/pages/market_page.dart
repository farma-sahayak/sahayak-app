import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/market_bloc.dart';
import '../bloc/market_event.dart';
import '../bloc/market_state.dart';
import '../../data/models/market_price.dart';
import '../../data/models/market_insight.dart';
import '../widgets/price_card.dart';
import '../widgets/search_prices_card.dart';
import '../widgets/market_insights_card.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_header.dart';

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketBloc, MarketState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<MarketBloc>().add(const RefreshMarketData());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppConstants.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    AppHeader(
                      title: 'Market Prices',
                      subtitle: 'Live APMC prices • Updated every 30 min',
                      leadingIcon: Icons.show_chart,
                    ),
                    const SizedBox(height: AppConstants.largePadding),

                    // Search Prices Card
                    const SearchPricesCard(),
                    const SizedBox(height: AppConstants.largePadding),

                    // Live Prices Section
                    _buildLivePricesSection(context, state),
                    const SizedBox(height: AppConstants.largePadding),

                    // Market Insights
                    _buildMarketInsightsSection(state),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLivePricesSection(BuildContext context, MarketState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with title and refresh icon
        Row(
          children: [
            const Icon(
              Icons.currency_rupee,
              color: Color(0xFF388E3C),
              size: AppConstants.iconMedium,
            ),
            const SizedBox(width: AppConstants.smallPadding),
            Text('Live Prices', style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            GestureDetector(
              onTap: () {
                context.read<MarketBloc>().add(const RefreshMarketData());
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF388E3C).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.refresh,
                  color: Color(0xFF388E3C),
                  size: 18,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Prices list
        if (state is MarketLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          )
        else if (state is MarketLoaded)
          Column(
            children: [
              ...state.currentPrices.map((price) => PriceCard(price: price)),
              // View All Crops button
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 8),
                child: TextButton(
                  onPressed: () {
                    // Navigate to all crops view
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFF8F9FA),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey[300]!, width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.visibility,
                        color: Color(0xFF388E3C),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'View All 5 Crops',
                        style: TextStyle(
                          color: Color(0xFF388E3C),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        else if (state is MarketError)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Text(
              state.message,
              style: TextStyle(
                color: Colors.red[700],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  Widget _buildMarketInsightsSection(MarketState state) {
    if (state is MarketLoaded && state.insights.isNotEmpty) {
      return MarketInsightsCard(insights: state.insights);
    }
    return const SizedBox.shrink();
  }
}
