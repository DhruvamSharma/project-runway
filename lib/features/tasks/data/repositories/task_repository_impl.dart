import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:project_runway/core/errors/exceptions.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/network/network_info.dart';
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
  Future<Either<Failure, TaskEntity>> completeTask(String taskId) {
    // TODO: implement completeTask
    return null;
  }

  @override
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task) async {
    if (await networkInfo.isConnected) {
      try {
        await localDataSource.createTask(task);
        final syncedTask = markTaskAsSynced(task);
        try {
          remoteDataSource.createTask(syncedTask);
          localDataSource.updateTask(syncedTask);
          return Right(syncedTask);
        } on ServerException catch (ex) {
          return Right(task);
        }
      } on CacheException catch (ex) {
        return Left(CacheFailure(message: ex.message));
      }
    } else {
      try {
        final response = await localDataSource.createTask(task);
        final syncedTask = markTaskAsSynced(task);
        try {
          remoteDataSource.createTask(syncedTask);
          localDataSource.updateTask(syncedTask);
          return Right(syncedTask);
        } on ServerException catch (ex) {
          return Right(task);
        }
      } on CacheException catch (ex) {
        return Left(CacheFailure(message: ex.message));
      }
    }
    return null;
  }

  @override
  Future<Either<Failure, TaskEntity>> deleteTask(TaskEntity task) {
    // TODO: implement deleteTask
    return null;
  }

  @override
  Future<Either<Failure, TaskListEntity>> getAllTasksForTheDate(
      DateTime runningDate) async {
    if (await networkInfo.isConnected) {
      try {
        final TaskListModel response =
            await localDataSource.getAllTasksForTheDate(runningDate);
        return Right(response);
      } on CacheException catch (ex) {
        try {
          final response =
              await remoteDataSource.getAllTasksForTheDate(runningDate);
          return Right(response);
        } on ServerException catch (ex) {
          return Left(ServerFailure(message: ex.message));
        }
      }
    } else {
      try {
        final TaskListModel response =
            await localDataSource.getAllTasksForTheDate(runningDate);
        return Right(response);
      } on CacheException catch (ex) {
        return Left(ServerFailure(message: ex.message));
      }
    }
    return null;
  }

  @override
  Future<Either<Failure, TaskEntity>> readTask(String taskId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await localDataSource.readTask(taskId);
        return Right(response);
      } on CacheException {
        try {
          final response = await remoteDataSource.readTask(taskId);
          return Right(response);
        } on ServerException catch (ex) {
          return Left(ServerFailure(message: ex.message));
        }
      }
    } else {
      try {
        final response = await localDataSource.readTask(taskId);
        return Right(response);
      } on CacheException catch (ex) {
        return Left(CacheFailure(message: ex.message));
      }
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTask(TaskEntity task) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await localDataSource.updateTask(task);
        return Right(response);
      } on CacheException catch (ex) {
        try {
          final syncedTask = markTaskAsSynced(task);
          final response = await remoteDataSource.updateTask(syncedTask);
          return Right(response);
        } on ServerException catch (ex) {
          return Left(ServerFailure(message: ex.message));
        }
      }
    } else {
      try {
        final response = await localDataSource.updateTask(task);
        return Right(response);
      } on CacheException catch (ex) {
        return Left(CacheFailure(message: ex.message));
      } finally {
        // This call is here because, firebase will
        // manage if there is no internet connection
        try {
          final syncedTask = markTaskAsSynced(task);
          remoteDataSource.updateTask(syncedTask);
        } on ServerException {
          // Do nothing
        }
      }
    }
  }

  TaskModel markTaskAsSynced(TaskModel task) {
    Map<String, dynamic> taskMap = task.toJson();
    taskMap.update("isSynced", (value) => true, ifAbsent: () => false);
    final syncedTask = TaskModel.fromJson(taskMap);
    return syncedTask;
  }
}
