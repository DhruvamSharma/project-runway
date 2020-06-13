import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/analytics_utils.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/common_ui/custom_snackbar.dart';
import 'package:project_runway/core/common_ui/custom_text_field.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/theme/theme.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';
import 'package:project_runway/features/tasks/presentation/manager/bloc.dart';
import 'package:project_runway/features/tasks/presentation/pages/create_task/create_task_page.dart';
import 'package:project_runway/features/tasks/presentation/pages/create_task/create_task_screen_arguments.dart';
import 'package:project_runway/features/tasks/presentation/pages/draw_task/draw_task.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/current_task_page.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/task_page.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:uuid/uuid.dart';

class CreateTaskShortcutWidget extends StatelessWidget {
  final int totalTaskNumber;
  CreateTaskShortcutWidget({
    @required this.totalTaskNumber,
  });

  @override
  Widget build(BuildContext parentContext) {
    final appState = Provider.of<ThemeModel>(parentContext, listen: false);
    final pageState =
        Provider.of<PageHolderProviderModel>(parentContext, listen: false);
    final taskListState =
        Provider.of<TaskListHolderProvider>(parentContext, listen: false);
    return ChangeNotifierProvider<InitialTaskTitleProviderModel>(
      create: (_) => InitialTaskTitleProviderModel(),
      child: Builder(
        builder: (context) => Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                if (pageState.pageNumber == 0) {
                  Scaffold.of(context).removeCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(
                    CustomSnackbar.withAnimation(
                      context,
                      "Sorry, you cannot create any more tasks",
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  top: CommonDimens.MARGIN_40,
                  left: CommonDimens.MARGIN_40,
                  right: CommonDimens.MARGIN_40,
                ),
                child: CustomTextField(
                  null,
                  null,
                  enabled: pageState.pageNumber != 0,
                  onValueChange: (text) {
                    Provider.of<InitialTaskTitleProviderModel>(context,
                            listen: false)
                        .assignTaskTitle(text);
                  },
                  textFieldValue: Provider.of<InitialTaskTitleProviderModel>(
                          context,
                          listen: false)
                      .taskTitle,
                  label: buildLabelForTaskField(pageState),
                  isRequired: false,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: CommonDimens.MARGIN_20,
                  right: CommonDimens.MARGIN_20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.format_paint,
                          color:
                              buildIconColor(appState, pageState.pageNumber)),
                      onPressed: () async {
                        if (taskListState.taskList.length <=
                                TOTAL_TASK_CREATION_LIMIT &&
                            pageState.pageNumber != 0) {
                          final response = await Navigator.pushNamed(
                              context, DrawTaskRoute.routeName);
                          print(response);
                          if (response != null &&
                              (response as String).isNotEmpty) {
                            Provider.of<InitialTaskTitleProviderModel>(context,
                                    listen: false)
                                .assignTaskTitle(response as String);
                          }
                        } else {
                          Scaffold.of(context).removeCurrentSnackBar();
                          Scaffold.of(context).showSnackBar(
                            CustomSnackbar.withAnimation(
                              context,
                              "You cannot create task for yesterday",
                            ),
                          );
                        }
                      },
                      tooltip: "Draw Task",
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: CommonDimens.MARGIN_20,
                      ),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        tooltip: "Share List",
                        icon: Icon(Icons.share,
                            color:
                                buildIconColor(appState, pageState.pageNumber)),
                        onPressed: () {
                          try {
                            AnalyticsUtils.sendAnalyticEvent(
                                SHARE_LIST,
                                {
                                  "pageNumber": pageState.pageNumber,
                                },
                                "SHORTCUT_WIDGET");
                            if (taskListState.taskList.length > 0) {
                              Share.share(buildShareListText(taskListState));
                            } else {
                              Scaffold.of(context).removeCurrentSnackBar();
                              Scaffold.of(context).showSnackBar(
                                CustomSnackbar.withAnimation(
                                  context,
                                  "Oops, you cannot share an empty list",
                                ),
                              );
                            }
                          } catch (ex) {}
                        },
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                      ),
                    ),
                    OutlineButton(
                      highlightedBorderColor: CommonColors.chartColor,
                      onPressed: () async {
                        AnalyticsUtils.sendAnalyticEvent(
                            MORE_DETAILS,
                            {
                              "pageNumber": pageState.pageNumber,
                            },
                            "SHORTCUT_WIDGET");
                        if (pageState.pageNumber != 0) {
                          String taskTitle =
                              Provider.of<InitialTaskTitleProviderModel>(
                                      context,
                                      listen: false)
                                  .taskTitle;
                          Provider.of<InitialTaskTitleProviderModel>(context,
                                  listen: false)
                              .assignTaskTitle("");
                          final data = await Navigator.pushNamed(
                            context,
                            CreateTaskPage.routeName,
                            arguments: CreateTaskScreenArguments(
                              runningDate: pageState.runningDate,
                              initialTaskTitle: taskTitle,
                              totalTasksCreated: totalTaskNumber,
                            ),
                          );
                          if (data != null && data is TaskEntity) {
                            taskListState.insertTaskToList(data);
                          }
                        } else {
                          Scaffold.of(context).removeCurrentSnackBar();
                          Scaffold.of(context).showSnackBar(
                            CustomSnackbar.withAnimation(
                              context,
                              "You cannot create task for yesterday",
                            ),
                          );
                        }
                      },
                      child: Text(
                        "More Details",
                        style: CommonTextStyles.disabledTaskTextStyle()
                            .copyWith(
                                color: buildIconColor(
                                    appState, pageState.pageNumber),
                                letterSpacing: 3,
                                fontSize: 14),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: CommonDimens.MARGIN_20,
                      ),
                      child: IconButton(
                          tooltip: "Create Task",
                          icon: Icon(
                            Icons.send,
                            color:
                                buildIconColor(appState, pageState.pageNumber),
                            semanticLabel: "Create Task",
                          ),
                          onPressed: () {
                            AnalyticsUtils.sendAnalyticEvent(
                                CREATE_TASK_SHORTCUT,
                                {
                                  "pageNumber": pageState.pageNumber,
                                },
                                "SHORTCUT_WIDGET");
                            // check if the user can create the task or not.
                            if (pageState.pageNumber != 0) {
                              if (totalTaskNumber <=
                                  TOTAL_TASK_CREATION_LIMIT) {
                                String initialTitle;
                                if (Provider.of<InitialTaskTitleProviderModel>(
                                            context,
                                            listen: false)
                                        .taskTitle !=
                                    null) {
                                  initialTitle = Provider.of<
                                              InitialTaskTitleProviderModel>(
                                          context,
                                          listen: false)
                                      .taskTitle;
                                }
                                // check if the task is entered in the field or not
                                if (initialTitle != null &&
                                    initialTitle.isNotEmpty) {
                                  final TaskEntity task =
                                      createTaskArgs(context, pageState);
                                  // add to data base
                                  BlocProvider.of<HomeScreenTaskBloc>(context)
                                      .add(CreateTaskEvent(task: task));
                                  // update the list
                                  try {
                                    taskListState.insertTaskToList(task);
                                  } catch (ex) {
                                    print(ex);
                                  }
                                } else {
                                  Scaffold.of(context).removeCurrentSnackBar();
                                  Scaffold.of(context).showSnackBar(
                                    CustomSnackbar.withAnimation(
                                      context,
                                      "Please enter title for your task",
                                    ),
                                  );
                                }
                              } else {
                                Scaffold.of(context).removeCurrentSnackBar();
                                Scaffold.of(context).showSnackBar(
                                  CustomSnackbar.withAnimation(
                                    context,
                                    "Sorry, you cannot create any more tasks",
                                  ),
                                );
                              }
                              Provider.of<InitialTaskTitleProviderModel>(
                                context,
                                listen: false,
                              ).assignTaskTitle("");
                            } else {
                              Scaffold.of(context).removeCurrentSnackBar();
                              Scaffold.of(context).showSnackBar(
                                CustomSnackbar.withAnimation(
                                  context,
                                  "You cannot create task for yesterday",
                                ),
                              );
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color buildIconColor(ThemeModel appState, int pageNumber) {
    if (appState.currentTheme == darkTheme) {
      if (pageNumber == 0) {
        return CommonColors.taskTextColor.withOpacity(0.38);
      } else {
        return CommonColors.taskTextColor.withOpacity(0.60);
      }
    } else {
      if (pageNumber == 0) {
        return CommonColors.scaffoldColor.withOpacity(0.38);
      } else {
        return CommonColors.scaffoldColor.withOpacity(0.60);
      }
    }
  }

  String buildLabelForTaskField(PageHolderProviderModel pageState) {
    int pageNumber = pageState.pageNumber;
    if (pageNumber == 0) {
      return "Cannot create for yesterday";
    } else if (pageNumber == 1) {
      return "Today's Task Title";
    } else {
      return "Tomorrow's Task Title";
    }
  }

  TaskEntity createTaskArgs(
      BuildContext context, PageHolderProviderModel pageState) {
    final task = TaskEntity(
      userId: "Dhruvam",
      taskId: Uuid().v1(),
      taskTitle:
          Provider.of<InitialTaskTitleProviderModel>(context, listen: false)
              .taskTitle,
      description: null,
      urgency: DEFAULT_URGENCY,
      tag: null,
      notificationTime: null,
      createdAt: DateTime.now(),
      runningDate: pageState.runningDate,
      lastUpdatedAt: DateTime.now(),
      isSynced: false,
      isDeleted: false,
      isMovable: false,
      isCompleted: false,
    );
    return task;
  }

  String buildShareListText(TaskListHolderProvider taskListState) {
    String taskListString = "Here is a list I've prepared\n";
    for (int i = 0; i < taskListState.taskList.length; i++) {
      taskListString += "${i + 1}. ${taskListState.taskList[i].taskTitle}";
      if (i != taskListState.taskList.length - 1) {
        taskListString += "\n";
      }
    }
    return taskListString;
  }
}

class InitialTaskTitleProviderModel extends ChangeNotifier {
  String taskTitle;

  assignTaskTitle(String title) {
    taskTitle = title;
    notifyListeners();
  }
}
