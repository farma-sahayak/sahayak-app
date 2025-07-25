import 'package:equatable/equatable.dart';
import '../../data/models/crop.dart';
import '../../data/models/notification_item.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<Crop> crops;
  final List<NotificationItem> notifications;
  final DateTime lastUpdated;

  const HomeLoaded({
    required this.crops,
    required this.notifications,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [crops, notifications, lastUpdated];

  HomeLoaded copyWith({
    List<Crop>? crops,
    List<NotificationItem>? notifications,
    DateTime? lastUpdated,
  }) {
    return HomeLoaded(
      crops: crops ?? this.crops,
      notifications: notifications ?? this.notifications,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
