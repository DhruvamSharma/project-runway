import 'package:dartz/dartz.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';
import 'package:project_runway/features/tasks/domain/entities/task_list_entity.dart';

abstract class TaskRepository {
  Future<Either<Failure, TaskListEntity>> getAllTasksForTheDate(
      DateTime runningDate);

  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task);

  Future<Either<Failure, TaskEntity>> deleteTask(TaskEntity task);

  Future<Either<Failure, TaskEntity>> readTask(String taskId);

  Future<Either<Failure, TaskEntity>> completeTask(String taskId);

  Future<Either<Failure, TaskEntity>> updateTask(TaskEntity task);
}
