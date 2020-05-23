import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PuzzleModel extends Equatable {
  final int puzzleId;
  final String puzzleImageLight;
  final String puzzleImageDark;
  final String puzzleDescription;
  final int puzzleSolution;
  final int puzzlePoints;
  final DateTime puzzleCreatedAt;

  PuzzleModel({
    @required this.puzzleId,
    @required this.puzzleImageLight,
    @required this.puzzleImageDark,
    @required this.puzzleDescription,
    @required this.puzzleSolution,
    @required this.puzzlePoints,
    @required this.puzzleCreatedAt,
  });

  @override
  List<Object> get props => [
        puzzleId,
        puzzleImageLight,
        puzzleImageDark,
        puzzleDescription,
        puzzleSolution,
        puzzlePoints,
        puzzleCreatedAt,
      ];

  factory PuzzleModel.fromJson(Map<String, Object> map) {
    return PuzzleModel(
      puzzleId: map["puzzleId"],
      puzzleImageLight: map["puzzleImageLight"],
      puzzleImageDark: map["puzzleImageDark"],
      puzzleDescription: map["puzzleDescription"],
      puzzleSolution: map["puzzleSolution"],
      puzzlePoints: map["puzzlePoints"],
      puzzleCreatedAt: DateTime.parse(map["puzzleCreatedAt"]),
    );
  }
}

class UserPuzzleModel {
  String userId;
  int puzzleId;
  DateTime puzzleSolvedDate;
  DateTime puzzleCreatedAt;
  int puzzlePointsEarned;

  UserPuzzleModel({
    @required this.userId,
    @required this.puzzleSolvedDate,
    @required this.puzzleCreatedAt,
    @required this.puzzlePointsEarned,
    @required this.puzzleId,
  });

  factory UserPuzzleModel.fromJson(Map<String, Object> map) {
    return UserPuzzleModel(
      userId: map["userId"],
      puzzleSolvedDate: DateTime.parse(map["puzzleSolvedDate"]),
      puzzleCreatedAt: DateTime.parse(map["puzzleCreatedAt"]),
      puzzlePointsEarned: map["puzzlePointsEarned"],
      puzzleId: map["puzzleId"],
    );
  }

  Map<String, Object> toJson() {
    return {
      "userId": userId,
      "puzzleId": puzzleId,
      "puzzleSolvedDate": puzzleSolvedDate.toString(),
      "puzzleCreatedAt": puzzleCreatedAt.toString(),
      "puzzlePointsEarned": puzzlePointsEarned,
    };
  }
}
