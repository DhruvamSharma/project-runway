import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/core/errors/exceptions.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/network/network_info.dart';
import 'package:project_runway/core/user_utility.dart';
import 'package:project_runway/features/login/data/data_sources/user_local_data_source.dart';
import 'package:project_runway/features/login/data/data_sources/user_remote_data_source.dart';
import 'package:project_runway/features/login/data/models/user_model.dart';
import 'package:project_runway/features/login/domain/entities/user_entity.dart';
import 'package:project_runway/features/login/domain/repositories/user_repository.dart';
import 'package:uuid/uuid.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final Uuid uuid;
  UserRepositoryImpl({
    @required this.remoteDataSource,
    @required this.networkInfo,
    @required this.uuid,
    @required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> createUser(UserEntity user) async {
    var userModel;
    try {
      if (user.userId == null) {
        final userId = uuid.v1();
        userModel = addUserId(user, userId);
      } else {
        userModel = convertEntityToModel(user);
      }
      final response = await remoteDataSource.createUser(userModel);
      return Right(response);
    } on ServerException catch (ex) {
      return Left(ServerFailure(message: ex.message));
    } finally {
      try {
        localDataSource.updateUser(userModel);
      } on CacheException {
        // Do nothing
      }
    }
  }

  @override
  Future<Either<Failure, UserEntity>> deleteUser(UserEntity user) async {
    UserModel userModel;
    try {
      userModel = deleteUserField(user, true);
      final response = await remoteDataSource.deleteUser(userModel);
      return Right(response);
    } on ServerException catch (ex) {
      return Left(ServerFailure(message: ex.message));
    } finally {
      try {
        localDataSource.updateUser(userModel);
      } on CacheException {
        // Do nothing
      }
    }
  }

  @override
  Future<Either<Failure, UserEntity>> readUser(String googleId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.readUser(googleId);
        localDataSource.updateUser(response);
        return Right(response);
      } on ServerException catch (ex) {
        return Left(ServerFailure(message: ex.message));
      }
    } else {
      try {
        final response = await localDataSource.readUser();
        return Right(response);
      } on CacheException catch (ex) {
        return Left(CacheFailure(message: ex.message));
      }
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user) async {
    try {
      final response =
          await remoteDataSource.updateUser(convertEntityToModel(user));
      return Right(response);
    } on ServerException catch (ex) {
      return Left(ServerFailure(message: ex.message));
    } finally {
      try {
        localDataSource.updateUser(user);
      } on CacheException catch (ex) {
        return Left(CacheFailure(message: ex.message));
      }
    }
  }

  UserModel addUserId(UserEntity userEntity, String userId) {
    print("adding user id");
    final userModel = convertEntityToModel(userEntity);
    final userMap = userModel.toJson();
    userMap.update(
      "userId",
      (value) => userId,
    );
    return UserModel.fromJson(userMap);
  }

  UserModel deleteUserField(UserModel userModel, bool isDeleted) {
    final userMap = userModel.toJson();
    userMap.update(
      "isDeleted",
      (value) => isDeleted,
    );
    return UserModel.fromJson(userMap);
  }
}
