import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/use_case.dart';
import 'package:project_runway/features/vision_boards/data/models/vision_model.dart';
import 'package:project_runway/features/vision_boards/domain/repositories/vision_board_repository.dart';

import 'create_vision_use_case.dart';

class DeleteVisionUseCase extends UseCase<VisionModel, VisionParam> {
  final VisionBoardRepository repository;

  DeleteVisionUseCase({
    @required this.repository,
  });

  @override
  Future<Either<Failure, VisionModel>> call(VisionParam params) {
    final response = repository.deleteVision(params.vision);
    return response;
  }
}
