import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';

class TaskListEntity extends Equatable {
  final bool isSuccess;
  final List<TaskEntity> taskList;
  // Running Date
  final DateTime dateTime;

  TaskListEntity({
    @required this.isSuccess,
    @required this.taskList,
    @required this.dateTime,
  });

  @override
  // TODO: implement props
  List<Object> get props => [
        isSuccess,
        taskList,
        dateTime,
      ];

  @override
  bool get stringify => true;


}
