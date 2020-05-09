import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:project_runway/core/errors/exceptions.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/network/network_info.dart';
import 'package:project_runway/features/tasks/data/common_task_method.dart';
import 'package:project_runway/features/tasks/data/data_sources/task_local_data_source.dart';
import 'package:project_runway/features/tasks/data/data_sources/task_remote_data_source.dart';
import 'package:project_runway/features/tasks/data/models/task_list_model.dart';
import 'package:project_runway/features/tasks/data/models/task_model.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';
import 'package:project_runway/features/tasks/domain/entities/task_list_entity.dart';
import 'package:project_runway/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TaskRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, TaskEntity>> completeTask(TaskEntity task) async {
    try {
      // will be returned a task that is marked
      // completed from the local data source
      final response = await localDataSource.completeTask(task);
      return Right(response);
    } on CacheException catch (ex) {
      return Left(CacheFailure(message: ex.message));
    } finally {
      try {
        final syncedTask = markTaskAsSynced(task);
        final completedTask = markTaskAsCompleted(syncedTask);
        remoteDataSource.updateTask(completedTask);
        localDataSource.updateTask(completedTask);
        return Right(completedTask);
      } on ServerException catch (ex) {
        print(ex.message);
        // Do nothing
        // try or catch block return will execute here
      } on CacheException catch (ex) {
        print(ex.message);
        // Do nothing
        // try or catch block return will execute here
      }
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task) async {
    final taskModel = convertEntityToModel(task);
    print(taskModel.taskId);
    try {
      final response = await localDataSource.createTask(taskModel);
      return Right(response);
    } on CacheException catch (ex) {
      return Left(CacheFailure(message: ex.message));
    } finally {
      final syncedTask = markTaskAsSynced(taskModel);
      try {
        final response = await remoteDataSource.createTask(syncedTask);
        // update because the task is already created
        localDataSource.updateTask(syncedTask);
        return Right(response);
      } on ServerException catch (ex) {
        // Do nothing
        // try or catch block return will execute here
      } on CacheException catch (ex) {
        // Do nothing
        // try or catch block return will execute here
      }
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> deleteTask(TaskEntity task) async {
    try {
      // will be returned a task that is marked
      // deleted from the local data source
      final response = await localDataSource.deleteTask(task);
      return Right(response);
    } on CacheException catch (ex) {
      return Left(CacheFailure(message: ex.message));
    } finally {
      final deletedTask = markTaskAsDeleted(task);
      final syncedTask = markTaskAsSynced(deletedTask);
      try {
        remoteDataSource.deleteTask(syncedTask);
        localDataSource.deleteTask(syncedTask);
        return Right(syncedTask);
      } on ServerException {
        // Do nothing
        // try or catch block return will execute here
      } on CacheException {
        // Do nothing
        // try or catch block return will execute here
      }
    }
  }

  @override
  Future<Either<Failure, TaskListEntity>> getAllTasksForTheDate(
      DateTime runningDate) async {
    try {
      final TaskListModel response =
          await localDataSource.getAllTasksForTheDate(runningDate);
      return Right(response);
    } on CacheException catch (ex) {
      return Left(ServerFailure(message: ex.message));
    } finally {
      try {
        final response =
            await remoteDataSource.getAllTasksForTheDate(runningDate);
        return Right(response);
      } on ServerException {} on CacheException {}
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> readTask(String taskId) async {
    try {
      final response = await remoteDataSource.readTask(taskId);
      return Right(response);
    } on ServerException catch (ex) {
      return Left(ServerFailure(message: ex.message));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTask(TaskEntity task) async {
    try {
      final response = await localDataSource.updateTask(task);
      return Right(response);
    } on CacheException catch (ex) {
      return Left(CacheFailure(message: ex.message));
    } finally {
      try {
        final syncedTask = markTaskAsSynced(task);
        remoteDataSource.updateTask(syncedTask);
        localDataSource.updateTask(syncedTask);
        return Right(syncedTask);
      } on ServerException catch (ex) {
        // Do nothing
        // try or catch block return will execute here
      } on CacheException catch (ex) {
        // Do nothing
        // try or catch block return will execute here
      }
    }
  }

  TaskModel convertEntityToModel(TaskEntity task) {
    final taskModel = TaskModel(
      userId: task.userId,
      taskId: task.taskId,
      taskTitle: task.taskTitle,
      description: task.description,
      urgency: task.urgency,
      tag: task.tag,
      notificationTime: task.notificationTime,
      createdAt: task.createdAt,
      runningDate: task.runningDate,
      lastUpdatedAt: task.lastUpdatedAt,
      isSynced: task.isSynced,
      isDeleted: task.isDeleted,
      isMovable: task.isMovable,
      isCompleted: task.isCompleted,
    );
    return taskModel;
  }
}
