import 'package:flutter/material.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/current_task_page.dart';
import 'package:provider/provider.dart';

import 'home_screen/task_widget.dart';

class TaskBadge extends StatelessWidget {
  final bool isCompleted;
  TaskBadge({
    @required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: selectBadgeColor(context),
      padding: const EdgeInsets.symmetric(
        horizontal: 2,
        vertical: 1,
      ),
      child: Text(
        Provider.of<TaskHolderProviderModel>(context).taskEntity.tag,
        style: CommonTextStyles.badgeTextStyle(),
      ),
    );
  }

  Color selectBadgeColor(BuildContext context) {
    Color badgeColor;
    if (isCompleted) {
      badgeColor = CommonColors.disabledTaskTextColor;
    } else {
      badgeColor = CommonColors.taskBadgeColor;
    }

    // calculating if the task is for a previous day
    if (Provider.of<TaskHolderProviderModel>(context)
            .taskEntity
            .runningDate
            .day <
        DateTime.now().day) {
      badgeColor = CommonColors.disabledTaskTextColor;
    }
    return badgeColor;
  }
}
