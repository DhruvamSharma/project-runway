import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/use_case.dart';
import 'package:project_runway/features/vision_boards/data/models/vision_model.dart';
import 'package:project_runway/features/vision_boards/domain/repositories/vision_board_repository.dart';

class CreateVisionUseCase extends UseCase<VisionModel, VisionParam> {
  final VisionBoardRepository repository;

  CreateVisionUseCase({
    @required this.repository,
  });

  @override
  Future<Either<Failure, VisionModel>> call(VisionParam params) {
    final response = repository.createVision(params.vision);
    return response;
  }
}

class VisionParam extends Equatable {
  final VisionModel vision;

  VisionParam({
    @required this.vision,
  });

  @override
  List<Object> get props => [
        vision,
      ];
}
