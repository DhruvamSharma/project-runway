import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/use_case.dart';
import 'package:project_runway/features/stats/data/models/puzzle_model.dart';
import 'package:project_runway/features/stats/domain/repositories/stats_repository.dart';

class SetPuzzleSolutionUseCase
    extends UseCase<UserPuzzleModel, SetPuzzleSolutionUseCaseParam> {
  final StatsRepository repository;

  SetPuzzleSolutionUseCase({
    @required this.repository,
  });
  @override
  Future<Either<Failure, UserPuzzleModel>> call(
      SetPuzzleSolutionUseCaseParam params) {
    final response = repository.setPuzzleSolution(params.puzzleSolution);
    return response;
  }
}

class SetPuzzleSolutionUseCaseParam extends Equatable {
  @override
  List<Object> get props => [puzzleSolution];

  final UserPuzzleModel puzzleSolution;

  SetPuzzleSolutionUseCaseParam({
    @required this.puzzleSolution,
  });
}
