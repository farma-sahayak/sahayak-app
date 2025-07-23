import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../repository/home_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc({required this.repository}) : super(const HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);
    on<LoadCrops>(_onLoadCrops);
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
    on<PlayNotificationAudio>(_onPlayNotificationAudio);
  }

  Future<void> _onLoadHomeData(LoadHomeData event, Emitter<HomeState> emit) async {
    emit(const HomeLoading());
    
    try {
      final crops = await repository.getCrops();
      final notifications = await repository.getNotifications();
      
      emit(HomeLoaded(
        crops: crops,
        notifications: notifications,
        lastUpdated: DateTime.now(),
      ));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> _onRefreshHomeData(RefreshHomeData event, Emitter<HomeState> emit) async {
    try {
      final crops = await repository.getCrops();
      final notifications = await repository.getNotifications();
      
      emit(HomeLoaded(
        crops: crops,
        notifications: notifications,
        lastUpdated: DateTime.now(),
      ));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> _onLoadCrops(LoadCrops event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      try {
        final crops = await repository.getCrops();
        final currentState = state as HomeLoaded;
        
        emit(currentState.copyWith(crops: crops));
      } catch (e) {
        emit(HomeError(message: e.toString()));
      }
    }
  }

  Future<void> _onLoadNotifications(LoadNotifications event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      try {
        final notifications = await repository.getNotifications();
        final currentState = state as HomeLoaded;
        
        emit(currentState.copyWith(notifications: notifications));
      } catch (e) {
        emit(HomeError(message: e.toString()));
      }
    }
  }

  Future<void> _onMarkNotificationAsRead(MarkNotificationAsRead event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      try {
        await repository.markNotificationAsRead(event.notificationId);
        
        final currentState = state as HomeLoaded;
        final updatedNotifications = currentState.notifications.map((notification) {
          if (notification.id == event.notificationId) {
            return notification.copyWith(isRead: true);
          }
          return notification;
        }).toList();
        
        emit(currentState.copyWith(notifications: updatedNotifications));
      } catch (e) {
        emit(HomeError(message: e.toString()));
      }
    }
  }

  Future<void> _onPlayNotificationAudio(PlayNotificationAudio event, Emitter<HomeState> emit) async {
    try {
      await repository.playNotificationAudio(event.notificationId);
    } catch (e) {
      // Handle audio playback error silently or show a snackbar
      print('Error playing audio: $e');
    }
  }
}