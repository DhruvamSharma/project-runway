import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class VisionBoardModel extends Equatable {
  final String visionBoardId;
  final String userId;
  final DateTime createdAt;
  final String quote;
  final String userQuote;
  final int points;
  final String imageUrl;
  final bool isDeleted;
  final String anotherVariable;

  VisionBoardModel({
    @required this.visionBoardId,
    @required this.userId,
    @required this.createdAt,
    @required this.quote,
    @required this.userQuote,
    @required this.points,
    @required this.imageUrl,
    @required this.isDeleted,
    @required this.anotherVariable,
  });

  @override
  List<Object> get props => [
        visionBoardId,
        userId,
        createdAt,
        quote,
        userQuote,
        points,
        imageUrl,
        isDeleted,
        anotherVariable,
      ];

  factory VisionBoardModel.fromJson(Map<String, Object> map) {
    try {
      return VisionBoardModel(
        visionBoardId: map["visionBoardId"],
        userId: map["userId"],
        userQuote: map["userQuote"],
        imageUrl: map["imageUrl"],
        quote: map["quote"],
        createdAt: DateTime.parse(map["createdAt"]),
        points: map["points"],
        anotherVariable: map["anotherVariable"],
        isDeleted: map["isDeleted"],
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
        "userId": userId,
        "userQuote": userQuote,
        "imageUrl": imageUrl,
        "quote": quote,
        "createdAt": createdAt.toString(),
        "points": points,
        "anotherVariable": anotherVariable,
        "isDeleted": isDeleted,
      };
    } catch (ex) {
      print(ex.toString());
      return null;
    }
  }
}
