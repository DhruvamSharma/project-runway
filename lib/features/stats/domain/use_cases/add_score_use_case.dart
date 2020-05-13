import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/use_case.dart';
import 'package:project_runway/features/stats/domain/repositories/stats_repository.dart';

class AddScoreUseCase extends UseCase<bool, AddScoreUseCaseParam> {
  final StatsRepository repository;

  AddScoreUseCase({
    @required this.repository,
  });
  @override
  Future<Either<Failure, bool>> call(AddScoreUseCaseParam params) {
    final response = repository.addScore(params.score);
    return response;
  }
}

class AddScoreUseCaseParam extends Equatable {
  @override
  List<Object> get props => [score];

  final int score;

  AddScoreUseCaseParam({
    @required this.score,
  });
}
