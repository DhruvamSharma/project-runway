import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/features/tasks/presentation/manager/bloc.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/current_task_page.dart';

class TaskPage extends StatelessWidget {
  final int pageNumber;

  TaskPage({
    @required this.pageNumber,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeScreenTaskBloc>(
      builder: (_) => sl<HomeScreenTaskBloc>(),
      child: BlocBuilder<HomeScreenTaskBloc, TaskBlocState>(
        builder: (_, state) {
          return CurrentTaskPage(
            pageNumber: pageNumber,
          );
        },
      ),
    );
  }
}
