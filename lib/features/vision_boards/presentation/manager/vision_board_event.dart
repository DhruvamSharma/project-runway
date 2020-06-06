import 'package:equatable/equatable.dart';
import 'package:project_runway/features/vision_boards/data/models/vision_board_model.dart';
import 'package:project_runway/features/vision_boards/data/models/vision_model.dart';

abstract class VisionBoardEvent extends Equatable {
  const VisionBoardEvent();
}

class GetAllVisionBoardsEvent extends VisionBoardEvent {
  final String userId;

  GetAllVisionBoardsEvent({
    this.userId,
  });

  @override
  List<Object> get props => [userId];
}

class CreateVisionBoardEvent extends VisionBoardEvent {
  final VisionBoardModel visionBoard;

  CreateVisionBoardEvent({
    this.visionBoard,
  });

  @override
  List<Object> get props => [visionBoard];
}

class UpdateVisionBoardEvent extends VisionBoardEvent {
  final VisionBoardModel visionBoard;

  UpdateVisionBoardEvent({
    this.visionBoard,
  });

  @override
  List<Object> get props => [visionBoard];
}

class DeleteVisionBoardEvent extends VisionBoardEvent {
  final VisionBoardModel visionBoard;

  DeleteVisionBoardEvent({
    this.visionBoard,
  });

  @override
  List<Object> get props => [visionBoard];
}

class GetAllVisionsEvent extends VisionBoardEvent {
  final String visionBoardId;

  GetAllVisionsEvent({
    this.visionBoardId,
  });

  @override
  List<Object> get props => [visionBoardId];
}

class CreateVisionEvent extends VisionBoardEvent {
  final VisionModel vision;

  CreateVisionEvent({
    this.vision,
  });

  @override
  List<Object> get props => [vision];
}

class UpdateVisionEvent extends VisionBoardEvent {
  final VisionModel vision;

  UpdateVisionEvent({
    this.vision,
  });

  @override
  List<Object> get props => [vision];
}

class DeleteVisionEvent extends VisionBoardEvent {
  final VisionModel vision;

  DeleteVisionEvent({
    this.vision,
  });

  @override
  List<Object> get props => [vision];
}
