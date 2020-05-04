import 'package:flutter/widgets.dart';

class CreateTaskScreenArguments {
  final DateTime runningDate;
  final String initialTaskTitle;

  CreateTaskScreenArguments({
    @required this.runningDate,
    this.initialTaskTitle,
  });
}
