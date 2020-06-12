import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/use_case.dart';
import 'package:project_runway/features/vision_boards/data/models/vision_model.dart';
import 'package:project_runway/features/vision_boards/domain/repositories/vision_board_repository.dart';

class ReadVisionBoardUseCase extends UseCase<List<VisionModel>, VisionIdParam> {
  final VisionBoardRepository repository;

  ReadVisionBoardUseCase({
    @required this.repository,
  });

  @override
  Future<Either<Failure, List<VisionModel>>> call(VisionIdParam params) {
    final response = repository.readVisionBoard(params.visionBoardId);
    return response;
  }
}

class VisionIdParam extends Equatable {
  final String visionBoardId;

  VisionIdParam({
    @required this.visionBoardId,
  });

  @override
  List<Object> get props => [
        visionBoardId,
      ];
}
