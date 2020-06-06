import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/features/vision_boards/domain/use_cases/create_vision_board_use_case.dart';
import 'package:project_runway/features/vision_boards/domain/use_cases/create_vision_use_case.dart';
import 'package:project_runway/features/vision_boards/domain/use_cases/delete_vision_board_use_case.dart';
import 'package:project_runway/features/vision_boards/domain/use_cases/delete_vision_use_case.dart';
import 'package:project_runway/features/vision_boards/domain/use_cases/read_all_vision_board_use_case.dart';
import 'package:project_runway/features/vision_boards/domain/use_cases/read_vision_board_use_case.dart';
import 'package:project_runway/features/vision_boards/domain/use_cases/update_vision_board_use_case.dart';
import 'package:project_runway/features/vision_boards/domain/use_cases/update_vision_use_case.dart';

import './bloc.dart';

class VisionBoardBloc extends Bloc<VisionBoardEvent, VisionBoardState> {
  final ReadAllVisionBoardUseCase readAllVisionBoardUseCase;
  final UpdateVisionBoardUseCase updateVisionBoardUseCase;
  final DeleteVisionBoardUseCase deleteVisionBoardUseCase;
  final CreateVisionBoardUseCase createVisionBoardUseCase;

  final ReadVisionBoardUseCase readVisionBoardUseCase;
  final CreateVisionUseCase createVisionUseCase;
  final UpdateVisionUseCase updateVisionUseCase;
  final DeleteVisionUseCase deleteVisionUseCase;

  VisionBoardBloc({
    @required this.readAllVisionBoardUseCase,
    @required this.updateVisionBoardUseCase,
    @required this.deleteVisionBoardUseCase,
    @required this.createVisionBoardUseCase,
    @required this.readVisionBoardUseCase,
    @required this.createVisionUseCase,
    @required this.updateVisionUseCase,
    @required this.deleteVisionUseCase,
  });

  @override
  VisionBoardState get initialState => InitialVisionBoardState();

  @override
  Stream<VisionBoardState> mapEventToState(
    VisionBoardEvent event,
  ) async* {
    if (event is GetAllVisionBoardsEvent) {
      yield LoadingVisionBoardState();
      final response = await readAllVisionBoardUseCase(
          VisionBoardIdParam(userId: event.userId));
      yield response.fold(
        (l) => ErrorVisionBoardState(message: mapFailureToMessage(l)),
        (r) => LoadedGetAllVisionBoardState(visionBoardList: r),
      );
    }

    if (event is CreateVisionBoardEvent) {
      yield LoadingVisionBoardState();
      final response = await createVisionBoardUseCase(
          VisionBoardParam(visionBoard: event.visionBoard));
      yield response.fold(
        (l) => ErrorVisionBoardState(message: mapFailureToMessage(l)),
        (r) => LoadedCreateVisionBoardState(visionBoard: r),
      );
    }

    if (event is UpdateVisionBoardEvent) {
      yield LoadingVisionBoardState();
      final response = await updateVisionBoardUseCase(
          VisionBoardParam(visionBoard: event.visionBoard));
      yield response.fold(
        (l) => ErrorVisionBoardState(message: mapFailureToMessage(l)),
        (r) => LoadedUpdateVisionBoardState(visionBoard: r),
      );
    }

    if (event is DeleteVisionBoardEvent) {
      yield LoadingVisionBoardState();
      final response = await deleteVisionBoardUseCase(
          VisionBoardParam(visionBoard: event.visionBoard));
      yield response.fold(
        (l) => ErrorVisionBoardState(message: mapFailureToMessage(l)),
        (r) => LoadedDeleteVisionBoardState(visionBoard: r),
      );
    }

    if (event is GetAllVisionsEvent) {
      yield LoadingVisionBoardState();
      final response = await readVisionBoardUseCase(
          VisionIdParam(visionBoardId: event.visionBoardId));
      yield response.fold(
        (l) => ErrorVisionBoardState(message: mapFailureToMessage(l)),
        (r) => LoadedGetAllVisionState(visionList: r),
      );
    }

    if (event is CreateVisionEvent) {
      yield LoadingVisionBoardState();
      final response =
          await createVisionUseCase(VisionParam(vision: event.vision));
      yield response.fold(
        (l) => ErrorVisionBoardState(message: mapFailureToMessage(l)),
        (r) => LoadedCreateVisionState(vision: r),
      );
    }

    if (event is UpdateVisionEvent) {
      yield LoadingVisionBoardState();
      final response =
          await updateVisionUseCase(VisionParam(vision: event.vision));
      yield response.fold(
        (l) => ErrorVisionBoardState(message: mapFailureToMessage(l)),
        (r) => LoadedUpdateVisionState(vision: r),
      );
    }

    if (event is DeleteVisionEvent) {
      yield LoadingVisionBoardState();
      final response =
          await deleteVisionUseCase(VisionParam(vision: event.vision));
      yield response.fold(
        (l) => ErrorVisionBoardState(message: mapFailureToMessage(l)),
        (r) => LoadedDeleteVisionState(vision: r),
      );
    }
  }
}
