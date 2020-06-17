import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/features/tasks/presentation/pages/create_task/create_task_page.dart';
import 'package:provider/provider.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
Future<void> initLocalNotifications() async {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  var initializationSettingsAndroid = AndroidInitializationSettings(
    'app_icon',
  );
  var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);
}

Future selectNotification(String payload) {
  return null;
}

Future onDidReceiveLocalNotification(
    int id, String title, String body, String payload) {
  return null;
}

Future<void> scheduleNotification(
    String taskId, String taskTitle, DateTime scheduledNotificationTime) async {
  await initLocalNotifications();
  if (taskId != null &&
      taskTitle != null &&
      scheduledNotificationTime != null) {
    // vibration
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        TASK_CHANNEL_ID, TASK_CHANNEL_NAME, 'your other channel description',
        largeIcon: DrawableResourceAndroidBitmap("app_icon"),
        vibrationPattern: vibrationPattern,
        importance: Importance.High,
        color: CommonColors.scaffoldColor,
        priority: Priority.High);
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

Future<void> sendNotificationForFCM(
    String taskId, String taskTitle, DateTime scheduledNotificationTime) async {
  await initLocalNotifications();
  if (taskId != null &&
      taskTitle != null &&
      scheduledNotificationTime != null) {
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

void selectTimeForNotification(BuildContext newContext, runningDate,
    Function onDateError, Function onSuccess) async {
  TimeOfDay timeOfDay = await showTimePicker(
      context: newContext,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            accentColor: Colors.amber,
          ),
          child: child,
        );
      });
  if (timeOfDay != null) {
    if (runningDate.day - DateTime.now().day > 0) {
      updateDateForNotification(newContext, timeOfDay, runningDate);
    } else {
      int nowTime = TimeOfDay.now().minute + TimeOfDay.now().hour * 60;
      int selectedTime = timeOfDay.minute + timeOfDay.hour * 60;
      if (selectedTime - nowTime <= 0) {
        onDateError();
      } else {
        onSuccess();
        updateDateForNotification(newContext, timeOfDay, runningDate);
      }
    }
  }
}

updateDateForNotification(
    BuildContext context, TimeOfDay timeOfDay, DateTime runningDate) {
  // create properly formatted time
  try {
    DateTime scheduledTime = DateTime(
      runningDate.year,
      runningDate.month,
      runningDate.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    // update the notification
    Provider.of<TaskDetailProviderModel>(context, listen: false)
        .assignNotificationTime(scheduledTime);
  } catch (ex) {
    print("ex: -- $ex");
  }
}
