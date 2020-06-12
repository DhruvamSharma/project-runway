import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/use_case.dart';
import 'package:project_runway/features/vision_boards/data/models/vision_board_model.dart';
import 'package:project_runway/features/vision_boards/domain/repositories/vision_board_repository.dart';

class CreateVisionBoardUseCase
    extends UseCase<VisionBoardModel, VisionBoardParam> {
  final VisionBoardRepository repository;

  CreateVisionBoardUseCase({
    @required this.repository,
  });

  @override
  Future<Either<Failure, VisionBoardModel>> call(VisionBoardParam params) {
    final response = repository.createVisionBoard(params.visionBoard);
    return response;
  }
}

class VisionBoardParam extends Equatable {
  final VisionBoardModel visionBoard;

  VisionBoardParam({
    @required this.visionBoard,
  });

  @override
  List<Object> get props => [
        visionBoard,
      ];
}
