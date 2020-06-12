import 'package:dartz/dartz.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/features/vision_boards/data/models/vision_board_model.dart';
import 'package:project_runway/features/vision_boards/data/models/vision_model.dart';

abstract class VisionBoardRepository {
  Future<Either<Failure, VisionBoardModel>> createVisionBoard(
      VisionBoardModel visionBoard);
  Future<Either<Failure, List<VisionBoardModel>>> readAllVisionBoards(
      String userId);
  Future<Either<Failure, VisionBoardModel>> updateVisionBoard(
      VisionBoardModel visionBoard);
  Future<Either<Failure, VisionBoardModel>> deleteVisionBoard(
      VisionBoardModel visionBoard);

  Future<Either<Failure, List<VisionModel>>> readVisionBoard(
      String visionBoardId);
  Future<Either<Failure, VisionModel>> createVision(VisionModel vision);
  Future<Either<Failure, VisionModel>> updateVision(VisionModel vision);
  Future<Either<Failure, VisionModel>> deleteVision(VisionModel vision);
}
