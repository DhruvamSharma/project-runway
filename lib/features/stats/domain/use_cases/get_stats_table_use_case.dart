import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/use_case.dart';
import 'package:project_runway/features/stats/data/models/managed_stats_model.dart';
import 'package:project_runway/features/stats/domain/repositories/stats_repository.dart';

class GetStatsTableUseCase extends UseCase<ManagedStatsTable, NoParams> {
  final StatsRepository repository;

  GetStatsTableUseCase({
    @required this.repository,
  });

  @override
  Future<Either<Failure, ManagedStatsTable>> call(NoParams params) {
    final response = repository.getStatsTable();
    return response;
  }
}
