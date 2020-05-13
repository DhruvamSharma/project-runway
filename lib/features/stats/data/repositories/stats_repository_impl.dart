import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/errors/exceptions.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/network/network_info.dart';
import 'package:project_runway/features/stats/data/data_sources/stats_remote_data_source.dart';
import 'package:project_runway/features/stats/data/models/managed_stats_model.dart';
import 'package:project_runway/features/stats/domain/repositories/stats_repository.dart';

class StatsRepositoryImpl implements StatsRepository {
  final NetworkInfo networkInfo;
  final StatsRemoteDataSource remoteDataSource;

  StatsRepositoryImpl({
    @required this.networkInfo,
    @required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, bool>> addScore(int score) async {
    try {
      final response = await remoteDataSource.addScore(score);
      return Right(response);
    } on ServerException catch (ex) {
      return Left(ServerFailure(message: ex.message));
    }
  }

  @override
  Future<Either<Failure, ManagedStatsTable>> getStatsTable() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.fetchStatsTable();
        return Right(response);
      } on ServerException catch (ex) {
        return Left(ServerFailure(message: ex.message));
      }
    } else {
      return Left(ServerFailure(message: NO_INTERNET));
    }
  }
}
