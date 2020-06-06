import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/features/vision_boards/data/models/vision_board_model.dart';
import 'package:project_runway/features/vision_boards/data/models/vision_model.dart';

abstract class VisionBoardState extends Equatable {
  const VisionBoardState();
}

class InitialVisionBoardState extends VisionBoardState {
  @override
  List<Object> get props => [];
}

class LoadingVisionBoardState extends VisionBoardState {
  @override
  List<Object> get props => [];
}

class LoadedGetAllVisionBoardState extends VisionBoardState {
  final List<VisionBoardModel> visionBoardList;

  LoadedGetAllVisionBoardState({
    this.visionBoardList,
  });

  @override
  List<Object> get props => [
        visionBoardList,
      ];
}

class LoadedCreateVisionBoardState extends VisionBoardState {
  final VisionBoardModel visionBoard;

  LoadedCreateVisionBoardState({
    this.visionBoard,
  });

  @override
  List<Object> get props => [visionBoard];
}

class LoadedUpdateVisionBoardState extends VisionBoardState {
  final VisionBoardModel visionBoard;

  LoadedUpdateVisionBoardState({
    this.visionBoard,
  });

  @override
  List<Object> get props => [visionBoard];
}

class LoadedDeleteVisionBoardState extends VisionBoardState {
  final VisionBoardModel visionBoard;

  LoadedDeleteVisionBoardState({
    this.visionBoard,
  });

  @override
  List<Object> get props => [visionBoard];
}

class LoadedGetAllVisionState extends VisionBoardState {
  final List<VisionModel> visionList;

  LoadedGetAllVisionState({
    this.visionList,
  });

  @override
  List<Object> get props => [
        visionList,
      ];
}

class LoadedCreateVisionState extends VisionBoardState {
  final VisionModel vision;

  LoadedCreateVisionState({
    this.vision,
  });

  @override
  List<Object> get props => [vision];
}

class LoadedUpdateVisionState extends VisionBoardState {
  final VisionModel vision;

  LoadedUpdateVisionState({
    this.vision,
  });

  @override
  List<Object> get props => [vision];
}

class LoadedDeleteVisionState extends VisionBoardState {
  final VisionModel vision;

  LoadedDeleteVisionState({
    this.vision,
  });

  @override
  List<Object> get props => [vision];
}

class ErrorVisionBoardState extends VisionBoardState {
  final String message;

  ErrorVisionBoardState({
    @required this.message,
  });

  @override
  List<Object> get props => [
        message,
      ];
}
