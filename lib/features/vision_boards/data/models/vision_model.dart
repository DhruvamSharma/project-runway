import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class VisionModel extends Equatable {
  final String visionBoardId;
  final String visionId;
  final String imageUrl;
  final String visionName;
  final String quote;
  final DateTime createdAt;
  final int points;
  final String anotherVariable;
  final bool isDeleted;
  final bool isCompleted;
  final String profileImageUrl;
  final String fullName;

  VisionModel({
    @required this.visionBoardId,
    @required this.visionId,
    @required this.imageUrl,
    @required this.visionName,
    @required this.quote,
    @required this.createdAt,
    @required this.points,
    @required this.anotherVariable,
    @required this.isDeleted,
    @required this.isCompleted,
    @required this.profileImageUrl,
    @required this.fullName,
  });

  @override
  List<Object> get props => [
        visionBoardId,
        visionId,
        imageUrl,
        visionName,
        quote,
        createdAt,
        points,
        anotherVariable,
        isCompleted,
        profileImageUrl,
        fullName,
      ];

  factory VisionModel.fromJson(Map<String, Object> map) {
    try {
      return VisionModel(
        visionBoardId: map["visionBoardId"],
        imageUrl: map["imageUrl"],
        visionId: map["visionId"],
        visionName: map["visionName"],
        quote: map["quote"],
        createdAt: DateTime.parse(map["createdAt"]),
        points: map["points"],
        anotherVariable: map["anotherVariable"],
        isDeleted: map["isDeleted"],
        isCompleted: map["isCompleted"],
        profileImageUrl: map["profileImageUrl"],
        fullName: map["fullName"],
      );
    } catch (ex) {
      print(ex.toString());
      return null;
    }
  }

  Map<String, Object> toJson() {
    try {
      return {
        "visionBoardId": visionBoardId,
        "visionId": visionId,
        "imageUrl": imageUrl,
        "visionName": visionName,
        "quote": quote,
        "createdAt": createdAt.toString(),
        "points": points,
        "anotherVariable": anotherVariable,
        "isDeleted": isDeleted,
        "isCompleted": isCompleted,
        "profileImageUrl": profileImageUrl,
        "fullName": fullName,
      };
    } catch (ex) {
      print(ex.toString());
      return null;
    }
  }
}
