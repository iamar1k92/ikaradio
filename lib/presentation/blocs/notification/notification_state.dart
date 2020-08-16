import 'package:base/data/models/notification_message.dart';
import 'package:meta/meta.dart';

abstract class NotificationState {
  const NotificationState();
}

class InitialNotificationState extends NotificationState {}

class LoadingNotificationState extends NotificationState {}

class LoadedNotificationState extends NotificationState {
  final List<NotificationMessage> notifications;

  LoadedNotificationState({@required this.notifications});
}

class ErrorNotificationState extends NotificationState {
  final String error;

  ErrorNotificationState({@required this.error});
}
