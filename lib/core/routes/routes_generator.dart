import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/core/keys.dart';
import 'package:project_runway/features/login/presentation/pages/profile_route.dart';
import 'package:project_runway/features/login/presentation/pages/user_entry_route.dart';
import 'package:project_runway/features/stats/presentation/pages/stats_screen.dart';
import 'package:project_runway/features/tasks/presentation/pages/create_task/create_task_page.dart';
import 'package:project_runway/features/tasks/presentation/pages/create_task/create_task_screen_arguments.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/home_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case UserEntryRoute.routeName:
        String user = sharedPreferences.getString(USER_KEY);
        if (user == null) {
          return _transitionRoute(UserEntryRoute());
        } else {
          return _transitionRoute(HomeScreen());
        }
        break;
      case HomeScreen.routeName:
        return _transitionRoute(HomeScreen());
      case ProfileRoute.routeName:
        return _transitionRoute(ProfileRoute());
      case CreateTaskPage.routeName:
        final CreateTaskScreenArguments args = settings.arguments;
        return _transitionRoute(CreateTaskPage(
          runningDate: args.runningDate,
          initialTaskTitle: args.initialTaskTitle,
          totalTasksCreated: args.totalTasksCreated,
        ));
      case StatsScreen.routeName:
        return _transitionRoute(StatsScreen());
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
    return PageRouteBuilder(
        pageBuilder: (context, primaryAnimation, secondaryAnimation) {
      return Material(
        elevation: 16,
        child: route,
      );
    }, transitionsBuilder: (context, firstAnimation, secondAnimation, child) {
      return SlideTransition(
        position: firstAnimation.drive(
          Tween(begin: Offset(0, 1), end: Offset(0, 0))
              .chain(CurveTween(curve: Curves.easeOutCubic)),
        ),
        child: child,
      );
    });
  }
}
