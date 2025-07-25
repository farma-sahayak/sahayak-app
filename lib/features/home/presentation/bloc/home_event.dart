import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeData extends HomeEvent {
  const LoadHomeData();
}

class RefreshHomeData extends HomeEvent {
  const RefreshHomeData();
}

class LoadCrops extends HomeEvent {
  const LoadCrops();
}

class LoadNotifications extends HomeEvent {
  const LoadNotifications();
}

class MarkNotificationAsRead extends HomeEvent {
  final String notificationId;

  const MarkNotificationAsRead(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class PlayNotificationAudio extends HomeEvent {
  final String notificationId;

  const PlayNotificationAudio(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}