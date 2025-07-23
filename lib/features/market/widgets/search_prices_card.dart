import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/market_bloc.dart';
import '../bloc/market_event.dart';

class SearchPricesCard extends StatefulWidget {
  const SearchPricesCard({super.key});

  @override
  State<SearchPricesCard> createState() => _SearchPricesCardState();
}

class _SearchPricesCardState extends State<SearchPricesCard> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E8), // Light green background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF388E3C).withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF388E3C),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Search Prices',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Subtitle
          Text(
            'Find crop best market',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search crop prices',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF388E3C),
                  size: 20,
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    if (_searchController.text.isNotEmpty) {
                      context
                          .read<MarketBloc>()
                          .add(SearchCropPrices(_searchController.text));
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF388E3C),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  context.read<MarketBloc>().add(SearchCropPrices(value));
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          
          // Quick stats
          Row(
            children: [
              _buildQuickStat('5', 'Available', Colors.black),
              const SizedBox(width: 24),
              _buildQuickStat('3', 'Down', Colors.red),
              const SizedBox(width: 24),
              _buildQuickStat('2', 'Up', const Color(0xFF388E3C)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}