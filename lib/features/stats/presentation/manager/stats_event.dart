import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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
