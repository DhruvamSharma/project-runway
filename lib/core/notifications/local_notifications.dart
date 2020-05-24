import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/keys.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
Future<void> initLocalNotifications() async {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  var initializationSettingsAndroid =
      AndroidInitializationSettings('ic_stat_onesignal_default');
  var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);
}

Future selectNotification(String payload) {
  print("payload receivde $payload");
  return null;
}

Future onDidReceiveLocalNotification(
    int id, String title, String body, String payload) {
  return null;
}

Future<void> scheduleNotification(
    String taskId, String taskTitle, DateTime scheduledNotificationTime) async {
  await initLocalNotifications();
  if (taskId != null && taskTitle != null && scheduledNotificationTime != null) {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        TASK_CHANNEL_ID, TASK_CHANNEL_NAME, 'your other channel description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        taskTitle,
        "Let's strike this off from our list of work",
        scheduledNotificationTime,
        platformChannelSpecifics,
        androidAllowWhileIdle: true);
  }
}
