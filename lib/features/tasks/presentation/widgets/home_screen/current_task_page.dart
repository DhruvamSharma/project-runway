import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:project_runway/core/analytics_utils.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/common_ui/custom_snackbar.dart';
import 'package:project_runway/core/date_time_parser.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/core/keys.dart';
import 'package:project_runway/core/theme/theme.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:project_runway/features/tasks/data/models/task_model.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';
import 'package:project_runway/features/tasks/presentation/manager/bloc.dart';
import 'package:project_runway/features/tasks/presentation/pages/create_task/create_task_page.dart';
import 'package:project_runway/features/tasks/presentation/pages/create_task/create_task_screen_arguments.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/create_task_shortcut_widget.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/task_page.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/task_widget.dart';
import 'package:provider/provider.dart';

class CurrentTaskPage extends StatefulWidget {
  @override
  _CurrentTaskPageState createState() => _CurrentTaskPageState();
}

class _CurrentTaskPageState extends State<CurrentTaskPage>
    with
        AutomaticKeepAliveClientMixin<CurrentTaskPage>,
        SingleTickerProviderStateMixin {
  String initialTaskText;
  // required for handling incoming text from other apps
  static const platform = const MethodChannel('app.channel.shared.data');
  GlobalKey<AnimatedListState> animatedListStateKey = GlobalKey();
  bool isLoadingTasks = true;
  AnimationController _animationController;
  String sharedText;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 1000,
        ));
    _animationController.forward();
    _animationController.repeat();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getAllTasks();
    super.didChangeDependencies();
  }

  getSharedText(
    BuildContext context,
  ) async {
    var sharedData = await platform.invokeMethod("getSharedText");
    String emptyText = "empty_8ebddc3a-a5d8-11ea-bb37-0242ac130002";
    print("fetched data from native layer");
    if (sharedData != emptyText) {
      print(sharedData);
      if (sharedData != null && sharedData.toString().isNotEmpty) {
        final timeNow = DateTime.now();
        final data = await Navigator.pushNamed(
            context, CreateTaskPage.routeName,
            arguments: CreateTaskScreenArguments(
                runningDate: DateTime(timeNow.year, timeNow.month, timeNow.day),
                totalTasksCreated:
                    6, // 6 because incoming text should always be saved
                initialTaskTitle: sharedData as String));

        if (data != null && data is TaskEntity) {
          Provider.of<TaskListHolderProvider>(context, listen: false)
              .insertTaskToList(data);
        }
        sharedText = emptyText;
      } else {
        // Do nothing
      }
    } else {
      // Do nothing
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final appState = Provider.of<ThemeModel>(context, listen: false);
    final pageState =
        Provider.of<PageHolderProviderModel>(context, listen: false);
    return ChangeNotifierProvider<TaskListHolderProvider>(
      create: (_) => TaskListHolderProvider(listState: animatedListStateKey),
      child: Builder(
        builder: (providerContext) {
          return BlocListener<HomeScreenTaskBloc, TaskBlocState>(
            listener: (_, state) async {
              listenForBlocEvents(providerContext, state, appState);
            },
            child: isLoadingTasks
                ? buildLoadingAnimation(appState)
                : GlowingOverscrollIndicator(
                    axisDirection: AxisDirection.down,
                    color: CommonColors.chartColor,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: CommonDimens.MARGIN_20,
                            ),
                            child: Text(
                              beautifyDate(pageState.runningDate ?? ""),
                              style: CommonTextStyles.dateTextStyle(context),
                            ),
                          ),
                          if (Provider.of<TaskListHolderProvider>(
                                      providerContext,
                                      listen: false)
                                  .taskList !=
                              null)
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CreateTaskShortcutWidget(
                                  totalTaskNumber:
                                      Provider.of<TaskListHolderProvider>(
                                              providerContext,
                                              listen: false)
                                          .taskList
                                          .length,
                                ),
                                AnimatedList(
                                  key: animatedListStateKey,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(
                                    top: CommonDimens.MARGIN_20,
                                  ),
                                  physics: NeverScrollableScrollPhysics(),
                                  initialItemCount:
                                      Provider.of<TaskListHolderProvider>(
                                              providerContext,
                                              listen: false)
                                          .taskList
                                          .length,
                                  itemBuilder: (_, i, animation) {
                                    if (Provider.of<TaskListHolderProvider>(
                                            providerContext,
                                            listen: false)
                                        .taskList
                                        .isNotEmpty)
                                      return buildTaskItem(
                                          providerContext, animation, i);
                                    else
                                      return Container();
                                  },
                                ),
                              ],
                            ),
                          buildStarterPageViewHelper(
                              providerContext,
                              appState,
                              pageState,
                              Provider.of<TaskListHolderProvider>(
                                  providerContext,
                                  listen: false)),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  buildTaskItem(BuildContext providerContext, Animation animation, int i) {
    try {
      return SizeTransition(
        sizeFactor: animation,
        child: ChangeNotifierProvider<TaskHolderProviderModel>(
          key: ValueKey(Provider.of<TaskListHolderProvider>(providerContext,
                      listen: false)
                  .taskList
                  .isEmpty
              ? UniqueKey()
              : Provider.of<TaskListHolderProvider>(providerContext,
                      listen: false)
                  .taskList[i]
                  .taskId),
          create: (context) => TaskHolderProviderModel(
              taskEntity: Provider.of<TaskListHolderProvider>(providerContext,
                      listen: false)
                  .taskList[i]),
          child: TaskWidget(),
        ),
      );
    } catch (ex) {
      print("list error");
      // fetch the tasks again, if any error occurs
      AnalyticsUtils.sendAnalyticEvent(
          "VIEW_LIST_ERROR", {"error": ex.toString()}, "Current_Task_List");
      getAllTasks();
      return Container();
    }
  }

  Future<Null> getAllTasks() {
    BlocProvider.of<HomeScreenTaskBloc>(context).add(ReadAllTaskEvent(
      runningDate: Provider.of<PageHolderProviderModel>(context, listen: false)
          .runningDate,
    ));
    return null;
  }

  @override
  bool get wantKeepAlive => true;

  Widget buildLoadingAnimation(ThemeModel appState) {
    return RotatedBox(
        quarterTurns: 3,
        child: Lottie.asset(
            appState.currentTheme == lightTheme
                ? "assets/lf30_editor_CH6Lht.json"
                : "assets/lf30_editor_tLnnBp.json",
            animate: true,
            width: MediaQuery.of(context).size.width,
            controller: _animationController,
            repeat: false));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget buildStarterPageViewHelper(BuildContext context, ThemeModel appState,
      PageHolderProviderModel pageState, TaskListHolderProvider taskListState) {
    if (pageState.pageNumber == 1 &&
        taskListState.taskList != null &&
        taskListState.taskList.isEmpty &&
        !isLoadingTasks &&
        !sharedPreferences.containsKey(HOME_ROUTE_KEY)) {
      return Padding(
        padding: const EdgeInsets.only(
          top: CommonDimens.MARGIN_80,
        ),
        child: Lottie.asset(
          appState.currentTheme == lightTheme
              ? "assets/hand_animation_light.json"
              : "assets/hand_animation_dark.json",
          repeat: false,
          height: 100,
        ),
      );
    } else {
      return Container();
    }
  }

  void listenForBlocEvents(
    BuildContext providerContext,
    TaskBlocState state,
    ThemeModel appState,
  ) {
    if (state is LoadedHomeScreenAllTasksState) {
      setState(() {
        isLoadingTasks = false;
        _animationController.stop();
      });
      Provider.of<TaskListHolderProvider>(providerContext, listen: false)
          .assignTaskList(state.taskListEntity.taskList);

      // check for shared text
      getSharedText(providerContext);
    }

    if (state is ErrorHomeScreenAllTasksState) {
      // show error
      Scaffold.of(context).showSnackBar(
        CustomSnackbar.withAnimation(
          context,
          state.message,
        ),
      );
      // stop loading
      setState(() {
        isLoadingTasks = false;
        _animationController.stop();
      });
      // give an empty list
      Provider.of<TaskListHolderProvider>(providerContext, listen: false)
          .assignTaskList([]);
    }

    if (state is LoadedHomeScreenCompleteTaskState) {
      // update the task
      Provider.of<TaskListHolderProvider>(providerContext, listen: false)
          .updateItem(state.taskEntity);
      // sort the task
      setState(() {
        Provider.of<TaskListHolderProvider>(providerContext, listen: false)
            .taskList
            .sort((a, b) => compareListItems(a, b));
      });
    }
    if (state is ErrorHomeScreenCompleteTaskState) {
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(
        CustomSnackbar.withAnimation(
          context,
          state.message,
        ),
      );
    }

    if (state is ErrorCreateScreenCreateTaskState) {
//                print(state.message);
    }
  }
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

  void updateItem(TaskEntity task) {
    // when sometimes the object has changed due to some
    //modification as object now is not immutable
    for (int i = 0; i < this.taskList.length; i++) {
      if (this.taskList[i].taskId == task.taskId) {
        this.taskList[i].isCompleted = task.isCompleted;
        break;
      }
    }
    notifyListeners();
  }

  void insertTaskToList(TaskEntity taskEntity) {
    TaskModel taskModel = convertTaskEntityToModel(taskEntity);
    try {
      this.taskList.insert(0, taskModel);
      this.listState.currentState.insertItem(0);
    } catch (Ex) {
      // Do nothing
      AnalyticsUtils.sendAnalyticEvent(
          "INSERT_LIST_ERROR", {}, "Current_Task_List");
    }
    notifyListeners();
  }

  void deleteTaskItemFromList(TaskEntity taskEntity) {
    int indexToRemove = this.taskList.indexOf(taskEntity);
    if (indexToRemove != -1) {
      listState.currentState.removeItem(indexToRemove, (context, animation) {
        return _buildItem(context, 0, animation, taskEntity);
      });
      this.taskList.removeAt(indexToRemove);
    } else {
      // when sometimes the object has changed due to some
      //modification as object now is not immutable
      for (int i = 0; i < this.taskList.length; i++) {
        if (this.taskList[i].taskId == taskEntity.taskId) {
          indexToRemove = i;
          break;
        }
      }
      listState.currentState.removeItem(indexToRemove, (context, animation) {
        return _buildItem(context, 0, animation, taskEntity);
      });
      this.taskList.removeAt(indexToRemove);
    }
    notifyListeners();
  }

  _buildItem(BuildContext context, int index, Animation<double> animation,
      TaskEntity task) {
    return SizeTransition(
      key: ValueKey<int>(index),
      axis: Axis.vertical,
      sizeFactor: animation,
      child: SizedBox(
        child: ListTile(
          title: Text(
            task.taskTitle,
            style: selectTaskStyle(task, context, task.isCompleted),
          ),
        ),
      ),
    );
  }

  TaskModel convertTaskEntityToModel(TaskEntity taskEntity) {
    return TaskModel(
      userId: taskEntity.userId,
      taskId: taskEntity.taskId,
      taskTitle: taskEntity.taskTitle,
      description: taskEntity.description,
      urgency: taskEntity.urgency,
      tag: taskEntity.tag,
      notificationTime: taskEntity.notificationTime,
      createdAt: taskEntity.createdAt,
      runningDate: taskEntity.runningDate,
      lastUpdatedAt: taskEntity.lastUpdatedAt,
      isSynced: taskEntity.isSynced,
      isDeleted: taskEntity.isDeleted,
      isMovable: taskEntity.isMovable,
      isCompleted: taskEntity.isCompleted,
    );
  }
}

int compareListItems(TaskEntity a, TaskEntity b) {
//  if a < b, result should be < 0,
//  if a = b, result should be = 0, and
//  if a > b, result should be > 0.
  int positiveOrNegativeIndex = 0;
  if (a.isCompleted && !b.isCompleted) {
    positiveOrNegativeIndex = 1;
  }

  if (!a.isCompleted && b.isCompleted) {
    positiveOrNegativeIndex = -1;
  }

  if (!a.isCompleted && !b.isCompleted) {
    if (a.urgency > b.urgency) {
      positiveOrNegativeIndex = 1;
    } else if (a.urgency < b.urgency) {
      positiveOrNegativeIndex = -1;
    } else {
      if (a.createdAt.difference(b.createdAt).inMinutes > 0) {
        positiveOrNegativeIndex = -1;
      } else {
        positiveOrNegativeIndex = 1;
      }
    }
  }

  if (a.isCompleted && b.isCompleted) {
    positiveOrNegativeIndex = -1;
  }
  return positiveOrNegativeIndex;
}
