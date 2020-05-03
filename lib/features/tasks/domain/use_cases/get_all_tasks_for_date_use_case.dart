import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/use_case.dart';
import 'package:project_runway/features/tasks/domain/entities/task_list_entity.dart';
import 'package:project_runway/features/tasks/domain/repositories/task_repository.dart';

class GetAllTasksForDateUseCase extends UseCase<TaskListEntity, DateParam> {
  TaskRepository repository;

  GetAllTasksForDateUseCase({
    @required this.repository,
  });

  @override
  Future<Either<Failure, TaskListEntity>> call(DateParam params) {
    final response = repository.getAllTasksForTheDate(params.runningDate);
    return response;
  }
}
