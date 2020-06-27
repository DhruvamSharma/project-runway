import 'package:flutter/material.dart';
import 'package:project_runway/core/common_ui/under_maintainance_widget.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/core/remote_config/remote_config_service.dart';
import 'package:project_runway/features/tasks/presentation/widgets/create_task/create_task.dart';

class CreateTaskPage extends StatelessWidget {
  static const String routeName = "${APP_NAME}_v1_task_create-screen";
  final RemoteConfigService _remoteConfigService = sl<RemoteConfigService>();
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
    return buildRoute();
  }

  Widget buildRoute() {
    if (_remoteConfigService.createTaskEnabled) {
      return CreateTaskWidget(
        runningDate: runningDate,
        initialTaskTitle: initialTaskTitle,
        totalTasksCreated: totalTasksCreated,
      );
    } else {
      return Scaffold(
        body: UnderMaintenanceWidget(),
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
  bool isCreating = false;

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

  assignIsCreating(bool isCreating) {
    this.isCreating = isCreating;
    notifyListeners();
  }

  assignTaskTag(String tag) {
    this.tag = tag;
    notifyListeners();
  }
}
