import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../core/theme/sahayak_theme.dart';
import '../../data/models/scheme.dart';

class SchemeCard extends StatelessWidget {
  final Scheme scheme;
  final VoidCallback? onApply;
  final VoidCallback? onTrack;
  final VoidCallback? onInfo;
  final VoidCallback? onPlayAudio;
  final VoidCallback? onDownloadBrochure;

  const SchemeCard({
    super.key,
    required this.scheme,
    this.onApply,
    this.onTrack,
    this.onInfo,
    this.onPlayAudio,
    this.onDownloadBrochure,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberFormat = NumberFormat('#,##,###');

    return AppCard(
      margin: const EdgeInsets.only(bottom: AppConstants.mediumPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scheme.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      scheme.provider,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppConstants.smallPadding),
              _StatusChip(status: scheme.status),
            ],
          ),
          const SizedBox(height: AppConstants.mediumPadding),

          // Benefit amount
          if (scheme.benefitAmount > 0) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.mediumPadding,
                vertical: AppConstants.smallPadding,
              ),
              decoration: BoxDecoration(
                color: orangeLight,
                borderRadius: BorderRadius.circular(AppConstants.smallRadius),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    color: secondaryColor,
                    size: AppConstants.iconSmall,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Benefit: ${scheme.benefitCurrency}${numberFormat.format(scheme.benefitAmount)}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: secondaryVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.mediumPadding),
          ],

          // Description
          Text(
            scheme.description,
            style: theme.textTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppConstants.mediumPadding),

          // Progress bar for applied schemes
          if (scheme.status == SchemeStatus.applied &&
              scheme.progressPercentage != null) ...[
            _ProgressIndicator(
              progress: scheme.progressPercentage! / 100,
              applicationId: scheme.applicationId,
            ),
            const SizedBox(height: AppConstants.mediumPadding),
          ],

          // Deadline
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: AppConstants.iconSmall,
                color: textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                'Deadline: ${DateFormat('dd MMM yyyy').format(scheme.deadline)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: textSecondary,
                ),
              ),
              const Spacer(),
              if (_isDeadlineNear(scheme.deadline))
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.smallPadding,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: warningColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      AppConstants.smallRadius,
                    ),
                  ),
                  child: Text(
                    'Urgent',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: warningColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppConstants.mediumPadding),

          // Tags
          if (scheme.tags.isNotEmpty) ...[
            Wrap(
              spacing: AppConstants.smallPadding,
              runSpacing: 4,
              children: scheme.tags
                  .take(3)
                  .map((tag) => _TagChip(tag: tag))
                  .toList(),
            ),
            const SizedBox(height: AppConstants.mediumPadding),
          ],

          // Action buttons
          Row(
            children: [
              // Primary action button
              Expanded(child: _getPrimaryActionButton(context)),
              const SizedBox(width: AppConstants.smallPadding),

              // Info button
              OutlinedButton.icon(
                onPressed: onInfo,
                icon: Icon(Icons.info_outline, size: AppConstants.iconSmall),
                label: const Text('Info'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.mediumPadding,
                    vertical: AppConstants.smallPadding,
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.smallPadding),

              // Audio button
              IconButton(
                onPressed: scheme.audioGuideUrl != null ? onPlayAudio : null,
                icon: Icon(
                  Icons.volume_up,
                  color: scheme.audioGuideUrl != null ? primaryColor : textHint,
                ),
                tooltip: 'Audio Guide',
              ),

              // Download brochure button
              IconButton(
                onPressed: scheme.brochureUrl != null
                    ? onDownloadBrochure
                    : null,
                icon: Icon(
                  Icons.download,
                  color: scheme.brochureUrl != null ? primaryColor : textHint,
                ),
                tooltip: 'Download Brochure',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getPrimaryActionButton(BuildContext context) {
    switch (scheme.status) {
      case SchemeStatus.eligible:
        return ElevatedButton.icon(
          onPressed: onApply,
          icon: Icon(Icons.send, size: AppConstants.iconSmall),
          label: const Text('Apply Now'),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
          ),
        );
      case SchemeStatus.applied:
        return ElevatedButton.icon(
          onPressed: onTrack,
          icon: Icon(Icons.track_changes, size: AppConstants.iconSmall),
          label: const Text('Track'),
          style: ElevatedButton.styleFrom(
            backgroundColor: infoColor,
            foregroundColor: Colors.white,
          ),
        );
      case SchemeStatus.approved:
        return ElevatedButton.icon(
          onPressed: null,
          icon: Icon(Icons.verified, size: AppConstants.iconSmall),
          label: const Text('Approved'),
          style: ElevatedButton.styleFrom(
            backgroundColor: successColor,
            foregroundColor: Colors.white,
          ),
        );
      case SchemeStatus.rejected:
        return ElevatedButton.icon(
          onPressed: null,
          icon: Icon(Icons.cancel, size: AppConstants.iconSmall),
          label: const Text('Rejected'),
          style: ElevatedButton.styleFrom(
            backgroundColor: errorColor,
            foregroundColor: Colors.white,
          ),
        );
      case SchemeStatus.notEligible:
        return ElevatedButton.icon(
          onPressed: null,
          icon: Icon(Icons.block, size: AppConstants.iconSmall),
          label: const Text('Not Eligible'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
          ),
        );
    }
  }

  bool _isDeadlineNear(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now).inDays;
    return difference <= 7 && difference >= 0;
  }
}

class _StatusChip extends StatelessWidget {
  final SchemeStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusInfo = _getStatusInfo(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.smallPadding,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: statusInfo.backgroundColor,
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusInfo.icon,
            size: AppConstants.iconSmall,
            color: statusInfo.textColor,
          ),
          const SizedBox(width: 4),
          Text(
            statusInfo.label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: statusInfo.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  _StatusInfo _getStatusInfo(SchemeStatus status) {
    switch (status) {
      case SchemeStatus.eligible:
        return _StatusInfo(
          label: 'Eligible',
          icon: Icons.check_circle,
          backgroundColor: greenLight,
          textColor: primaryColor,
        );
      case SchemeStatus.applied:
        return _StatusInfo(
          label: 'Applied',
          icon: Icons.hourglass_empty,
          backgroundColor: blueLight,
          textColor: infoColor,
        );
      case SchemeStatus.approved:
        return _StatusInfo(
          label: 'Approved',
          icon: Icons.verified,
          backgroundColor: greenLight,
          textColor: successColor,
        );
      case SchemeStatus.rejected:
        return _StatusInfo(
          label: 'Rejected',
          icon: Icons.cancel,
          backgroundColor: redLight,
          textColor: errorColor,
        );
      case SchemeStatus.notEligible:
        return _StatusInfo(
          label: 'Not Eligible',
          icon: Icons.block,
          backgroundColor: Colors.grey[100]!,
          textColor: Colors.grey[600]!,
        );
    }
  }
}

class _StatusInfo {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;

  _StatusInfo({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
  });
}

class _TagChip extends StatelessWidget {
  final String tag;

  const _TagChip({required this.tag});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.smallPadding,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(AppConstants.smallRadius),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Text(
        tag,
        style: theme.textTheme.labelSmall?.copyWith(
          color: textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  final double progress;
  final String? applicationId;

  const _ProgressIndicator({required this.progress, this.applicationId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Application Progress',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: theme.textTheme.labelMedium?.copyWith(
                color: infoColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: blueLight,
          valueColor: AlwaysStoppedAnimation<Color>(infoColor),
        ),
        if (applicationId != null) ...[
          const SizedBox(height: 4),
          Text(
            'ID: $applicationId',
            style: theme.textTheme.labelSmall?.copyWith(color: textSecondary),
          ),
        ],
      ],
    );
  }
}
