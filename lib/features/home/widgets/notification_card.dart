import 'package:flutter/material.dart';
import '../models/notification_item.dart';

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback? onTap;
  final VoidCallback? onPlayAudio;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
    this.onPlayAudio,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      color: _getBackgroundColor(),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification type indicator
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  color: _getIndicatorColor(),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              // Notification content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Play audio button
              if (notification.audioUrl != null)
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF388E3C),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.volume_up,
                      size: 16,
                      color: Colors.white,
                    ),
                    onPressed: onPlayAudio,
                    padding: EdgeInsets.zero,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (notification.type) {
      case NotificationType.crop:
        return const Color(0xFFFFF8E1);
      case NotificationType.weather:
        return const Color(0xFFE8F5E9);
      case NotificationType.market:
        return const Color(0xFFE3F2FD);
      case NotificationType.scheme:
        return const Color(0xFFE8EAF6);
      case NotificationType.disease:
        return const Color(0xFFFFEBEE);
      case NotificationType.general:
        return const Color(0xFFF5F5F5);
    }
  }

  Color _getIndicatorColor() {
    switch (notification.type) {
      case NotificationType.crop:
        return const Color(0xFFFFA726);
      case NotificationType.weather:
        return const Color(0xFF4CAF50);
      case NotificationType.market:
        return const Color(0xFF2196F3);
      case NotificationType.scheme:
        return const Color(0xFF3F51B5);
      case NotificationType.disease:
        return const Color(0xFFF44336);
      case NotificationType.general:
        return const Color(0xFF9E9E9E);
    }
  }
}