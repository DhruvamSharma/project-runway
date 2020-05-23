import 'package:dartz/dartz.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/features/stats/data/models/managed_stats_model.dart';
import 'package:project_runway/features/stats/data/models/puzzle_model.dart';

abstract class StatsRepository {
  Future<Either<Failure, ManagedStatsTable>> getStatsTable();
  Future<Either<Failure, bool>> addScore(int score);
  Future<Either<Failure, PuzzleModel>> getPuzzle(int puzzleId);
  Future<Either<Failure, UserPuzzleModel>> setPuzzleSolution(
      UserPuzzleModel userPuzzleModel);
  Future<Either<Failure, UserPuzzleModel>> getPuzzleSolution(
      UserPuzzleModel userPuzzleModel);
  Future<Either<Failure, List<UserPuzzleModel>>> getPuzzleSolvedList(
      String userId);
}
