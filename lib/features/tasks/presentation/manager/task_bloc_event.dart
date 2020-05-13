import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';

abstract class TaskBlocEvent extends Equatable {
  final List customProps = const <dynamic>[];
  const TaskBlocEvent();

  @override
  List<Object> get props => customProps;
}

class CompleteTaskEvent extends TaskBlocEvent {
  final TaskEntity task;

  CompleteTaskEvent({
    @required this.task,
  });

  @override
  List<Object> get props => [
        task,
      ];
}

class CreateTaskEvent extends TaskBlocEvent {
  final TaskEntity task;

  CreateTaskEvent({
    @required this.task,
  });

  @override
  List<Object> get props => [
        task,
      ];
}

class UpdateTaskEvent extends TaskBlocEvent {
  final TaskEntity task;

  UpdateTaskEvent({
    @required this.task,
  });

  @override
  List<Object> get props => [
        task,
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

class DeleteTaskEvent extends TaskBlocEvent {
  final TaskEntity task;

  DeleteTaskEvent({
    @required this.task,
  });

  @override
  List<Object> get props => [
    task,
  ];
}
