import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final Color? titleColor;
  final bool showBackButton;

  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    this.actions,
    this.titleColor,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (showBackButton)
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF388E3C),
                  size: AppConstants.iconLarge,
                ),
              ),
            if (leadingIcon != null) ...[
              Icon(
                leadingIcon,
                color: titleColor ?? const Color(0xFF388E3C),
                size: AppConstants.iconLarge,
              ),
              const SizedBox(width: AppConstants.smallPadding),
            ],
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: AppConstants.headlineLarge,
                  fontWeight: FontWeight.bold,
                  color: titleColor ?? const Color(0xFF388E3C),
                ),
              ),
            ),
            if (actions != null) ...actions!,
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: AppConstants.bodyMedium,
            ),
          ),
        ],
      ],
    );
  }
}
