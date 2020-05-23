import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/use_case.dart';
import 'package:project_runway/features/stats/data/models/puzzle_model.dart';
import 'package:project_runway/features/stats/domain/repositories/stats_repository.dart';

class GetPuzzleUseCase extends UseCase<PuzzleModel, GetPuzzleUseCaseParam> {
  final StatsRepository repository;

  GetPuzzleUseCase({
    @required this.repository,
  });
  @override
  Future<Either<Failure, PuzzleModel>> call(GetPuzzleUseCaseParam params) {
    final response = repository.getPuzzle(params.puzzleId);
    return response;
  }
}

class GetPuzzleUseCaseParam extends Equatable {
  @override
  List<Object> get props => [puzzleId];

  final int puzzleId;

  GetPuzzleUseCaseParam({
    @required this.puzzleId,
  });
}
