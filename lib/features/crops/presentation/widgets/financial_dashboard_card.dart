import 'package:flutter/material.dart';
import '../../data/models/financial_dashboard.dart';

class FinancialDashboardCard extends StatelessWidget {
  final FinancialDashboard dashboard;

  const FinancialDashboardCard({super.key, required this.dashboard});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF388E3C).withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF388E3C).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.dashboard,
                    color: Color(0xFF388E3C),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Farm Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Financial Metrics
            Row(
              children: [
                Expanded(
                  child: _buildMetricColumn(
                    '₹${_formatAmount(dashboard.totalInvestment)}',
                    'Investment',
                    const Color(0xFF388E3C),
                    Icons.trending_down,
                  ),
                ),
                Container(
                  width: 1,
                  height: 60,
                  color: Colors.black.withValues(alpha: 0.1),
                ),
                Expanded(
                  child: _buildMetricColumn(
                    '₹${_formatAmount(dashboard.expectedRevenue)}',
                    'Expected',
                    const Color(0xFFFFA726),
                    Icons.trending_up,
                  ),
                ),
                Container(
                  width: 1,
                  height: 60,
                  color: Colors.black.withValues(alpha: 0.1),
                ),
                Expanded(
                  child: _buildMetricColumn(
                    '₹${_formatAmount(dashboard.netProfit)}',
                    'Profit',
                    dashboard.isProfitable
                        ? const Color(0xFF388E3C)
                        : const Color(0xFFE53935),
                    dashboard.isProfitable
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Progress indicator
            if (dashboard.expectedRevenue > 0) ...[
              Text(
                'Profit Margin: ${dashboard.profitMargin.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (dashboard.netProfit / dashboard.expectedRevenue).clamp(
                  0.0,
                  1.0,
                ),
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  dashboard.isProfitable
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFE53935),
                ),
                minHeight: 6,
              ),
              const SizedBox(height: 16),
            ],

            // Action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showReportsDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF388E3C),
                  elevation: 0,
                  side: const BorderSide(color: Color(0xFF388E3C), width: 1),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.assessment, size: 20),
                label: const Text(
                  'Reports',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricColumn(
    String amount,
    String label,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 8),
        Text(
          amount,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF666666),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    } else {
      return amount.toStringAsFixed(0);
    }
  }

  void _showReportsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Financial Reports'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReportRow(
                'Total Investment:',
                '₹${_formatAmount(dashboard.totalInvestment)}',
              ),
              _buildReportRow(
                'Expected Revenue:',
                '₹${_formatAmount(dashboard.expectedRevenue)}',
              ),
              _buildReportRow(
                'Actual Revenue:',
                '₹${_formatAmount(dashboard.actualRevenue)}',
              ),
              _buildReportRow(
                'Net Profit:',
                '₹${_formatAmount(dashboard.netProfit)}',
              ),
              _buildReportRow('ROI:', '${dashboard.roi.toStringAsFixed(1)}%'),
              const Divider(),
              _buildReportRow(
                'Total Expenses:',
                '₹${_formatAmount(dashboard.totalExpenses)}',
              ),
              _buildReportRow(
                'Total Sales:',
                '₹${_formatAmount(dashboard.totalSales)}',
              ),
              _buildReportRow(
                'Active Loans:',
                '₹${_formatAmount(dashboard.totalLoans)}',
              ),
              _buildReportRow(
                'Pending Claims:',
                '₹${_formatAmount(dashboard.totalClaims)}',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Navigate to detailed reports page
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF388E3C),
              foregroundColor: Colors.white,
            ),
            child: const Text('View Details'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
