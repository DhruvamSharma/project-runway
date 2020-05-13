import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:project_runway/features/stats/data/models/managed_stats_model.dart';

@immutable
abstract class StatsState extends Equatable {
  final List customProps = const <dynamic>[];

  const StatsState();

  @override
  List<Object> get props => customProps;
}

class InitialStatsState extends StatsState {}

class LoadingStatsState extends StatsState {}

// Get stats table
class LoadedGetStatsState extends StatsState {
  final ManagedStatsTable statsTable;

  LoadedGetStatsState({
    @required this.statsTable,
  });
  @override
  List<Object> get props => [statsTable];
}

class ErrorGetStatsState extends StatsState {
  final String message;

  ErrorGetStatsState({
    @required this.message,
  });
  @override
  List<Object> get props => [message];
}

// Add score
class LoadedAddScoreState extends StatsState {
  final bool scoreAdded;

  LoadedAddScoreState({
    @required this.scoreAdded,
  });
  @override
  List<Object> get props => [scoreAdded];
}

class ErrorAddScoreState extends StatsState {
  final String message;

  ErrorAddScoreState({
    @required this.message,
  });
  @override
  List<Object> get props => [message];
}
