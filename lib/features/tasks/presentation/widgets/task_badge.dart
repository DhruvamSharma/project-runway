import 'package:flutter/material.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_text_styles.dart';

class TaskBadge extends StatelessWidget {
  final String taskTag;

  TaskBadge({
    @required this.taskTag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CommonColors.taskBadgeColor,
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1,),
      child: Text(
        taskTag,
        style: CommonTextStyles.badgeTextStyle(),
      ),
    );
  }
}
