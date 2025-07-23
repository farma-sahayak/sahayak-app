import '../models/crop.dart';
import '../models/notification_item.dart';

class HomeRepository {
  // Mock data - in real app, this would fetch from API
  Future<List<Crop>> getCrops() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      Crop(
        id: '1',
        name: 'Tomato',
        emoji: '🍅',
        status: CropStatus.flowering,
        healthPercentage: 85,
        plantedDate: DateTime.now().subtract(const Duration(days: 45)),
        expectedHarvestDate: DateTime.now().add(const Duration(days: 15)),
      ),
      Crop(
        id: '2',
        name: 'Brinjal',
        emoji: '🍆',
        status: CropStatus.ready,
        healthPercentage: 95,
        plantedDate: DateTime.now().subtract(const Duration(days: 60)),
        expectedHarvestDate: DateTime.now().add(const Duration(days: 3)),
      ),
      Crop(
        id: '3',
        name: 'Chili',
        emoji: '🌶️',
        status: CropStatus.growing,
        healthPercentage: 78,
        plantedDate: DateTime.now().subtract(const Duration(days: 30)),
        expectedHarvestDate: DateTime.now().add(const Duration(days: 25)),
      ),
    ];
  }

  Future<List<NotificationItem>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return [
      NotificationItem(
        id: '1',
        title: 'Tomato • 2 hours ago',
        message: 'Tomato plants may need water in 2 days',
        type: NotificationType.crop,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        audioUrl: 'https://example.com/audio/1.mp3',
      ),
      NotificationItem(
        id: '2',
        title: 'Brinjal • 4 hours ago',
        message: 'Brinjal harvest ready in 3 days',
        type: NotificationType.crop,
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        audioUrl: 'https://example.com/audio/2.mp3',
      ),
      NotificationItem(
        id: '3',
        title: 'General • 1 day ago',
        message: 'New government scheme available',
        type: NotificationType.scheme,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        audioUrl: 'https://example.com/audio/3.mp3',
      ),
    ];
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // In real app, this would make API call
  }

  Future<void> playNotificationAudio(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // In real app, this would play audio
  }
}