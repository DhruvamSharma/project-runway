import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/core/notifications/local_notifications.dart';
import 'package:project_runway/core/notifications/one_signal.dart';
import 'package:project_runway/core/remote_config/remote_config_service.dart';
import 'package:project_runway/core/routes/routes_generator.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:project_runway/features/login/presentation/pages/user_entry_route.dart';
import 'package:provider/provider.dart';
import 'package:wiredash/wiredash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialising one signal
  await oneSignalInit();
  // initialising local notifications
  await initLocalNotifications();
  // initialising get_it
  await serviceLocatorInit();
  // initialise remote config values
  final RemoteConfigService remoteConfigService = sl<RemoteConfigService>();
  await remoteConfigService.initialiseRemoteConfig();
  // To turn off landscape mode
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(
    ChangeNotifierProvider<ThemeModel>(
      create: (_) => ThemeModel(),
      child: MyApp(),
    ),
  );
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey();

class MyApp extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ThemeModel>(context);
    return Wiredash(
      theme: WiredashThemeData(
        brightness: appState.currentTheme.brightness,
        primaryColor: appState.currentTheme.primaryColor,
        secondaryColor: appState.currentTheme.secondaryHeaderColor,
        primaryTextColor: appState.currentTheme.scaffoldBackgroundColor,
        secondaryBackgroundColor: appState.currentTheme.scaffoldBackgroundColor,
        tertiaryTextColor: appState.currentTheme.accentColor,
        primaryBackgroundColor: appState.currentTheme.accentColor,
        secondaryTextColor: appState.currentTheme.scaffoldBackgroundColor,
        backgroundColor: appState.currentTheme.scaffoldBackgroundColor,
        dividerColor: appState.currentTheme.dividerColor,
      ),
      projectId: "runway-y27lisj",
      secret: "xpbaeleqsl73ib10pz5ixnyz1en73d2q",
      navigatorKey: navigatorKey,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: APP_NAME,
        debugShowCheckedModeBanner: false,
        theme: appState.currentTheme,
        initialRoute: UserEntryRoute.routeName,
        onGenerateRoute: RouteGenerator.generateRoute,
        navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
      ),
    );
  }
}
