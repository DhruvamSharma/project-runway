import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/use_case.dart';
import 'package:project_runway/features/login/domain/entities/user_entity.dart';
import 'package:project_runway/features/login/domain/repositories/user_repository.dart';

class ReadUserUseCase extends UseCase<UserEntity, ReadUserUseCaseParams> {
  final UserRepository repository;

  ReadUserUseCase({
    @required this.repository,
  });

  @override
  Future<Either<Failure, UserEntity>> call(ReadUserUseCaseParams params) {
    final response = repository.readUser(params.googleId);
    return response;
  }
}

class ReadUserUseCaseParams extends Equatable {
  final String googleId;

  ReadUserUseCaseParams({
    @required this.googleId,
  });

  @override
  List<Object> get props => [
        googleId,
      ];
}
