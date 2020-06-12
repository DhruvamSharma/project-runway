import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/use_case.dart';
import 'package:project_runway/features/vision_boards/data/models/vision_board_model.dart';
import 'package:project_runway/features/vision_boards/domain/repositories/vision_board_repository.dart';

class ReadAllVisionBoardUseCase
    extends UseCase<List<VisionBoardModel>, VisionBoardIdParam> {
  final VisionBoardRepository repository;

  ReadAllVisionBoardUseCase({
    @required this.repository,
  });

  @override
  Future<Either<Failure, List<VisionBoardModel>>> call(
      VisionBoardIdParam params) {
    final response = repository.readAllVisionBoards(params.userId);
    return response;
  }
}

class VisionBoardIdParam extends Equatable {
  final String userId;

  VisionBoardIdParam({
    @required this.userId,
  });

  @override
  List<Object> get props => [
        userId,
      ];
}
