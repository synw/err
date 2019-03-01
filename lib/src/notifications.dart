import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

var flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
var platform = MethodChannel('crossingthestreams.io/resourceResolver');

class ErrNotification {
  ErrNotification() {
    _init();
  }

  void _init() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future showNotification(
      {@required int id,
      @required String title,
      @required String body,
      String payload}) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'err channel',
      'Err channel',
      'Channel for Flutter Err plugin',
      importance: Importance.Max,
      priority: Priority.High,
      style: AndroidNotificationStyle.BigText,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future onDidRecieveLocalNotification(
      int id, String title, String body, String payload) async {}

  Future onSelectNotification(String payload) async {}
}
