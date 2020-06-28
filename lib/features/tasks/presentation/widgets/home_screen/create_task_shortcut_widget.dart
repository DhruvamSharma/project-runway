import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/analytics_utils.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_ui/custom_snackbar.dart';
import 'package:project_runway/core/common_ui/custom_text_field.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/core/remote_config/remote_config_service.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';
import 'package:project_runway/features/tasks/presentation/manager/bloc.dart';
import 'package:project_runway/features/tasks/presentation/pages/create_task/create_task_page.dart';
import 'package:project_runway/features/tasks/presentation/pages/create_task/create_task_screen_arguments.dart';
import 'package:project_runway/features/tasks/presentation/pages/draw_task/draw_task.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/current_task_page.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/task_page.dart';
import 'package:project_runway/features/tasks/presentation/widgets/speech_task/speech_icon.dart';
import 'package:project_runway/features/vision_boards/presentation/pages/vision_board_list/vision_board_list_args.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:uuid/uuid.dart';

class CreateTaskShortcutWidget extends StatelessWidget {
  final int totalTaskNumber;
  final RemoteConfigService remoteConfigService = sl<RemoteConfigService>();
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
            SizedBox(
              height: 100,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: GestureDetector(
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
                          left: CommonDimens.MARGIN_40,
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
                          textFieldValue:
                              Provider.of<InitialTaskTitleProviderModel>(
                                      context)
                                  .taskTitle,
                          label: buildLabelForTaskField(pageState),
                          isRequired: false,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: CommonDimens.MARGIN_20,
                    ),
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: FloatingActionButton(
                        mini: true,
                        tooltip: "Create Task",
                        heroTag: "action_button_${pageState.pageNumber}",
                        onPressed: () {
                          onCreateTask(context, pageState, taskListState);
                        },
                        child: CircleAvatar(
                          backgroundColor:
                              buildIconColor(appState, pageState.pageNumber),
                          child: Icon(
                            Icons.add,
                            color:
                                appState.currentTheme.scaffoldBackgroundColor,
                            size: 21,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: CommonDimens.MARGIN_20,
                  right: CommonDimens.MARGIN_20,
                ),
                child: SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: <Widget>[
                      SpeechIcon(),
                      IconButton(
                        iconSize: 21,
                        icon: Icon(Icons.palette,
                            color:
                                buildIconColor(appState, pageState.pageNumber)),
                        onPressed: () async {
                          try {
                            AnalyticsUtils.sendAnalyticEvent(
                                DRAW_SHORTCUT,
                                {
                                  "pageNumber": pageState.pageNumber,
                                },
                                "DRAW_WIDGET");
                          } catch (Ex) {
                            // failed logging event
                          }
                          if (taskListState.taskList.length <=
                                  remoteConfigService.maxTaskLimit &&
                              pageState.pageNumber != 0) {
                            final response = await Navigator.pushNamed(
                                context, DrawTaskRoute.routeName,
                                arguments:
                                    VisionBoardListArgs(pageState.pageNumber));
                            if (response != null &&
                                (response as String).isNotEmpty) {
                              Provider.of<InitialTaskTitleProviderModel>(
                                      context,
                                      listen: false)
                                  .assignTaskTitle(response as String);
                            }
                          } else {
                            String errorMessage =
                                "Sorry, you cannot create any more tasks";
                            if (pageState.pageNumber == 0) {
                              errorMessage =
                                  "You cannot create task for yesterday";
                            }
                            Scaffold.of(context).removeCurrentSnackBar();
                            Scaffold.of(context).showSnackBar(
                              CustomSnackbar.withAnimation(
                                context,
                                errorMessage,
                              ),
                            );
                          }
                        },
                        tooltip: "Draw your task",
                      ),
                      IconButton(
                        iconSize: 21,
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
                      IconButton(
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
                            String errorMessage =
                                "Sorry, you cannot create any more tasks";
                            if (pageState.pageNumber == 0) {
                              errorMessage =
                                  "You cannot create task for yesterday";
                            }
                            Scaffold.of(context).removeCurrentSnackBar();
                            Scaffold.of(context).showSnackBar(
                              CustomSnackbar.withAnimation(
                                context,
                                errorMessage,
                              ),
                            );
                          }
                        },
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                        icon: Icon(
                          Icons.info,
                          color: buildIconColor(appState, pageState.pageNumber),
                        ),
                        tooltip: "More Detail",
                        iconSize: 21,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onCreateTask(
      BuildContext context, pageState, TaskListHolderProvider taskListState) {
    AnalyticsUtils.sendAnalyticEvent(
        CREATE_TASK_SHORTCUT,
        {
          "pageNumber": pageState.pageNumber,
        },
        "SHORTCUT_WIDGET");
    // check if the user can create the task or not.
    if (pageState.pageNumber != 0) {
      if (totalTaskNumber <= remoteConfigService.maxTaskLimit) {
        String initialTitle;
        if (Provider.of<InitialTaskTitleProviderModel>(context, listen: false)
                .taskTitle !=
            null) {
          initialTitle =
              Provider.of<InitialTaskTitleProviderModel>(context, listen: false)
                  .taskTitle;
        }
        // check if the task is entered in the field or not
        if (initialTitle != null && initialTitle.isNotEmpty) {
          final TaskEntity task = createTaskArgs(context, pageState);
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
