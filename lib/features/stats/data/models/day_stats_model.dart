import 'package:equatable/equatable.dart';
import 'package:project_runway/core/keys.dart';

class DayStatsModel extends Equatable {
  int tasksCompleted;
  int tasksDeleted;
  int tasksCreated;

  DayStatsModel({
    this.tasksCompleted = 0,
    this.tasksDeleted = 0,
    this.tasksCreated = 0,
  });

  @override
  List<Object> get props => [
        tasksCompleted,
        tasksCreated,
        tasksDeleted,
      ];

  factory DayStatsModel.fromJson(String stats) {
    DayStatsModel dayStatsModel;
    if (stats != null && stats.isNotEmpty) {
      List<String> dayStats = stats.split(STATS_BREAK_KEY);
      dayStatsModel = DayStatsModel(
        tasksCompleted: int.parse(dayStats[2]),
        tasksCreated: int.parse(dayStats[0]),
        tasksDeleted: int.parse(dayStats[1]),
      );
    } else {
      dayStatsModel = DayStatsModel(
        tasksDeleted: 0,
        tasksCreated: 0,
        tasksCompleted: 0,
      );
    }
    return dayStatsModel;
  }

  String toJson() {
    return "$tasksCreated$STATS_BREAK_KEY$tasksDeleted$STATS_BREAK_KEY$tasksCompleted";
  }
}
