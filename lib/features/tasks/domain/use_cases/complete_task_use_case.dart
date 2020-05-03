import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/use_case.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';
import 'package:project_runway/features/tasks/domain/repositories/task_repository.dart';

class GetCompleteTaskUseCase extends UseCase<TaskEntity, StringParam> {
  TaskRepository repository;

  GetCompleteTaskUseCase({
    @required this.repository,
  });

  @override
  Future<Either<Failure, TaskEntity>> call(StringParam params) {
    final response = repository.completeTask(params.taskId);
    return response;
  }
}
