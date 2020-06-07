import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/core/keys.dart';
import 'package:project_runway/features/login/presentation/manager/bloc.dart';
import 'package:project_runway/features/login/presentation/pages/profile_route.dart';
import 'package:project_runway/features/login/presentation/pages/secret_puzzle_route.dart';
import 'package:project_runway/features/login/presentation/pages/user_entry_route.dart';
import 'package:project_runway/features/login/presentation/widgets/app_into.dart';
import 'package:project_runway/features/stats/presentation/manager/bloc.dart';
import 'package:project_runway/features/stats/presentation/pages/stats_screen.dart';
import 'package:project_runway/features/tasks/presentation/pages/create_task/create_task_page.dart';
import 'package:project_runway/features/tasks/presentation/pages/create_task/create_task_screen_arguments.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/home_screen.dart';
import 'package:project_runway/features/vision_boards/presentation/manager/bloc.dart';
import 'package:project_runway/features/vision_boards/presentation/pages/create_vision_board/create_vision_board.dart';
import 'package:project_runway/features/vision_boards/presentation/pages/create_vision_board/create_vision_board_args.dart';
import 'package:project_runway/features/vision_boards/presentation/pages/edit_vision_detaiils/edit_vision_details.dart';
import 'package:project_runway/features/vision_boards/presentation/pages/edit_vision_detaiils/edit_vision_details_args.dart';
import 'package:project_runway/features/vision_boards/presentation/pages/image_selector.dart';
import 'package:project_runway/features/vision_boards/presentation/pages/vision_board_list_route.dart';

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
      case SecretPuzzleRoute.routeName:
        return _transitionRoute(BlocProvider<LoginBloc>(
          create: (_) => sl<LoginBloc>(),
          child: BlocProvider<StatsBloc>(
              create: (_) => sl<StatsBloc>(), child: SecretPuzzleRoute()),
        ));
      case AppIntroWidget.routeName:
        return _transitionRoute(Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: AppIntroWidget(),
        ));
      case CreateTaskPage.routeName:
        final CreateTaskScreenArguments args = settings.arguments;
        return _transitionRoute(CreateTaskPage(
          runningDate: args.runningDate,
          initialTaskTitle: args.initialTaskTitle,
          totalTasksCreated: args.totalTasksCreated,
        ));
      case StatsScreen.routeName:
        return _transitionRoute(StatsScreen());

      case ImageSelectorRoute.routeName:
        return _transitionRoute(ImageSelectorRoute());
      case VisionBoardListRoute.routeName:
        return _transitionRoute(
          BlocProvider<VisionBoardBloc>(
            create: (_) => sl<VisionBoardBloc>(),
            child: VisionBoardListRoute(),
          ),
        );
      case CreateVisionBoardRoute.routeName:
        final CreateVisionBoardArgs args = settings.arguments;
        return _transitionRoute(BlocProvider<VisionBoardBloc>(
          create: (_) => sl<VisionBoardBloc>(),
          child: CreateVisionBoardRoute(
            visionBoardId: args.visionBoardId,
          ),
        ));
      case EditVisionRoute.routeName:
        final EditVisionArgs args = settings.arguments;
        return _transitionRoute(
          BlocProvider<VisionBoardBloc>(
            create: (_) => sl<VisionBoardBloc>(),
            child: EditVisionRoute(
              visionBoardId: args.visionBoardId,
              visionImageUrl:
                  "https://images.unsplash.com/photo-1470047721614-35220c146849?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80",
            ),
          ),
        );
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
        transitionDuration: Duration(milliseconds: 300),
        pageBuilder: (context, primaryAnimation, secondaryAnimation) {
          return Material(
            elevation: 16,
            child: route,
          );
        },
        transitionsBuilder: (context, firstAnimation, secondAnimation, child) {
          return FadeTransition(
            opacity: firstAnimation,
            child: child,
          );
        });
  }
}
