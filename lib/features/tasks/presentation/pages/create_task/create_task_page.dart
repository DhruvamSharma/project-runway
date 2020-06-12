import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/common_ui/custom_text_field.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/date_time_parser.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/core/notifications/local_notifications.dart';
import 'package:project_runway/core/task_utility.dart';
import 'package:project_runway/core/theme/theme.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';
import 'package:project_runway/features/tasks/presentation/manager/bloc.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreateTaskPage extends StatelessWidget {
  static const String routeName = "${APP_NAME}_v1_task_create-screen";
  final String screenName = "CREATE";
  final DateTime runningDate;
  final String initialTaskTitle;
  final int totalTasksCreated;
  CreateTaskPage({
    @required this.runningDate,
    @required this.totalTasksCreated,
    this.initialTaskTitle = "",
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
                    Scaffold.of(newContext).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text("Your task has been created"),
                      ),
                    );
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
                              top: CommonDimens.MARGIN_20,
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
                                    Scaffold.of(newContext)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        "Sorry, you cannot select this time",
                                        style:
                                            CommonTextStyles.scaffoldTextStyle(
                                                newContext),
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Provider.of<ThemeModel>(
                                                      newContext,
                                                      listen: false)
                                                  .currentTheme ==
                                              lightTheme
                                          ? CommonColors.scaffoldColor
                                          : CommonColors.accentColor,
                                    ));
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
                              child: MaterialButton(
                                color: appState.currentTheme.accentColor,
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
                        ],
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
          SnackBar(
            content: Text(
              "Please enter title for your task",
              style: CommonTextStyles.scaffoldTextStyle(newContext),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: appState.currentTheme == lightTheme
                ? CommonColors.scaffoldColor
                : CommonColors.accentColor,
          ),
        );
      }
    } else {
      Scaffold.of(newContext).showSnackBar(
        SnackBar(
          content: Text(
            "Sorry, you cannot create any more tasks for today",
            style: CommonTextStyles.scaffoldTextStyle(newContext),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: appState.currentTheme == lightTheme
              ? CommonColors.scaffoldColor
              : CommonColors.accentColor,
        ),
      );
    }
  }
}

class TaskDetailProviderModel extends ChangeNotifier {
  String taskTitle;
  String urgency;
  String description;
  String tag;
  DateTime notificationTime;

  TaskDetailProviderModel({
    this.taskTitle,
    this.urgency,
    this.tag,
    this.description,
    this.notificationTime,
  });

  assignTaskTitle(String title) {
    taskTitle = title;
    notifyListeners();
  }

  assignNotificationTime(DateTime time) {
    notificationTime = time;
    notifyListeners();
  }

  assignTaskDescription(String description) {
    this.description = description;
    notifyListeners();
  }

  assignTaskUrgency(String urgency) {
    this.urgency = urgency;
    notifyListeners();
  }

  assignTaskTag(String tag) {
    this.tag = tag;
    notifyListeners();
  }
}
