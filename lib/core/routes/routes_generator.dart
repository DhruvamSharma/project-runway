import 'package:flutter/material.dart';
import 'package:project_runway/features/tasks/presentation/pages/create_task/create_task_page.dart';
import 'package:project_runway/features/tasks/presentation/pages/create_task/create_task_screen_arguments.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/home_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return _transitionRoute(Scaffold());
      case HomeScreen.routeName:
        return _transitionRoute(HomeScreen());
      case CreateTaskPage.routeName:
        final CreateTaskScreenArguments args = settings.arguments;
        return _transitionRoute(CreateTaskPage(
          runningDate: args.runningDate,
          initialTaskTitle: args.initialTaskTitle,
          totalTasksCreated: args.totalTasksCreated,
        ));
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Route Error'),
        ),
        body: Center(
          child: Text('This route does not exist'),
        ),
      );
    });
  }

  static PageRoute _transitionRoute(Widget route) {
    return MaterialPageRoute(builder: (_) => route);
  }
}
