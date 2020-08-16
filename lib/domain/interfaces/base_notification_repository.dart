import 'package:base/data/responses/notification_response.dart';

abstract class BaseNotificationRepository {
  Future<NotificationResponse> getNotifications();
}
