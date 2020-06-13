import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:project_runway/core/keys/keys.dart';
import 'package:project_runway/features/login/presentation/pages/profile_route.dart';
import 'package:project_runway/features/stats/presentation/pages/stats_screen.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/home_screen.dart';
import 'package:project_runway/features/vision_boards/presentation/pages/vision_board_list_route.dart';
import 'package:project_runway/main.dart';

Future<Null> oneSignalInit() async {
//Remove this method to stop OneSignal Debugging
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.init("e52cb98e-626c-480d-94d2-a4d4f6dc2183", iOSSettings: {
    OSiOSSettings.autoPrompt: false,
    OSiOSSettings.inAppLaunchUrl: false
  });
  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  await OneSignal.shared
      .promptUserForPushNotificationPermission(fallbackToSettings: true);

  OneSignal.shared.setNotificationReceivedHandler(_handleNotificationReceived);

  OneSignal.shared
      .setNotificationReceivedHandler((OSNotification notification) {
// will be called whenever a notification is received
  });

  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
// will be called whenever a notification is opened/button pressed.
    if (result.notification.payload.additionalData
        .containsKey(NOTIFICATION_OPEN_ID)) {
      String value =
          result.notification.payload.additionalData[NOTIFICATION_OPEN_ID];
      handleOpenRouteFunction(value);
    }
  });

  OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
// will be called whenever the permission changes
// (ie. user taps Allow on the permission prompt in iOS)
  });

  OneSignal.shared
      .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
// will be called whenever the subscription changes
//(ie. user gets registered with OneSignal and gets a user ID)
  });

  OneSignal.shared.setEmailSubscriptionObserver(
      (OSEmailSubscriptionStateChanges emailChanges) {
// will be called whenever then user's email subscription changes
// (ie. OneSignal.setEmail(email) is called and the user gets registered
  });

  return null;
}

// For each of the above functions, you can also pass in a
// reference to a function as well:

void _handleNotificationReceived(OSNotification notification) {
  print(notification.payload.additionalData);
}

void handleOpenRouteFunction(String openId) {
  switch (openId) {
    case STATS_ROUTE_KEY:
      navigatorKey.currentState.pushNamed(StatsScreen.routeName);
      break;
    case PROFILE_ROUTE_KEY:
      navigatorKey.currentState.pushNamed(ProfileRoute.routeName);
      break;
    case HOME_ROUTE_KEY:
      navigatorKey.currentState.pushNamed(HomeScreen.routeName);
      break;
    case VISION_BOARD_ROUTE_KEY:
      navigatorKey.currentState.pushNamed(VisionBoardListRoute.routeName);
      break;
    default:
      navigatorKey.currentState.pushNamed(HomeScreen.routeName);
      break;
  }
}
