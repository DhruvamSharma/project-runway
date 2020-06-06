import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/core/errors/exceptions.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/features/vision_boards/data/data_sources/remote_vision_board_data_source.dart';
import 'package:project_runway/features/vision_boards/data/models/vision_board_model.dart';
import 'package:project_runway/features/vision_boards/data/models/vision_model.dart';
import 'package:project_runway/features/vision_boards/domain/repositories/vision_board_repository.dart';

class VisionBoardRepositoryImpl implements VisionBoardRepository {
  final RemoteVisionBoardDataSource remoteDataSource;

  VisionBoardRepositoryImpl({
    @required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, VisionModel>> createVision(VisionModel vision) async {
    try {
      final response = await remoteDataSource.createVision(vision);
      return Right(response);
    } on ServerException catch (ex) {
      return Left(ServerFailure(message: ex.message));
    }
  }

  @override
  Future<Either<Failure, VisionBoardModel>> createVisionBoard(
      VisionBoardModel visionBoard) async {
    try {
      final response = await remoteDataSource.createVisionBoard(visionBoard);
      return Right(response);
    } on ServerException catch (ex) {
      return Left(ServerFailure(message: ex.message));
    }
  }

  @override
  Future<Either<Failure, VisionModel>> deleteVision(VisionModel vision) async {
    try {
      final response = await remoteDataSource.deleteVision(vision);
      return Right(response);
    } on ServerException catch (ex) {
      return Left(ServerFailure(message: ex.message));
    }
  }

  @override
  Future<Either<Failure, VisionBoardModel>> deleteVisionBoard(
      VisionBoardModel visionBoard) async {
    try {
      final response = await remoteDataSource.deleteVisionBoard(visionBoard);
      return Right(response);
    } on ServerException catch (ex) {
      return Left(ServerFailure(message: ex.message));
    }
  }

  @override
  Future<Either<Failure, List<VisionBoardModel>>> readAllVisionBoards(
      String userId) async {
    try {
      final response = await remoteDataSource.readAllVisionBoards(userId);
      return Right(response);
    } on ServerException catch (ex) {
      return Left(ServerFailure(message: ex.message));
    }
  }

  @override
  Future<Either<Failure, List<VisionModel>>> readVisionBoard(
      String visionBoardId) async {
    try {
      final response = await remoteDataSource.readVisionBoard(visionBoardId);
      return Right(response);
    } on ServerException catch (ex) {
      return Left(ServerFailure(message: ex.message));
    }
  }

  @override
  Future<Either<Failure, VisionModel>> updateVision(VisionModel vision) async {
    try {
      final response = await remoteDataSource.updateVision(vision);
      return Right(response);
    } on ServerException catch (ex) {
      return Left(ServerFailure(message: ex.message));
    }
  }

  @override
  Future<Either<Failure, VisionBoardModel>> updateVisionBoard(
      VisionBoardModel visionBoard) async {
    try {
      final response = await remoteDataSource.updateVisionBoard(visionBoard);
      return Right(response);
    } on ServerException catch (ex) {
      return Left(ServerFailure(message: ex.message));
    }
  }
}
