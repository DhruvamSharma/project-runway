import 'package:flutter/material.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/date_time_parser.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/current_task_page.dart';
import 'package:provider/provider.dart';

class TaskBadge extends StatelessWidget {
  final bool isCompleted;
  TaskBadge({
    @required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ThemeModel>(context, listen: false);
    final taskState =
        Provider.of<TaskHolderProviderModel>(context, listen: false);
    return Container(
      color: selectBadgeColor(context, appState, taskState),
      padding: const EdgeInsets.symmetric(
        horizontal: 2,
        vertical: 1,
      ),
      child: Text(
        taskState.taskEntity.tag,
        style: CommonTextStyles.badgeTextStyle(context).copyWith(
          color: CommonColors.accentColor,
        ),
      ),
    );
  }

  Color selectBadgeColor(BuildContext context, ThemeModel appState,
      TaskHolderProviderModel taskState) {
    Color badgeColor;
    if (isCompleted) {
      badgeColor = CommonColors.taskTextColor.withOpacity(0.38);
    } else {
      badgeColor = CommonColors.chartColor;
    }

    // calculating if the task is for a previous day
    if (checkIsTaskIsOfPast(taskState.taskEntity.runningDate)) {
      badgeColor = CommonColors.taskTextColor.withOpacity(0.38);
    }
    return badgeColor;
  }
}
