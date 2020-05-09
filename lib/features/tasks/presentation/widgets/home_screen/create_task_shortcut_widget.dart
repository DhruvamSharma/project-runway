import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/common_ui/custom_text_field.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';
import 'package:project_runway/features/tasks/presentation/manager/bloc.dart';
import 'package:project_runway/features/tasks/presentation/pages/create_task/create_task_page.dart';
import 'package:project_runway/features/tasks/presentation/pages/create_task/create_task_screen_arguments.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/current_task_page.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/task_page.dart';
import 'package:provider/provider.dart';

class CreateTaskShortcutWidget extends StatelessWidget {
  final int totalTaskNumber;

  CreateTaskShortcutWidget({
    @required this.totalTaskNumber,
  });

  @override
  Widget build(BuildContext parentContext) {
    return ChangeNotifierProvider<InitialTaskTitleProviderModel>(
      create: (_) => InitialTaskTitleProviderModel(),
      child: Builder(
        builder: (context) => Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: CommonDimens.MARGIN_40,
                left: CommonDimens.MARGIN_20,
                right: CommonDimens.MARGIN_20,
              ),
              child: CustomTextField(
                null,
                null,
                enabled:
                    Provider.of<PageHolderProviderModel>(context).pageNumber !=
                        0,
                onValueChange: (text) {
                  Provider.of<InitialTaskTitleProviderModel>(context)
                      .assignTaskTitle(text);
                },
                textFieldValue: Provider.of<InitialTaskTitleProviderModel>(context).taskTitle,
                label: "Task Title",
                isRequired: false,
              ),
            ),
            if (Provider.of<PageHolderProviderModel>(context).pageNumber != 0)
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
                      OutlineButton(
                        onPressed: () async {
                          String taskTitle = Provider.of<InitialTaskTitleProviderModel>(context)
                              .taskTitle;
                          Provider.of<InitialTaskTitleProviderModel>(context)
                              .assignTaskTitle("");
                          final data = await Navigator.pushNamed(
                            context,
                            CreateTaskPage.routeName,
                            arguments: CreateTaskScreenArguments(
                              runningDate:
                                  Provider.of<PageHolderProviderModel>(context)
                                      .runningDate,
                              initialTaskTitle: taskTitle,
                              totalTasksCreated: totalTaskNumber,
                            ),
                          );
                          if (data != null && data is TaskEntity) {
                            Provider.of<TaskListHolderProvider>(context)
                                .insertTaskToList(data);
                          }
                        },
                        child: Text("More Details"),
                      ),
                      Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          onTap: () {
                            // check if the user can create the task or not.
                            if (totalTaskNumber <= TOTAL_TASK_CREATION_LIMIT) {
                              String initialTitle =
                                  Provider.of<InitialTaskTitleProviderModel>(
                                          context)
                                      .taskTitle;
                              // check if the task is entered in the field or not
                              if (initialTitle != null &&
                                  initialTitle.isNotEmpty) {
                                final task = createTaskArgs(context);
                                BlocProvider.of<HomeScreenTaskBloc>(context)
                                    .dispatch(CreateTaskEvent(task: task));
                              } else {
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(
                                        "Please enter title for your amazing task"),
                                  ),
                                );
                              }
                            } else {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                      "Sorry, you cannot create more any more tasks"),
                                ),
                              );
                            }
                            Provider.of<InitialTaskTitleProviderModel>(context)
                                .assignTaskTitle("");
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 32.0),
                            child: Icon(
                              Icons.send,
                              semanticLabel: "Create Task",
                            ),
                          ),
                        ),
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

  TaskEntity createTaskArgs(BuildContext context) {
    final task = TaskEntity(
      userId: "Dhruvam",
      taskId: "hello",
      taskTitle: Provider.of<InitialTaskTitleProviderModel>(context).taskTitle,
      description: null,
      urgency: DEFAULT_URGENCY,
      tag: null,
      notificationTime: null,
      createdAt: DateTime.now(),
      runningDate: Provider.of<PageHolderProviderModel>(context).runningDate,
      lastUpdatedAt: DateTime.now(),
      isSynced: false,
      isDeleted: false,
      isMovable: false,
      isCompleted: false,
    );
    return task;
  }
}

class InitialTaskTitleProviderModel extends ChangeNotifier {
  String taskTitle;

  assignTaskTitle(String title) {
    taskTitle = title;
    notifyListeners();
  }
}
