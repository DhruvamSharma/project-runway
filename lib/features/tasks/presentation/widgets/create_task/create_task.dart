import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/common_ui/custom_snackbar.dart';
import 'package:project_runway/core/common_ui/custom_text_field.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/date_time_parser.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/core/notifications/local_notifications.dart';
import 'package:project_runway/core/task_utility.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';
import 'package:project_runway/features/tasks/presentation/manager/bloc.dart';
import 'package:project_runway/features/tasks/presentation/pages/create_task/create_task_page.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreateTaskWidget extends StatelessWidget {
  final String screenName = "CREATE";
  final DateTime runningDate;
  final String initialTaskTitle;
  final int totalTasksCreated;

  CreateTaskWidget({
    this.runningDate,
    this.initialTaskTitle,
    this.totalTasksCreated,
  });

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ThemeModel>(context, listen: false);
    return ChangeNotifierProvider<TaskDetailProviderModel>(
      create: (_) => TaskDetailProviderModel(taskTitle: initialTaskTitle),
      child: BlocProvider<HomeScreenTaskBloc>(
        create: (_) => sl<HomeScreenTaskBloc>(),
        child: BlocBuilder<HomeScreenTaskBloc, TaskBlocState>(
          builder: (_, state) => Scaffold(
            appBar: AppBar(
              backgroundColor: CommonColors.appBarColor,
            ),
            body: Builder(builder: (newContext) {
              final taskDetailState = Provider.of<TaskDetailProviderModel>(
                  newContext,
                  listen: false);
              return BlocListener<HomeScreenTaskBloc, TaskBlocState>(
                listener: (_, state) {
                  if (state is LoadedCreateScreenCreateTaskState) {
                    taskDetailState.assignIsCreating(false);
                    Navigator.pop(context, state.taskEntity);
                  }

                  if (state is ErrorCreateScreenCreateTaskState) {}
                },
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          screenName.toUpperCase(),
                          style:
                              CommonTextStyles.rotatedDesignTextStyle(context),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              screenName.toUpperCase(),
                              style: CommonTextStyles.headerTextStyle(context),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: CommonDimens.MARGIN_20 / 2,
                            ),
                            child: Text(
                              beautifyDate(runningDate ?? ""),
                              style: CommonTextStyles.dateTextStyle(context),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: CommonDimens.MARGIN_60,
                              left: CommonDimens.MARGIN_20,
                              right: CommonDimens.MARGIN_20,
                            ),
                            child: CustomTextField(
                              null,
                              null,
                              initialText: initialTaskTitle,
                              onValueChange: (text) {
                                Provider.of<TaskDetailProviderModel>(newContext,
                                        listen: false)
                                    .assignTaskTitle(text);
                              },
                              label: "Task Title",
                              isRequired: false,
                              onSubmitted: (text) {},
                              errorTextStyle:
                                  CommonTextStyles.errorFieldTextStyle(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: CommonDimens.MARGIN_20,
                              left: CommonDimens.MARGIN_20,
                              right: CommonDimens.MARGIN_20,
                            ),
                            child: CustomTextField(
                              null,
                              null,
                              onValueChange: (description) {
                                Provider.of<TaskDetailProviderModel>(newContext,
                                        listen: false)
                                    .assignTaskDescription(description);
                              },
                              label: "Task Description",
                              isRequired: false,
                              onSubmitted: (text) {},
                              errorTextStyle:
                                  CommonTextStyles.errorFieldTextStyle(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: CommonDimens.MARGIN_20,
                              left: CommonDimens.MARGIN_20,
                              right: CommonDimens.MARGIN_20,
                            ),
                            child: CustomTextField(
                              null,
                              null,
                              onValueChange: (tag) {
                                Provider.of<TaskDetailProviderModel>(newContext,
                                        listen: false)
                                    .assignTaskTag(tag);
                              },
                              label: "Tag",
                              isRequired: false,
                              onSubmitted: (text) {},
                              errorTextStyle:
                                  CommonTextStyles.errorFieldTextStyle(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: CommonDimens.MARGIN_40,
                              left: CommonDimens.MARGIN_20,
                              right: CommonDimens.MARGIN_20,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Importance",
                                  style:
                                      CommonTextStyles.disabledTaskTextStyle(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Colors.black,
                                    child: Text(
                                      double.parse(taskDetailState.urgency ??
                                              DEFAULT_URGENCY.toString())
                                          .round()
                                          .toString(),
                                      style: CommonTextStyles.badgeTextStyle(
                                              context)
                                          .copyWith(
                                              color: CommonColors.accentColor,
                                              fontSize: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: CommonDimens.MARGIN_20,
                            ),
                            child: SliderTheme(
                              data: SliderThemeData(
                                  trackHeight: 5,
                                  showValueIndicator: ShowValueIndicator.always,
                                  activeTrackColor: CommonColors.chartColor,
                                  thumbColor:
                                      CommonColors.disabledTaskTextColor,
                                  valueIndicatorColor: CommonColors.chartColor,
                                  inactiveTrackColor:
                                      CommonColors.rotatedDesignTextColor),
                              child: Slider(
                                  min: 1,
                                  label: buildLabel(taskDetailState.urgency ??
                                      DEFAULT_URGENCY.toString()),
                                  max: 10,
                                  value: double.parse(taskDetailState.urgency ??
                                      DEFAULT_URGENCY.toString()),
                                  onChanged: (_) {
                                    taskDetailState.urgency = _.toString();
                                    taskDetailState
                                        .assignTaskUrgency(_.toString());
                                  }),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: CommonDimens.MARGIN_20,
                              left: CommonDimens.MARGIN_20,
                              right: CommonDimens.MARGIN_20,
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              title: Text(
                                "Notification Time",
                                style: CommonTextStyles.disabledTaskTextStyle(),
                              ),
                              trailing: Text(
                                Provider.of<TaskDetailProviderModel>(newContext,
                                                listen: true)
                                            .notificationTime !=
                                        null
                                    ? beautifyTime(
                                        Provider.of<TaskDetailProviderModel>(
                                                newContext,
                                                listen: false)
                                            .notificationTime)
                                    : "None",
                                style: CommonTextStyles.disabledTaskTextStyle(),
                              ),
                              onTap: () {
                                try {
                                  selectTimeForNotification(
                                      newContext, runningDate, () {
                                    Scaffold.of(newContext).showSnackBar(
                                      CustomSnackbar.withAnimation(
                                        context,
                                        "Sorry, you cannot select this time",
                                      ),
                                    );
                                  }, () {});
                                } catch (ex) {
                                  // Do something
                                }
                              },
                            ),
                          ),
                          Container(
                            color:
                                appState.currentTheme.scaffoldBackgroundColor,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: CommonDimens.MARGIN_40,
                                bottom: CommonDimens.MARGIN_20,
                              ),
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    color: CommonColors.accentColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: MaterialButton(
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {
                                    createTask(newContext, appState);
                                  },
                                  child: Text(
                                    "Create",
                                    style: CommonTextStyles.scaffoldTextStyle(
                                        context),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (taskDetailState.isCreating)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: LinearProgressIndicator(
                          minHeight: 5,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  void createTask(BuildContext newContext, ThemeModel appState) {
    final state =
        Provider.of<TaskDetailProviderModel>(newContext, listen: false);
    state.assignIsCreating(true);
    if (totalTasksCreated <= TOTAL_TASK_CREATION_LIMIT) {
      if (state.taskTitle != null && state.taskTitle.isNotEmpty) {
        DateTime createdAt = DateTime.now();
        final task = TaskEntity(
          userId: "Dhruvam",
          taskId: Uuid().v1(),
          taskTitle: state.taskTitle,
          description: state.description,
          urgency: buildUrgency(state.urgency),
          tag: state.tag,
          notificationTime: state.notificationTime,
          createdAt: createdAt,
          runningDate: runningDate,
          lastUpdatedAt: DateTime.now(),
          isSynced: false,
          isDeleted: false,
          isMovable: false,
          isCompleted: false,
        );

        // schedule the notification
        if (state.notificationTime != null) {
          scheduleNotification(
            createdAt.toString(),
            Provider.of<TaskDetailProviderModel>(newContext, listen: false)
                .taskTitle,
            state.notificationTime,
          );
        }

        BlocProvider.of<HomeScreenTaskBloc>(newContext)
            .add(CreateTaskEvent(task: task));
      } else {
        Scaffold.of(newContext).showSnackBar(
          CustomSnackbar.withAnimation(
            newContext,
            "Please enter title for your task",
          ),
        );
      }
    } else {
      Scaffold.of(newContext).showSnackBar(
        CustomSnackbar.withAnimation(
          newContext,
          "Sorry, you cannot create any more tasks for today",
        ),
      );
    }
  }
}
