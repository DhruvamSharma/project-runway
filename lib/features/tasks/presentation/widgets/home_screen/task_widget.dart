import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';
import 'package:project_runway/features/tasks/presentation/manager/bloc.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/current_task_page.dart';
import 'package:project_runway/features/tasks/presentation/widgets/task_badge.dart';
import 'package:provider/provider.dart';

class TaskWidget extends StatefulWidget {
  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  bool isCompleted;

  @override
  void didChangeDependencies() {
    isCompleted =
        Provider.of<TaskHolderProviderModel>(context).taskEntity.isCompleted;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TaskBadge(
          isCompleted: isCompleted,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                Provider.of<TaskHolderProviderModel>(context)
                    .taskEntity
                    .taskTitle,
                style: selectTaskStyle(),
              ),
            ),
            Checkbox(
              value: isCompleted,
              materialTapTargetSize: MaterialTapTargetSize.padded,
              activeColor: selectCheckStyleColor(),
              onChanged: selectCheckBoxState(),
            ),
          ],
        ),
      ],
    );
  }

  Function selectCheckBoxState() {
    // calculating if the task is for a previous day
    if (Provider.of<TaskHolderProviderModel>(context)
            .taskEntity
            .runningDate
            .day <
        DateTime.now().day) {
      return null;
    } else {
      return (completeStatus) {
        isCompleted = completeStatus;
        BlocProvider.of<HomeScreenTaskBloc>(context).dispatch(CompleteTaskEvent(
            task: Provider.of<TaskHolderProviderModel>(context).taskEntity));
      };
    }
  }

  TextStyle selectTaskStyle() {
    TextStyle taskTextStyle;
    // calculating if the task is completed
    if (isCompleted) {
      taskTextStyle = CommonTextStyles.disabledTaskTextStyle();
    } else {
      taskTextStyle = CommonTextStyles.taskTextStyle();
    }
    // calculating if the task is for a previous day
    if (Provider.of<TaskHolderProviderModel>(context)
            .taskEntity
            .runningDate
            .day <
        DateTime.now().day) {
      taskTextStyle = CommonTextStyles.disabledTaskTextStyle();
    }
    return taskTextStyle;
  }

  Color selectCheckStyleColor() {
    Color checkStyleActiveColor;
    // calculating if the task is for a previous day
    if (Provider.of<TaskHolderProviderModel>(context)
            .taskEntity
            .runningDate
            .day <
        DateTime.now().day) {
      checkStyleActiveColor = Colors.grey;
    } else {
      checkStyleActiveColor = CommonColors.toggleableActiveColor;
    }
    return checkStyleActiveColor;
  }
}
