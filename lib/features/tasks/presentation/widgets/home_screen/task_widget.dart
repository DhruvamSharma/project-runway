import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkable/linkable.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/date_time_parser.dart';
import 'package:project_runway/core/theme/theme.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';
import 'package:project_runway/features/tasks/presentation/manager/bloc.dart';
import 'package:project_runway/features/tasks/presentation/pages/create_task/create_task_page.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/current_task_page.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/edit_task_widget.dart';
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
    isCompleted = Provider.of<TaskHolderProviderModel>(context, listen: false)
        .taskEntity
        .isCompleted;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ThemeModel>(context, listen: false);
    final taskState =
        Provider.of<TaskHolderProviderModel>(context, listen: false);
    final taskListState = Provider.of<TaskListHolderProvider>(
      context,
    );
    return Material(
      child: InkWell(
        highlightColor: Colors.transparent,
        onTap: () async {
          final taskEntity = await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) {
              return Container(
                height: 0.8 * MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: appState.currentTheme == lightTheme
                      ? CommonColors.bottomSheetColorLightTheme
                      : CommonColors.bottomSheetColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Theme(
                    data: ThemeData.light()
                        .copyWith(canvasColor: Colors.transparent),
                    child: Container(
                      color: Colors.transparent,
                      child: Material(
                        child: ChangeNotifierProvider<TaskDetailProviderModel>(
                          create: (_) => TaskDetailProviderModel(
                            taskTitle: taskState.taskEntity.taskTitle,
                            tag: taskState.taskEntity.tag,
                            description: taskState.taskEntity.description,
                            urgency: taskState.taskEntity.urgency.toString(),
                            notificationTime:
                                taskState.taskEntity.notificationTime,
                          ),
                          child: EditTaskWidget(task: taskState.taskEntity),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
          if (taskEntity != null &&
              taskEntity is TaskEntity &&
              taskEntity.isDeleted) {
            BlocProvider.of<HomeScreenTaskBloc>(context)
                .add(DeleteTaskEvent(task: taskEntity));
            taskListState.deleteTaskItemFromList(taskEntity);
          } else if (taskEntity != null && taskEntity is TaskEntity) {
            taskEntity.isCompleted = isCompleted;
            BlocProvider.of<HomeScreenTaskBloc>(context)
                .add(UpdateTaskEvent(task: taskEntity));
          }
        },
        child: Container(
          padding: const EdgeInsets.only(
            top: CommonDimens.MARGIN_20 / 1.5,
            left: CommonDimens.MARGIN_20,
            right: CommonDimens.MARGIN_20,
            bottom: CommonDimens.MARGIN_20 / 1.5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (taskState.taskEntity.tag != null &&
                  taskState.taskEntity.tag.isNotEmpty)
                TaskBadge(
                  isCompleted: isCompleted,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: appState.currentTheme.iconTheme.color,
                      child: Text(
                        taskState.taskEntity.urgency.toString(),
                        style: CommonTextStyles.badgeTextStyle(context)
                            .copyWith(
                                color: appState
                                    .currentTheme.scaffoldBackgroundColor),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Linkable(
                      text: taskState.taskEntity.taskTitle,
                      style: selectTaskStyle(
                        taskState.taskEntity,
                        context,
                        isCompleted,
                      ),
                      textColor: selectTaskStyle(
                              taskState.taskEntity, context, isCompleted)
                          .color,
                    ),
                  ),
                  Theme(
                    data: ThemeData(
                        focusColor: Colors.amber,
                        unselectedWidgetColor:
                            appState.currentTheme.accentColor),
                    child: Checkbox(
                      value: isCompleted,
                      checkColor:
                          appState.currentTheme.accentColor.withOpacity(0.60),
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      activeColor: selectCheckStyleColor(taskState),
                      onChanged: selectCheckBoxState(taskState),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Function selectCheckBoxState(
    TaskHolderProviderModel taskState,
  ) {
    return (completeStatus) {
      // update the status
      isCompleted = completeStatus;
      // update the update time
      taskState.taskEntity.lastUpdatedAt = DateTime.now();
      taskState.taskEntity.isCompleted = isCompleted;
      BlocProvider.of<HomeScreenTaskBloc>(context)
          .add(CompleteTaskEvent(task: taskState.taskEntity));
    };
  }

  Color selectCheckStyleColor(TaskHolderProviderModel taskState) {
    Color checkStyleActiveColor;
    // calculating if the task is for a previous day
    if (checkIsTaskIsOfPast(taskState.taskEntity.runningDate)) {
      checkStyleActiveColor = CommonColors.taskTextColor.withOpacity(0.38);
    } else {
      checkStyleActiveColor = Colors.grey;
    }
    return checkStyleActiveColor;
  }
}
