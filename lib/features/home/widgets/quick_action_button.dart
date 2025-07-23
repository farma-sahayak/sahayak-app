import 'package:flutter/material.dart';
import '../models/quick_action.dart';

class QuickActionButton extends StatelessWidget {
  final QuickAction action;
  final VoidCallback? onTap;

  const QuickActionButton({
    super.key,
    required this.action,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: _hexToColor(action.backgroundColor),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getIconData(action.iconData),
                  color: _hexToColor(action.foregroundColor),
                  size: 22,
                ),
                const SizedBox(height: 6),
                Flexible(
                  child: Text(
                    action.title,
                    style: TextStyle(
                      color: _hexToColor(action.foregroundColor),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconString) {
    switch (iconString) {
      case 'camera_alt':
        return Icons.camera_alt;
      case 'currency_rupee':
        return Icons.currency_rupee;
      case 'policy':
        return Icons.policy;
      case 'add_circle':
        return Icons.add_circle;
      case 'agriculture':
        return Icons.agriculture;
      case 'trending_up':
        return Icons.trending_up;
      case 'wb_sunny':
        return Icons.wb_sunny;
      case 'notifications':
        return Icons.notifications;
      default:
        return Icons.help_outline;
    }
  }

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}