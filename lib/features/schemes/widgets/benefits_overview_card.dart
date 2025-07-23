import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../theme.dart';
import '../models/benefits_overview.dart';

class BenefitsOverviewCard extends StatelessWidget {
  final BenefitsOverview benefitsOverview;

  const BenefitsOverviewCard({
    super.key,
    required this.benefitsOverview,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberFormat = NumberFormat('#,##,###');

    return GradientCard(
      gradientColors: [
        primaryColor.withOpacity(0.1),
        primaryColor.withOpacity(0.05),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                color: primaryColor,
                size: AppConstants.iconLarge,
              ),
              const SizedBox(width: AppConstants.smallPadding),
              Expanded(
                child: Text(
                  'Your Benefits Overview',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.largePadding),

          // Main stats row
          Row(
            children: [
              Expanded(
                child: _StatColumn(
                  title: 'Total Potential Benefit',
                  value: '${benefitsOverview.currency}${numberFormat.format(benefitsOverview.totalPotentialBenefit)}',
                  subtitle: 'per year',
                  icon: Icons.trending_up,
                  color: primaryColor,
                ),
              ),
              Container(
                width: 1,
                height: 60,
                color: theme.dividerColor,
                margin: const EdgeInsets.symmetric(horizontal: AppConstants.mediumPadding),
              ),
              Expanded(
                child: _StatColumn(
                  title: 'Available Now',
                  value: '${benefitsOverview.availableNow}',
                  subtitle: 'schemes ready',
                  icon: Icons.check_circle_outline,
                  color: successColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.largePadding),

          // Status breakdown
          Container(
            padding: const EdgeInsets.all(AppConstants.mediumPadding),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Application Status',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppConstants.mediumPadding),
                Row(
                  children: [
                    Expanded(
                      child: _StatusBox(
                        label: 'Eligible',
                        count: benefitsOverview.eligible,
                        color: greenLight,
                        textColor: primaryColor,
                        icon: Icons.check_circle,
                      ),
                    ),
                    const SizedBox(width: AppConstants.smallPadding),
                    Expanded(
                      child: _StatusBox(
                        label: 'Applied',
                        count: benefitsOverview.applied,
                        color: blueLight,
                        textColor: infoColor,
                        icon: Icons.hourglass_empty,
                      ),
                    ),
                    const SizedBox(width: AppConstants.smallPadding),
                    Expanded(
                      child: _StatusBox(
                        label: 'Not Eligible',
                        count: benefitsOverview.notEligible,
                        color: redLight,
                        textColor: errorColor,
                        icon: Icons.cancel,
                      ),
                    ),
                  ],
                ),
                if (benefitsOverview.approved > 0 || benefitsOverview.rejected > 0) ...[
                  const SizedBox(height: AppConstants.smallPadding),
                  Row(
                    children: [
                      if (benefitsOverview.approved > 0) ...[
                        Expanded(
                          child: _StatusBox(
                            label: 'Approved',
                            count: benefitsOverview.approved,
                            color: greenLight,
                            textColor: successColor,
                            icon: Icons.verified,
                          ),
                        ),
                        const SizedBox(width: AppConstants.smallPadding),
                      ],
                      if (benefitsOverview.rejected > 0) ...[
                        Expanded(
                          child: _StatusBox(
                            label: 'Rejected',
                            count: benefitsOverview.rejected,
                            color: redLight,
                            textColor: errorColor,
                            icon: Icons.error,
                          ),
                        ),
                        const SizedBox(width: AppConstants.smallPadding),
                      ],
                      // Fill remaining space if only one status is shown
                      if (benefitsOverview.approved == 0 || benefitsOverview.rejected == 0)
                        const Spacer(),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _StatColumn({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: color,
              size: AppConstants.iconMedium,
            ),
            const SizedBox(width: AppConstants.smallPadding),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: textSecondary,
          ),
        ),
      ],
    );
  }
}

class _StatusBox extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final Color textColor;
  final IconData icon;

  const _StatusBox({
    required this.label,
    required this.count,
    required this.color,
    required this.textColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppConstants.mediumPadding,
        horizontal: AppConstants.smallPadding,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: textColor,
            size: AppConstants.iconMedium,
          ),
          const SizedBox(height: 4),
          Text(
            '$count',
            style: theme.textTheme.titleLarge?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}