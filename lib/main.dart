import 'package:flutter/material.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/core/routes/routes_generator.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await serviceLocatorInit();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(
          primarySwatch: CommonColors.primarySwatch,
          scaffoldBackgroundColor: CommonColors.scaffoldColor,
          accentColor: CommonColors.accentColor,
          toggleableActiveColor: CommonColors.toggleableActiveColor,
          brightness: Brightness.dark),
      initialRoute: HomeScreen.routeName,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
