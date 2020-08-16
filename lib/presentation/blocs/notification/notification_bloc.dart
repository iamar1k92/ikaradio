import 'dart:async';
import 'package:base/core/utils/exceptions/network_exceptions.dart';
import 'package:base/data/models/notification_message.dart';
import 'package:base/data/repositories/notification_repository.dart';
import 'package:base/data/responses/notification_response.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/injection_container.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationRepository _notificationRepository = sl<NotificationRepository>();
  List<NotificationMessage> _notifications = List<NotificationMessage>();

  NotificationBloc() : super(InitialNotificationState());


  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    yield LoadingNotificationState();
    if (event is LoadNotifications) {
      yield* _mapLoadNotificationsToState();
    }
  }

  Stream<NotificationState> _mapLoadNotificationsToState() async* {
    if (_notifications.length > 0) {
      yield LoadedNotificationState(notifications: _notifications);
    } else {
      try {
        NotificationResponse _notificationResponse = await _notificationRepository.getNotifications();
        if (_notificationResponse.error == null) {
          _notifications = _notificationResponse.notifications;
          yield LoadedNotificationState(notifications: _notificationResponse.notifications);
        } else {
          yield ErrorNotificationState(error: _notificationResponse.error);
        }
      } on NetworkException catch (e) {
        yield ErrorNotificationState(error: e.message.toString());
      } catch (e) {

        yield ErrorNotificationState(error: S.current.an_unexpected_problem_has_occurred);
      }
    }
  }
}
