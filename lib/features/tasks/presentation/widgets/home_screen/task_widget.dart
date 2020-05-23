import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
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
        onTap: () async {
          final taskEntity = await showCupertinoModalPopup(
            context: context,
            builder: (_) {
              return Container(
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
                    child: DraggableScrollableSheet(
                      initialChildSize: 0.75,
                      maxChildSize: 1.0,
                      expand: false,
                      builder: (_, controller) {
                        return Container(
                          color: Colors.transparent,
                          child: Material(
                            child:
                                ChangeNotifierProvider<TaskDetailProviderModel>(
                              create: (_) => TaskDetailProviderModel(
                                taskTitle: taskState.taskEntity.taskTitle,
                                tag: taskState.taskEntity.tag,
                                description: taskState.taskEntity.description,
                                urgency:
                                    taskState.taskEntity.urgency.toString(),
                                notificationTime:
                                    taskState.taskEntity.notificationTime,
                              ),
                              child: EditTaskWidget(task: taskState.taskEntity),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
          if (taskEntity != null &&
              taskEntity is TaskEntity &&
              taskEntity.isDeleted) {
//            taskEntity.isCompleted = isCompleted;
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
            top: CommonDimens.MARGIN_20,
            left: CommonDimens.MARGIN_20,
            right: CommonDimens.MARGIN_20,
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
                  Expanded(
                    child: Text(
                      taskState.taskEntity.taskTitle,
                      style: selectTaskStyle(taskState),
                    ),
                  ),
                  Checkbox(
                    value: isCompleted,
                    checkColor: appState.currentTheme.accentColor,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    activeColor: selectCheckStyleColor(taskState),
                    onChanged: selectCheckBoxState(taskState),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Function selectCheckBoxState(TaskHolderProviderModel taskState) {
    return (completeStatus) {
      // update the status
      isCompleted = completeStatus;
      // update the update time
      taskState.taskEntity.lastUpdatedAt = DateTime.now();
      BlocProvider.of<HomeScreenTaskBloc>(context)
          .add(CompleteTaskEvent(task: taskState.taskEntity));
    };
  }

  TextStyle selectTaskStyle(TaskHolderProviderModel taskState) {
    TextStyle taskTextStyle;
    // calculating if the task is completed
    if (isCompleted) {
      taskTextStyle = CommonTextStyles.disabledTaskTextStyle();
    } else {
      taskTextStyle = CommonTextStyles.taskTextStyle(context);
    }
    // calculating if the task is for a previous day
    if (taskState.taskEntity.runningDate.day < DateTime.now().day) {
      taskTextStyle = CommonTextStyles.disabledTaskTextStyle();
    }
    return taskTextStyle;
  }

  Color selectCheckStyleColor(TaskHolderProviderModel taskState) {
    Color checkStyleActiveColor;
    // calculating if the task is for a previous day
    if (taskState.taskEntity.runningDate.day < DateTime.now().day) {
      checkStyleActiveColor = Colors.grey;
    } else {
      checkStyleActiveColor = CommonColors.toggleableActiveColor;
    }
    return checkStyleActiveColor;
  }
}
