class QuickAction {
  final String id;
  final String title;
  final String iconData;
  final String backgroundColor;
  final String foregroundColor;
  final String route;
  final Map<String, dynamic>? metadata;

  const QuickAction({
    required this.id,
    required this.title,
    required this.iconData,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.route,
    this.metadata,
  });

  factory QuickAction.fromJson(Map<String, dynamic> json) {
    return QuickAction(
      id: json['id'],
      title: json['title'],
      iconData: json['iconData'],
      backgroundColor: json['backgroundColor'],
      foregroundColor: json['foregroundColor'],
      route: json['route'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'iconData': iconData,
      'backgroundColor': backgroundColor,
      'foregroundColor': foregroundColor,
      'route': route,
      'metadata': metadata,
    };
  }
}

// Predefined quick actions
class QuickActions {
  static const List<QuickAction> defaultActions = [
    QuickAction(
      id: 'disease_check',
      title: 'Disease Check',
      iconData: 'camera_alt',
      backgroundColor: '#388E3C',
      foregroundColor: '#FFFFFF',
      route: '/disease_detection',
    ),
    QuickAction(
      id: 'market_prices',
      title: 'Market Prices',
      iconData: 'currency_rupee',
      backgroundColor: '#FFA726',
      foregroundColor: '#FFFFFF',
      route: '/market',
    ),
    QuickAction(
      id: 'schemes',
      title: 'Schemes',
      iconData: 'policy',
      backgroundColor: '#FF9800',
      foregroundColor: '#FFFFFF',
      route: '/schemes',
    ),
    QuickAction(
      id: 'add_crop',
      title: 'Add Crop',
      iconData: 'add_circle',
      backgroundColor: '#9C27B0',
      foregroundColor: '#FFFFFF',
      route: '/add_crop',
    ),
  ];
}