import 'package:dartz/dartz.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/features/stats/data/models/managed_stats_model.dart';

abstract class StatsRepository {
  Future<Either<Failure, ManagedStatsTable>> getStatsTable();
  Future<Either<Failure, bool>> addScore(int score);
}