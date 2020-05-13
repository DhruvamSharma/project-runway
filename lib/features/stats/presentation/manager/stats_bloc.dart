import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/use_case.dart';
import 'package:project_runway/features/stats/domain/use_cases/add_score_use_case.dart';
import 'package:project_runway/features/stats/domain/use_cases/get_stats_table_use_case.dart';
import './bloc.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final GetStatsTableUseCase statsTableUseCase;
  final AddScoreUseCase addScoreUseCase;

  StatsBloc({
    @required this.statsTableUseCase,
    @required this.addScoreUseCase,
  });

  @override
  StatsState get initialState => InitialStatsState();

  @override
  Stream<StatsState> mapEventToState(
    StatsEvent event,
  ) async* {
    if (event is GetStatsTableEvent) {
      yield LoadingStatsState();
      final response = await statsTableUseCase(NoParams());
      yield response.fold(
        (failure) => ErrorGetStatsState(message: mapFailureToMessage(failure)),
        (response) => LoadedGetStatsState(statsTable: response),
      );
    } else if (event is AddScoreEvent) {
      yield LoadingStatsState();
      final response = await addScoreUseCase(AddScoreUseCaseParam(
        score: event.score,
      ));
      yield response.fold(
        (failure) => ErrorGetStatsState(message: mapFailureToMessage(failure)),
        (response) => LoadedAddScoreState(scoreAdded: response),
      );
    }
  }
}
