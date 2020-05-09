import 'package:flutter/widgets.dart';

class CreateTaskScreenArguments {
  final DateTime runningDate;
  final String initialTaskTitle;
  final int totalTasksCreated;

  CreateTaskScreenArguments({
    @required this.runningDate,
    this.initialTaskTitle,
    @required this.totalTasksCreated,
  });
}
