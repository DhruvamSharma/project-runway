import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/errors/exceptions.dart';
import 'package:project_runway/core/keys.dart';
import 'package:project_runway/features/vision_boards/data/models/vision_board_model.dart';
import 'package:project_runway/features/vision_boards/data/models/vision_model.dart';

abstract class RemoteVisionBoardDataSource {
  Future<VisionBoardModel> createVisionBoard(VisionBoardModel visionBoard);
  Future<List<VisionBoardModel>> readAllVisionBoards(String userId);
  Future<VisionBoardModel> updateVisionBoard(VisionBoardModel visionBoard);
  Future<VisionBoardModel> deleteVisionBoard(VisionBoardModel visionBoard);

  Future<List<VisionModel>> readVisionBoard(String visionBoardId);
  Future<VisionModel> createVision(VisionModel vision);
  Future<VisionModel> updateVision(VisionModel vision);
  Future<VisionModel> deleteVision(VisionModel vision);
}

class RemoteVisionBoardDataSourceImpl implements RemoteVisionBoardDataSource {
  final Firestore firestore;

  RemoteVisionBoardDataSourceImpl({
    @required this.firestore,
  });

  @override
  Future<VisionModel> createVision(VisionModel vision) {
    firestore
        .collection(VISION_COLLECTION)
        .document(vision.visionId)
        .setData(vision.toJson());
    return Future.value(vision);
  }

  @override
  Future<VisionBoardModel> createVisionBoard(VisionBoardModel visionBoard) {
    firestore
        .collection(VISION_BOARD_COLLECTION)
        .document(visionBoard.visionBoardId)
        .setData(visionBoard.toJson());
    return Future.value(visionBoard);
  }

  @override
  Future<VisionModel> deleteVision(VisionModel vision) {
    // already marked deleted object received
    firestore
        .collection(VISION_COLLECTION)
        .document(vision.visionId)
        .updateData(vision.toJson());
    return Future.value(vision);
  }

  @override
  Future<VisionBoardModel> deleteVisionBoard(VisionBoardModel visionBoard) {
    // already marked deleted object received
    firestore
        .collection(VISION_BOARD_COLLECTION)
        .document(visionBoard.visionBoardId)
        .updateData(visionBoard.toJson());
    return Future.value(visionBoard);
  }

  @override
  Future<List<VisionBoardModel>> readAllVisionBoards(String userId) async {
    try {
      final visionFirebaseData = await firestore
          .collection(VISION_BOARD_COLLECTION)
          .where("userId", isEqualTo: userId)
          .getDocuments();
      final List<VisionBoardModel> visionBoards = List();
      for (int i = 0; i < visionFirebaseData.documents.length; i++) {
        final visionBoard =
            VisionBoardModel.fromJson(visionFirebaseData.documents[i].data);
        visionBoards.add(visionBoard);
      }
      return visionBoards;
    } catch (ex) {
      throw ServerException(message: FIREBASE_ERROR);
    }
  }

  @override
  Future<List<VisionModel>> readVisionBoard(String visionBoardId) async {
    try {
      final visionFirebaseData = await firestore
          .collection(VISION_COLLECTION)
          .where("visionBoardId", isEqualTo: visionBoardId)
          .getDocuments();
      final List<VisionModel> visions = List();
      for (int i = 0; i < visionFirebaseData.documents.length; i++) {
        final vision =
            VisionModel.fromJson(visionFirebaseData.documents[i].data);
        visions.add(vision);
      }
      return visions;
    } catch (ex) {
      throw ServerException(message: FIREBASE_ERROR);
    }
  }

  @override
  Future<VisionModel> updateVision(VisionModel vision) {
    firestore
        .collection(VISION_COLLECTION)
        .document(vision.visionId)
        .updateData(vision.toJson());
    return Future.value(vision);
  }

  @override
  Future<VisionBoardModel> updateVisionBoard(VisionBoardModel visionBoard) {
    firestore
        .collection(VISION_BOARD_COLLECTION)
        .document(visionBoard.visionBoardId)
        .updateData(visionBoard.toJson());
    return Future.value(visionBoard);
  }
}
