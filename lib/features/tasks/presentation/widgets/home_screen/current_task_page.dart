import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/common_ui/custom_text_field.dart';
import 'package:project_runway/core/date_time_parser.dart';
import 'package:project_runway/core/keys.dart';
import 'package:project_runway/features/tasks/data/models/task_model.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';
import 'package:project_runway/features/tasks/domain/entities/task_list_entity.dart';
import 'package:project_runway/features/tasks/presentation/manager/bloc.dart';
import 'package:project_runway/features/tasks/presentation/pages/create_task/create_task_page.dart';
import 'package:project_runway/features/tasks/presentation/pages/create_task/create_task_screen_arguments.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/create_task_shortcut_widget.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/task_page.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/task_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentTaskPage extends StatefulWidget {
  @override
  _CurrentTaskPageState createState() => _CurrentTaskPageState();
}

class _CurrentTaskPageState extends State<CurrentTaskPage>
    with AutomaticKeepAliveClientMixin<CurrentTaskPage> {
  String initialTaskText;
  GlobalKey<AnimatedListState> animatedListStateKey = GlobalKey();

  @override
  void didChangeDependencies() {
    print("fetching tasks");
    getAllTasks();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider<TaskListHolderProvider>(
      create: (_) => TaskListHolderProvider(listState: animatedListStateKey),
      child: Builder(
        builder: (providerContext) {
          return BlocListener<HomeScreenTaskBloc, TaskBlocState>(
            listener: (_, state) {
              if (state is LoadedHomeScreenAllTasksState) {
                Provider.of<TaskListHolderProvider>(providerContext)
                    .assignTaskList(state.taskListEntity.taskList);
              }

              if (state is LoadedCreateScreenCreateTaskState) {
                Provider.of<TaskListHolderProvider>(providerContext)
                    .insertTaskToList(state.taskEntity);
              }

              if (state is LoadedHomeScreenCompleteTaskState) {
                for (int i = 0;
                    i <
                        Provider.of<TaskListHolderProvider>(providerContext)
                            .taskList
                            .length;
                    i++) {
                  // make the mutable list task complete or incomplete as requested
                  if (Provider.of<TaskListHolderProvider>(providerContext)
                          .taskList[i]
                          .taskId ==
                      state.taskEntity.taskId) {
                    Provider.of<TaskListHolderProvider>(providerContext)
                            .taskList[i]
                            .isCompleted =
                        !Provider.of<TaskListHolderProvider>(providerContext)
                            .taskList[i]
                            .isCompleted;
                    break;
                  }
                }

                setState(() {
                  Provider.of<TaskListHolderProvider>(providerContext)
                      .taskList
                      .sort((a, b) => compareListItems(a, b));
                });
              }
              if (state is ErrorHomeScreenCompleteTaskState) {
                Scaffold.of(context).removeCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text(state.message ??
                      "Sorry, could not update the task. Please check your internet connection"),
                ));
              }
            },
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: CommonDimens.MARGIN_20,
                  ),
                  child: Text(
                    beautifyDate(Provider.of<PageHolderProviderModel>(context)
                            .runningDate ??
                        ""),
                    style: CommonTextStyles.dateTextStyle(),
                  ),
                ),
                if (Provider.of<TaskListHolderProvider>(providerContext)
                        .taskList !=
                    null)
                  Expanded(
                    child: SingleChildScrollView(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 2,
                        child: Column(
                          children: <Widget>[
                            CreateTaskShortcutWidget(
                              totalTaskNumber:
                                  Provider.of<TaskListHolderProvider>(
                                          providerContext)
                                      .taskList
                                      .length,
                            ),
                            Expanded(
                              child: AnimatedList(
                                padding: const EdgeInsets.symmetric(
                                  vertical: CommonDimens.MARGIN_20,
                                ),
                                key: animatedListStateKey,
                                physics: NeverScrollableScrollPhysics(),
                                initialItemCount:
                                    Provider.of<TaskListHolderProvider>(
                                            providerContext)
                                        .taskList
                                        .length,
                                itemBuilder: (_, i, animation) {
                                  return SizeTransition(
                                    sizeFactor: animation,
                                    child: ChangeNotifierProvider<
                                        TaskHolderProviderModel>(
                                      key: ValueKey(
                                          Provider.of<TaskListHolderProvider>(
                                                  providerContext)
                                              .taskList[i]
                                              .taskId),
                                      create: (context) =>
                                          TaskHolderProviderModel(
                                              taskEntity: Provider.of<
                                                          TaskListHolderProvider>(
                                                      providerContext)
                                                  .taskList[i]),
                                      child: TaskWidget(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void getAllTasks() {
    BlocProvider.of<HomeScreenTaskBloc>(context).dispatch(ReadAllTaskEvent(
      runningDate: Provider.of<PageHolderProviderModel>(context).runningDate,
    ));
  }

  @override
  bool get wantKeepAlive => true;
}

class TaskHolderProviderModel extends ChangeNotifier {
  final TaskEntity taskEntity;

  TaskHolderProviderModel({
    @required this.taskEntity,
  });
}

class TaskListHolderProvider extends ChangeNotifier {
  List<TaskEntity> taskList;
  final GlobalKey<AnimatedListState> listState;

  TaskListHolderProvider({
    @required this.listState,
  });

  void assignTaskList(List<TaskEntity> taskEntityList) {
    this.taskList = taskEntityList;
    taskList.sort((a, b) => compareListItems(a, b));
    notifyListeners();
  }

  void insertTaskToList(TaskEntity taskEntity) {
    this.taskList.insert(0, taskEntity);
    listState.currentState.insertItem(0);
    notifyListeners();
  }

  void addTaskToList(TaskEntity taskEntity) {
    this.taskList.add(taskEntity);
    listState.currentState.insertItem(0);
    notifyListeners();
  }
}

int compareListItems(TaskEntity a, TaskEntity b) {
  int positiveOrNegativeIndex = 0;
  if (a.isCompleted && !b.isCompleted) {
    positiveOrNegativeIndex = 1;
  }

  if (!a.isCompleted && b.isCompleted) {
    positiveOrNegativeIndex = -1;
  }

  if (a.isCompleted && b.isCompleted) {
    if (a.urgency > b.urgency) {
      positiveOrNegativeIndex = 1;
    } else if (a.urgency < b.urgency) {
      positiveOrNegativeIndex = -1;
    } else {
      positiveOrNegativeIndex = 0;
    }
  }
  return positiveOrNegativeIndex;
}
