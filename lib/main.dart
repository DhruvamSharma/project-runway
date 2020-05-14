import 'package:flutter/material.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/core/notifications/one_signal.dart';
import 'package:project_runway/core/routes/routes_generator.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:project_runway/features/login/presentation/pages/user_entry_route.dart';
import 'package:project_runway/features/stats/presentation/pages/stats_screen.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await oneSignalInit();
  await serviceLocatorInit();
  runApp(
    ChangeNotifierProvider<ThemeModel>(
      create: (_) => ThemeModel(),
      child: MyApp(),
    ),
  );
}
GlobalKey<NavigatorState> navigatorKey = GlobalKey();
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: APP_NAME,
      theme: Provider.of<ThemeModel>(context).currentTheme,
      initialRoute: UserEntryRoute.routeName,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
