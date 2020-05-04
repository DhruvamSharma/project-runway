import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/use_case.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';
import 'package:project_runway/features/tasks/domain/repositories/task_repository.dart';

class GetCreateTaskUseCase extends UseCase<TaskEntity, TaskParam> {
  TaskRepository repository;

  GetCreateTaskUseCase({
    @required this.repository,
  });

  @override
  Future<Either<Failure, TaskEntity>> call(TaskParam params) async {
    final response = await repository.createTask(params.taskEntity);
    return response;
  }
}
