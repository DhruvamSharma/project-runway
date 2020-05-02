import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';

class TaskListEntity extends Equatable {
  final bool isSynced;
  final List<TaskEntity> taskList;
  // Running Date
  final DateTime runningDate;

  TaskListEntity({
    @required this.isSynced,
    @required this.taskList,
    @required this.runningDate,
  });

  @override
  // TODO: implement props
  List<Object> get props => [
        isSynced,
        taskList,
        runningDate,
      ];

  @override
  bool get stringify => true;


}
