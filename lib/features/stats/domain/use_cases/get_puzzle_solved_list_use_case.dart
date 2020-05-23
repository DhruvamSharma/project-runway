import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/use_case.dart';
import 'package:project_runway/features/stats/data/models/puzzle_model.dart';
import 'package:project_runway/features/stats/domain/repositories/stats_repository.dart';

class GetPuzzleSolvedListUseCase
    extends UseCase<List<UserPuzzleModel>, GetSolvedPuzzleListUseCaseParam> {
  final StatsRepository repository;

  GetPuzzleSolvedListUseCase({
    @required this.repository,
  });
  @override
  Future<Either<Failure, List<UserPuzzleModel>>> call(
      GetSolvedPuzzleListUseCaseParam params) {
    final response = repository.getPuzzleSolvedList(params.userId);
    return response;
  }
}

class GetSolvedPuzzleListUseCaseParam extends Equatable {
  @override
  List<Object> get props => [userId];

  final String userId;

  GetSolvedPuzzleListUseCaseParam({
    @required this.userId,
  });
}
