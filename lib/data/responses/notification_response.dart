import 'package:base/data/models/notification_message.dart';

class NotificationResponse {
  final List<NotificationMessage> notifications;
  final String error;

  NotificationResponse({this.notifications, this.error});

  NotificationResponse.success(json)
      : notifications = List<NotificationMessage>.from((json as List).map((x) => NotificationMessage.fromJson(x))),
        error = null;

  NotificationResponse.error(String error)
      : notifications = null,
        error = error;

  @override
  String toString() {
    return 'CategoryResponse{notifications: $notifications, error: $error}';
  }
}
