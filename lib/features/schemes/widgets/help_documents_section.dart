import 'package:flutter/material.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../theme.dart';

class HelpDocumentsSection extends StatelessWidget {
  final VoidCallback? onDocumentsList;
  final VoidCallback? onForms;
  final VoidCallback? onAudioGuide;
  final VoidCallback? onApplicationGuide;

  const HelpDocumentsSection({
    super.key,
    this.onDocumentsList,
    this.onForms,
    this.onAudioGuide,
    this.onApplicationGuide,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.help_outline,
                color: primaryColor,
                size: AppConstants.iconLarge,
              ),
              const SizedBox(width: AppConstants.smallPadding),
              Expanded(
                child: Text(
                  'Help & Documents',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.largePadding),

          // Quick access cards row
          Row(
            children: [
              Expanded(
                child: _QuickAccessCard(
                  icon: Icons.description_outlined,
                  title: 'Documents',
                  subtitle: 'Checklist & forms',
                  color: infoColor,
                  backgroundColor: blueLight,
                  onTap: onDocumentsList,
                ),
              ),
              const SizedBox(width: AppConstants.mediumPadding),
              Expanded(
                child: _QuickAccessCard(
                  icon: Icons.headphones,
                  title: 'Audio Guide',
                  subtitle: 'Step-by-step help',
                  color: secondaryColor,
                  backgroundColor: orangeLight,
                  onTap: onAudioGuide,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.mediumPadding),

          // Action buttons
          Column(
            children: [
              _ActionButton(
                icon: Icons.list_alt,
                label: 'Document List',
                subtitle: 'View all required documents',
                onTap: onDocumentsList,
              ),
              const SizedBox(height: AppConstants.smallPadding),
              _ActionButton(
                icon: Icons.assignment,
                label: 'Forms',
                subtitle: 'Download application forms',
                onTap: onForms,
              ),
              const SizedBox(height: AppConstants.smallPadding),
              _ActionButton(
                icon: Icons.play_circle_outline,
                label: 'Listen to Application Guide',
                subtitle: 'Audio instructions in your language',
                onTap: onApplicationGuide,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.largePadding),

          // Tips section
          Container(
            padding: const EdgeInsets.all(AppConstants.mediumPadding),
            decoration: BoxDecoration(
              color: greenLight,
              borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
              border: Border.all(color: primaryColor.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: primaryColor,
                      size: AppConstants.iconMedium,
                    ),
                    const SizedBox(width: AppConstants.smallPadding),
                    Text(
                      'Quick Tips',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.smallPadding),
                _TipItem(text: 'Keep Aadhaar, land records handy'),
                _TipItem(text: 'Apply before deadline for best chances'),
                _TipItem(text: 'Check eligibility criteria carefully'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppConstants.mediumPadding),
      color: backgroundColor,
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: AppConstants.iconXLarge,
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.mediumPadding),
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.smallPadding),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.smallRadius),
              ),
              child: Icon(
                icon,
                color: primaryColor,
                size: AppConstants.iconMedium,
              ),
            ),
            const SizedBox(width: AppConstants.mediumPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: textSecondary,
              size: AppConstants.iconMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final String text;

  const _TipItem({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: AppConstants.smallPadding),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: primaryVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}