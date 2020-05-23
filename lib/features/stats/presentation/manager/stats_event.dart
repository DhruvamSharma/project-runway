import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:project_runway/features/stats/data/models/puzzle_model.dart';

@immutable
abstract class StatsEvent extends Equatable {
  final List customProps = const <dynamic>[];

  const StatsEvent();

  @override
  List<Object> get props => customProps;
}

class AddScoreEvent extends StatsEvent {
  final int score;

  const AddScoreEvent({
    @required this.score,
  });

  @override
  List<Object> get props => [score];
}

class GetStatsTableEvent extends StatsEvent {
  const GetStatsTableEvent();

  @override
  List<Object> get props => [];
}

class GetPuzzleEvent extends StatsEvent {
  final int puzzleId;
  const GetPuzzleEvent({@required this.puzzleId});

  @override
  List<Object> get props => [puzzleId];
}

class SetUserPuzzleSolution extends StatsEvent {
  final UserPuzzleModel userPuzzleModel;
  const SetUserPuzzleSolution({@required this.userPuzzleModel});

  @override
  List<Object> get props => [userPuzzleModel];
}

class GetPuzzleSolvedList extends StatsEvent {
  final String userId;
  const GetPuzzleSolvedList({@required this.userId});

  @override
  List<Object> get props => [userId];
}
