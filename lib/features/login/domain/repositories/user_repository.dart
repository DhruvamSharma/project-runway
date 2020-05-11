import 'package:dartz/dartz.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/features/login/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> readUser(String googleId);
  Future<Either<Failure, UserEntity>> createUser(UserEntity user);
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user);
  Future<Either<Failure, UserEntity>> deleteUser(UserEntity user);
}