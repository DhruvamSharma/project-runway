import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';
import 'package:project_runway/features/tasks/presentation/manager/bloc.dart';
import 'package:project_runway/features/tasks/presentation/widgets/task_badge.dart';

class TaskWidget extends StatefulWidget {
  final TaskEntity task;

  TaskWidget({
    @required this.task,
  });

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  bool isCompleted;

  @override
  void didUpdateWidget(TaskWidget oldWidget) {
    isCompleted = widget.task.isCompleted;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    isCompleted = widget.task.isCompleted;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: CommonDimens.MARGIN_20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TaskBadge(taskTag: widget.task.tag),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.task.taskTitle,
                style: CommonTextStyles.taskTextStyle(),
              ),
              Checkbox(
                value: isCompleted,
                onChanged: (completeStatus) {
                  BlocProvider.of<HomeScreenTaskBloc>(context)
                      .dispatch(CompleteTaskEvent(task: widget.task));
                  setState(() {
                    isCompleted = completeStatus;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
