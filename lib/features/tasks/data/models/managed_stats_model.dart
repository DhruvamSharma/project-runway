import 'package:equatable/equatable.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/core/keys.dart';
import 'package:project_runway/features/tasks/data/models/day_stats_model.dart';

// ignore: must_be_immutable
class ManagedStatsTable extends Equatable {
  String userId;
  int score;
  List<DayStatsModel> dayStats;

  ManagedStatsTable({
    this.userId,
    this.score = 0,
    this.dayStats,
  });

  @override
  List<Object> get props => [
        userId,
        score,
        dayStats,
      ];

  factory ManagedStatsTable.fromJson(Map<String, Object> map) {
    ManagedStatsTable statsTable;
    if (map != null && map.isNotEmpty) {
      List<DayStatsModel> dayStats = List();
      refactorDayStatsToModel(dayStats, map);
      statsTable = ManagedStatsTable(
        score: map["score"] != null ? map["score"] : 0,
        userId: map["userId"],
        dayStats: dayStats,
      );
    } else {
      statsTable = ManagedStatsTable(
        userId: sharedPreferences.getString(USER_KEY),
        score: 0,
        dayStats: [
          DayStatsModel(), //1
          DayStatsModel(), //2
          DayStatsModel(), //3
          DayStatsModel(), //4
          DayStatsModel(), //5
          DayStatsModel(), //6
          DayStatsModel(), //7
        ],
      );
    }
    return statsTable;
  }

  Map<String, Object> toJson() {
    return {
      "userId": userId,
      "score": score,
      "dayOne": dayStats[0].toJson(),
      "dayTwo": dayStats[1].toJson(),
      "dayThree": dayStats[2].toJson(),
      "dayFour": dayStats[3].toJson(),
      "dayFive": dayStats[4].toJson(),
      "daySix": dayStats[5].toJson(),
      "daySeven": dayStats[6].toJson(),
    };
  }

  static void refactorDayStatsToModel(
      List<DayStatsModel> dayStats, Map<String, Object> map) {
    dayStats.insert(0, DayStatsModel.fromJson(map["dayOne"]));
    dayStats.insert(1, DayStatsModel.fromJson(map["dayTwo"]));
    dayStats.insert(2, DayStatsModel.fromJson(map["dayThree"]));
    dayStats.insert(3, DayStatsModel.fromJson(map["dayFour"]));
    dayStats.insert(4, DayStatsModel.fromJson(map["dayFive"]));
    dayStats.insert(5, DayStatsModel.fromJson(map["daySix"]));
    dayStats.insert(6, DayStatsModel.fromJson(map["daySeven"]));
  }
}
