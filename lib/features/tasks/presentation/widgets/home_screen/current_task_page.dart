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
  TaskListEntity taskList;
  String initialTaskText;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print("in change dependencies");
    final currentDate = DateTime.now();
    getAllTasks();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (taskList != null) print(taskList.taskList.length);
    return BlocListener<HomeScreenTaskBloc, TaskBlocState>(
      listener: (_, state) {
        if (state is LoadedHomeScreenAllTasksState) {
          taskList = state.taskListEntity;
          setState(() {});
        }
        if (state is LoadedCreateScreenCreateTaskState) {
          taskList.taskList.add(state.taskEntity);
          setState(() {});
        }
        if (state is LoadedHomeScreenCompleteTaskState) {
          for (int i = 0; i < taskList.taskList.length; i++) {
            // make the mutable list task complete or incomplete as requested
            if (taskList.taskList[i].taskId == state.taskEntity.taskId) {
              taskList.taskList[i].isCompleted =
                  !taskList.taskList[i].isCompleted;
              break;
            }
          }
          setState(() {});
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
              beautifyDate(
                  Provider.of<PageHolderProviderModel>(context).runningDate ??
                      ""),
              style: CommonTextStyles.dateTextStyle(),
            ),
          ),
          if (taskList != null)
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height*2,
                  child: Column(
                    children: <Widget>[
                      CreateTaskShortcutWidget(),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(
                            top: CommonDimens.MARGIN_20,
                            bottom: CommonDimens.MARGIN_20,
                          ),
                          itemCount: taskList.taskList.length,
                          itemBuilder: (_, i) {
                            return GestureDetector(
                              onTap: () {
                                print("hello, task clicked");
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                  top: CommonDimens.MARGIN_40,
                                  left: CommonDimens.MARGIN_20,
                                  right: CommonDimens.MARGIN_20,
                                ),
                                color: Colors.transparent,
                                child: ChangeNotifierProvider<
                                    TaskHolderProviderModel>(
                                  create: (_) => TaskHolderProviderModel(
                                      taskEntity: taskList.taskList[i]),
                                  child: TaskWidget(),
                                ),
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
