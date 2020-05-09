import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
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
    isCompleted =
        Provider.of<TaskHolderProviderModel>(context).taskEntity.isCompleted;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final taskEntity = await showCupertinoModalPopup(
            context: context,
            builder: (_) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: DraggableScrollableSheet(
                  initialChildSize: 0.8,
                  maxChildSize: 1.0,
                  expand: false,
                  builder: (_, controller) {
                    return Container(
                      color: CommonColors.scaffoldColor,
                      child: Material(
                        child: ChangeNotifierProvider<TaskDetailProviderModel>(
                          create: (_) => TaskDetailProviderModel(
                            taskTitle:
                                Provider.of<TaskHolderProviderModel>(context)
                                    .taskEntity
                                    .taskTitle,
                            tag: Provider.of<TaskHolderProviderModel>(context)
                                .taskEntity
                                .tag,
                            description:
                                Provider.of<TaskHolderProviderModel>(context)
                                    .taskEntity
                                    .description,
                            urgency:
                                Provider.of<TaskHolderProviderModel>(context)
                                    .taskEntity
                                    .urgency
                                    .toString(),
                          ),
                          child: EditTaskWidget(
                              task:
                                  Provider.of<TaskHolderProviderModel>(context)
                                      .taskEntity),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
          if (taskEntity != null && taskEntity is TaskEntity) {
            taskEntity.isCompleted = isCompleted;
            BlocProvider.of<HomeScreenTaskBloc>(context).dispatch(UpdateTaskEvent(task: taskEntity));
          }
        },
        child: Container(
          padding: const EdgeInsets.only(
            top: CommonDimens.MARGIN_20,
            left: CommonDimens.MARGIN_20,
            right: CommonDimens.MARGIN_20,
            bottom: CommonDimens.MARGIN_20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (Provider.of<TaskHolderProviderModel>(context)
                          .taskEntity
                          .tag !=
                      null &&
                  Provider.of<TaskHolderProviderModel>(context)
                      .taskEntity
                      .tag
                      .isNotEmpty)
                TaskBadge(
                  isCompleted: isCompleted,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
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
          ),
        ),
      ),
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
