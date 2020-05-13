import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

// ignore: must_be_immutable
class StatsModel extends Equatable {
  @override
  List<Object> get props => [
        userId,
        score,
        daySeven,
        daySix,
        dayFive,
        dayThree,
        dayOne,
        dayFour,
        dayTwo,
      ];
  // DateTime.monday
  // created&&deleted&&completed
  String dayOne;
  String dayTwo;
  String dayThree;
  String dayFour;
  String dayFive;
  String daySix;
  // DateTime.sunday
  String daySeven;
  String userId;
  int score;
  StatsModel({
    @required this.dayOne,
    @required this.dayTwo,
    @required this.dayThree,
    @required this.dayFour,
    @required this.dayFive,
    @required this.daySix,
    @required this.daySeven,
    @required this.userId,
    @required this.score,
  });

  factory StatsModel.fromJson(Map<String, Object> map) {
    return StatsModel(
      dayOne: map["dayOne"],
      dayTwo: map["dayTwo"],
      dayThree: map["dayThree"],
      dayFour: map["dayFour"],
      dayFive: map["dayFive"],
      daySix: map["daySix"],
      daySeven: map["daySeven"],
      userId: map["userId"],
      score: map["score"],
    );
  }

  Map<String, Object> toJson() {
    return {
      "dayOne": dayOne,
      "dayTwo": dayTwo,
      "dayThree": dayThree,
      "dayFour": dayFour,
      "dayFive": dayFive,
      "daySix": daySix,
      "daySeven": daySeven,
      "userId": userId,
      "score": score,
    };
  }
}
