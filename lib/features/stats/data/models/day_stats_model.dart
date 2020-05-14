import 'package:equatable/equatable.dart';
import 'package:project_runway/core/keys.dart';

class DayStatsModel extends Equatable {
  int tasksCompleted;
  int tasksDeleted;
  int tasksCreated;
  DateTime runningDate;

  DayStatsModel({
    this.tasksCompleted = 0,
    this.tasksDeleted = 0,
    this.tasksCreated = 0,
    this.runningDate,
  });

  @override
  List<Object> get props => [
        tasksCompleted,
        tasksCreated,
        tasksDeleted,
        runningDate,
      ];

  factory DayStatsModel.fromJson(String stats) {
    DayStatsModel dayStatsModel;
    if (stats != null && stats.isNotEmpty) {
      List<String> dayStats = stats.split(STATS_BREAK_KEY);
      dayStatsModel = DayStatsModel(
          tasksCompleted: int.parse(dayStats[2]),
          tasksCreated: int.parse(dayStats[0]),
          tasksDeleted: int.parse(dayStats[1]),
          runningDate:
              dayStats[3] == null ? null : DateTime.parse(dayStats[3]));
    } else {
      dayStatsModel = DayStatsModel(
        tasksDeleted: 0,
        tasksCreated: 0,
        tasksCompleted: 0,
        runningDate: DateTime.now(),
      );
    }
    return dayStatsModel;
  }

  String toJson() {
    return "$tasksCreated$STATS_BREAK_KEY$tasksDeleted$STATS_BREAK_KEY$tasksCompleted$STATS_BREAK_KEY${runningDate.toString()}";
  }
}
