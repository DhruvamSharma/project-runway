import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';
import 'package:project_runway/features/tasks/domain/entities/task_list_entity.dart';

abstract class TaskBlocState extends Equatable {
  const TaskBlocState();
}

class InitialTaskBlocState extends TaskBlocState {
  @override
  List<Object> get props => [];
}

class LoadingHomeScreenState extends TaskBlocState {
  @override
  List<Object> get props => [];
}

class LoadedHomeScreenAllTasksState extends TaskBlocState {
  final TaskListEntity taskListEntity;

  LoadedHomeScreenAllTasksState({
    @required this.taskListEntity,
  });

  @override
  List<Object> get props => [taskListEntity];
}

class LoadedHomeScreenCompleteTaskState extends TaskBlocState {
  final TaskEntity taskEntity;

  LoadedHomeScreenCompleteTaskState({
    @required this.taskEntity,
  });

  @override
  List<Object> get props => [taskEntity];
}

class LoadedCreateScreenCreateTaskState extends TaskBlocState {
  final TaskEntity taskEntity;

  LoadedCreateScreenCreateTaskState({
    @required this.taskEntity,
  });

  @override
  List<Object> get props => [taskEntity];
}

class ErrorCreateScreenCreateTaskState extends TaskBlocState {
  final String message;

  ErrorCreateScreenCreateTaskState({
    @required this.message,
  });

  @override
  List<Object> get props => [message];
}

class ErrorHomeScreenAllTasksState extends TaskBlocState {
  final String message;

  ErrorHomeScreenAllTasksState({
    @required this.message,
  });

  @override
  List<Object> get props => [message];
}

class ErrorHomeScreenCompleteTaskState extends TaskBlocState {
  final String message;

  ErrorHomeScreenCompleteTaskState({
    @required this.message,
  });

  @override
  List<Object> get props => [message];
}
