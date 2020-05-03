import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/use_case.dart';
import 'package:project_runway/features/tasks/domain/use_cases/complete_task_use_case.dart';
import 'package:project_runway/features/tasks/domain/use_cases/get_all_tasks_for_date_use_case.dart';
import '../bloc.dart';

class HomeScreenTaskBloc extends Bloc<TaskBlocEvent, TaskBlocState> {
  final GetCompleteTaskUseCase completeTaskUseCase;
  final GetAllTasksForDateUseCase allTasksForDateUseCase;

  HomeScreenTaskBloc({
    @required this.completeTaskUseCase,
    @required this.allTasksForDateUseCase,
  });

  @override
  TaskBlocState get initialState => InitialTaskBlocState();

  @override
  Stream<TaskBlocState> mapEventToState(
    TaskBlocEvent event,
  ) async* {
    if (event is CompleteTaskEvent) {
      yield LoadingHomeScreenState();
      final response =
          await completeTaskUseCase(TaskParam(taskEntity: event.task));
      yield response.fold(
        (failure) => ErrorHomeScreenCompleteTaskState(
            message: mapFailureToMessage(failure)),
        (task) => LoadedHomeScreenCompleteTaskState(taskEntity: task),
      );
    } else if (event is ReadAllTaskEvent) {
      yield LoadingHomeScreenState();
      final response = await allTasksForDateUseCase(
          DateParam(runningDate: event.runningDate));
      yield response.fold(
        (failure) => ErrorHomeScreenAllTasksState(
            message: mapFailureToMessage(failure)),
        (taskList) => LoadedHomeScreenAllTasksState(taskListEntity: taskList),
      );
    }
  }
}
