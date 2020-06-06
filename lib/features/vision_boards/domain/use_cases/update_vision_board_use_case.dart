import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/use_case.dart';
import 'package:project_runway/features/vision_boards/data/models/vision_board_model.dart';
import 'package:project_runway/features/vision_boards/domain/repositories/vision_board_repository.dart';
import 'package:project_runway/features/vision_boards/domain/use_cases/create_vision_board_use_case.dart';

class UpdateVisionBoardUseCase
    extends UseCase<VisionBoardModel, VisionBoardParam> {
  final VisionBoardRepository repository;

  UpdateVisionBoardUseCase({
    @required this.repository,
  });

  @override
  Future<Either<Failure, VisionBoardModel>> call(VisionBoardParam params) {
    final response = repository.updateVisionBoard(params.visionBoard);
    return response;
  }
}
