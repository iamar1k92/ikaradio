import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {}
  return Future<void>.value();
}

class NotificationService {
  FirebaseMessaging _fcm = FirebaseMessaging();
  BuildContext myContext;

  static final NotificationService _singleton = NotificationService._internal();

  factory NotificationService() {
    return _singleton;
  }

  NotificationService._internal();

  initializeFCMNotification(BuildContext context) async {
    myContext = context;
    _fcm.subscribeToTopic("all");
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {},
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {},
      onResume: (Map<String, dynamic> message) async {},
    );
  }
}
