import 'package:flutter/material.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/routes/routes_generator.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(
        primarySwatch: CommonColors.primarySwatch,
        scaffoldBackgroundColor: CommonColors.scaffoldColor,
      ),
      initialRoute: HomeScreen.routeName,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
