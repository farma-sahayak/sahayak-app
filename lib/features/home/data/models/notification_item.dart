class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? audioUrl;
  final Map<String, dynamic>? metadata;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.audioUrl,
    this.metadata,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      type: NotificationType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () => NotificationType.general,
      ),
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
      audioUrl: json['audioUrl'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'audioUrl': audioUrl,
      'metadata': metadata,
    };
  }

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    String? audioUrl,
    Map<String, dynamic>? metadata,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      audioUrl: audioUrl ?? this.audioUrl,
      metadata: metadata ?? this.metadata,
    );
  }
}

enum NotificationType {
  crop,
  weather,
  market,
  scheme,
  disease,
  general,
}

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.crop:
        return 'Crop Update';
      case NotificationType.weather:
        return 'Weather Alert';
      case NotificationType.market:
        return 'Market Update';
      case NotificationType.scheme:
        return 'Government Scheme';
      case NotificationType.disease:
        return 'Disease Alert';
      case NotificationType.general:
        return 'General';
    }
  }

  String get iconData {
    switch (this) {
      case NotificationType.crop:
        return 'agriculture';
      case NotificationType.weather:
        return 'wb_sunny';
      case NotificationType.market:
        return 'trending_up';
      case NotificationType.scheme:
        return 'policy';
      case NotificationType.disease:
        return 'bug_report';
      case NotificationType.general:
        return 'info';
    }
  }

  String get backgroundColor {
    switch (this) {
      case NotificationType.crop:
        return '#E8F5E9';
      case NotificationType.weather:
        return '#FFF3E0';
      case NotificationType.market:
        return '#E3F2FD';
      case NotificationType.scheme:
        return '#F3E5F5';
      case NotificationType.disease:
        return '#FFEBEE';
      case NotificationType.general:
        return '#F5F5F5';
    }
  }
}