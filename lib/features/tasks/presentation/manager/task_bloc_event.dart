import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class TaskBlocEvent extends Equatable {
  final List customProps = const <dynamic>[];
  const TaskBlocEvent();

  @override
  // TODO: implement props
  List<Object> get props => customProps;
}

class CompleteTaskEvent extends TaskBlocEvent {
  final String taskId;

  CompleteTaskEvent({
    @required this.taskId,
  });

  @override
  List<Object> get props => [
        taskId,
      ];
}

class ReadAllTaskEvent extends TaskBlocEvent {
  final DateTime runningDate;

  ReadAllTaskEvent({
    @required this.runningDate,
  });

  @override
  List<Object> get props => [
        runningDate,
      ];
}
