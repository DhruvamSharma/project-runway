import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/use_case.dart';
import 'package:project_runway/features/stats/domain/use_cases/add_score_use_case.dart';
import 'package:project_runway/features/stats/domain/use_cases/get_puzzle_solved_list_use_case.dart';
import 'package:project_runway/features/stats/domain/use_cases/get_puzzle_use_case.dart';
import 'package:project_runway/features/stats/domain/use_cases/get_stats_table_use_case.dart';
import 'package:project_runway/features/stats/domain/use_cases/set_puzzle_solution_use_case.dart';
import './bloc.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final GetStatsTableUseCase statsTableUseCase;
  final AddScoreUseCase addScoreUseCase;
  final GetPuzzleUseCase getPuzzleUseCase;
  final SetPuzzleSolutionUseCase setPuzzleSolutionUseCase;
  final GetPuzzleSolvedListUseCase getPuzzleSolvedListUseCase;
  StatsBloc({
    @required this.statsTableUseCase,
    @required this.addScoreUseCase,
    @required this.getPuzzleUseCase,
    @required this.getPuzzleSolvedListUseCase,
    @required this.setPuzzleSolutionUseCase,
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
    } else if (event is GetPuzzleEvent) {
      yield LoadingStatsState();
      final response = await getPuzzleUseCase(GetPuzzleUseCaseParam(
        puzzleId: event.puzzleId,
      ));
      yield response.fold(
        (failure) => ErrorGetPuzzleState(message: mapFailureToMessage(failure)),
        (response) => LoadedGetPuzzleState(puzzle: response),
      );
    } else if (event is SetUserPuzzleSolution) {
      yield LoadingStatsState();
      final response =
          await setPuzzleSolutionUseCase(SetPuzzleSolutionUseCaseParam(
        puzzleSolution: event.userPuzzleModel,
      ));
      yield response.fold(
        (failure) =>
            ErrorSetPuzzleSolutionState(message: mapFailureToMessage(failure)),
        (response) => LoadedSetPuzzleSolutionState(puzzleSolution: response),
      );
    } else if (event is GetPuzzleSolvedList) {
      yield LoadingStatsState();
      final response =
          await getPuzzleSolvedListUseCase(GetSolvedPuzzleListUseCaseParam(
        userId: event.userId,
      ));
      yield response.fold(
        (failure) => ErrorGetPuzzleSolvedListState(
            message: mapFailureToMessage(failure)),
        (response) => LoadedGetPuzzleSolvedListState(puzzleSolutions: response),
      );
    }
  }
}
