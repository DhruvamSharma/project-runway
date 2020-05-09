import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';

class TaskListEntity extends Equatable {
  bool isSynced;
  List<TaskEntity> taskList;
  // Running Date
  DateTime runningDate;

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
