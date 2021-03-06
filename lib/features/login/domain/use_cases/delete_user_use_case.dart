import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/use_case.dart';
import 'package:project_runway/features/login/domain/entities/user_entity.dart';
import 'package:project_runway/features/login/domain/repositories/user_repository.dart';

class DeleteUserUseCase extends UseCase<UserEntity, UserUseCaseParams> {
  final UserRepository repository;

  DeleteUserUseCase({
    @required this.repository,
  });

  @override
  Future<Either<Failure, UserEntity>> call(UserUseCaseParams params) {
    final response = repository.deleteUser(params.user);
    return response;
  }
}

class UserUseCaseParams extends Equatable {
  final UserEntity user;

  UserUseCaseParams({
    @required this.user,
  });

  @override
  List<Object> get props => [
    user,
  ];
}
