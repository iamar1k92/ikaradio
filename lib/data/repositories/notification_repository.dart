import 'package:base/data/providers/notification_api_provider.dart';
import 'package:base/data/responses/notification_response.dart';
import 'package:base/domain/interfaces/base_notification_repository.dart';
import 'package:base/injection_container.dart';

class NotificationRepository implements BaseNotificationRepository {
  final NotificationApiProvider _notificationApiProvider = sl<NotificationApiProvider>();

  @override
  Future<NotificationResponse> getNotifications() async {
    return await _notificationApiProvider.getNotifications();
  }
}
