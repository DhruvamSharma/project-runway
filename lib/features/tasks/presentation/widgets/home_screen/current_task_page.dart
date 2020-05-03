import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/date_time_parser.dart';
import 'package:project_runway/core/keys.dart';
import 'package:project_runway/features/tasks/data/models/task_model.dart';
import 'package:project_runway/features/tasks/domain/entities/task_list_entity.dart';
import 'package:project_runway/features/tasks/presentation/manager/bloc.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/task_widget.dart';

class CurrentTaskPage extends StatefulWidget {
  final int pageNumber;

  CurrentTaskPage({
    @required this.pageNumber,
  });

  @override
  _CurrentTaskPageState createState() => _CurrentTaskPageState();
}

class _CurrentTaskPageState extends State<CurrentTaskPage> {
  TaskListEntity taskList;
  DateTime runningDate;
  @override
  void initState() {
    final currentDate = DateTime.now();
    runningDate = buildDate(currentDate);
    taskList = TaskListEntity(
      isSynced: false,
      taskList: [],
      runningDate: runningDate,
    );
    BlocProvider.of<HomeScreenTaskBloc>(context)
        .dispatch(ReadAllTaskEvent(runningDate: runningDate));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeScreenTaskBloc, TaskBlocState>(
      listener: (_, state) {
        print(state);
        if (state is LoadedHomeScreenAllTasksState) {
          taskList = state.taskListEntity;
        }
        if (state is LoadedHomeScreenCompleteTaskState) {
          final task = state.taskEntity;
          print("in all task state");
          print(taskList.taskList.indexOf(task));
        }
        if (state is ErrorHomeScreenCompleteTaskState) {
          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(state.message ??
                "Sorry, could not update the task. Please check your internet connection"),
          ));
        }
      },
      child: Column(
        children: <Widget>[
          Text(
            beautifyDate(runningDate),
            style: CommonTextStyles.dateTextStyle(),
          ),
          Expanded(
              child: ListView.builder(
            padding: const EdgeInsets.only(
              top: CommonDimens.MARGIN_80,
            ),
            itemCount: taskList.taskList.length,
            itemBuilder: (_, i) {
              return TaskWidget(task: taskList.taskList[i]);
            },
          )),
        ],
      ),
    );
  }

  DateTime buildDate(DateTime currentDate) {
    DateTime runningDate;
    if (widget.pageNumber == 0) {
      final dateTime = currentDate.subtract(Duration(days: 1));
      runningDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    } else if (widget.pageNumber == 1) {
      runningDate =
          DateTime(currentDate.year, currentDate.month, currentDate.day);
    } else if (widget.pageNumber == 2) {
      final dateTime = currentDate.add(Duration(days: 1));
      runningDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    }
    return runningDate;
  }
}
