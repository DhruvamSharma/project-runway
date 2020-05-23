import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/errors/exceptions.dart';
import 'package:project_runway/core/keys.dart';
import 'package:project_runway/features/stats/data/models/managed_stats_model.dart';
import 'package:project_runway/features/stats/data/models/puzzle_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class StatsRemoteDataSource {
  Future<ManagedStatsTable> fetchStatsTable();
  void addTaskAndIncrementScore(DateTime runningDate, int urgency);
  void deleteTaskAndDecrementScore(DateTime runningDate, int urgency);
  void completeTaskAndUpdateScore(
      DateTime runningDate, bool isCompleted, int urgency);
  Future<bool> addScore(int score);
  Future<PuzzleModel> getPuzzle(int puzzleId);
  Future<UserPuzzleModel> setPuzzleSolution(UserPuzzleModel userPuzzleModel);
  Future<UserPuzzleModel> getPuzzleSolution(UserPuzzleModel userPuzzleModel);
  Future<List<UserPuzzleModel>> getPuzzleSolvedList(String userId);
}

class StatsRemoteDataSourceImpl implements StatsRemoteDataSource {
  final Firestore firestore;
  final SharedPreferences sharedPreferences;

  StatsRemoteDataSourceImpl({
    @required this.firestore,
    @required this.sharedPreferences,
  });

  @override
  Future<bool> addScore(int score) async {
    try {
      // fetch the stats table form the firestore
      final fetchedStatsData = await fetchStatsTable();
      // update the score in model
      fetchedStatsData.score += score;
      // convert the data back to desired format
      final statsJson = fetchedStatsData.toJson();
      // update the database
      firestore
          .collection(STATS_COLLECTION)
          .document(sharedPreferences.getString(USER_KEY))
          .setData(statsJson);
      return true;
    } catch (ex) {
      throw ServerException(message: FIREBASE_ERROR);
    }
  }

  @override
  Future<ManagedStatsTable> fetchStatsTable() async {
    try {
      final userId = sharedPreferences.getString(USER_KEY);
      // get the stats from the database
      final statsData =
          await firestore.collection(STATS_COLLECTION).document(userId).get();
      // parse the data
      final statsModel = ManagedStatsTable.fromJson(statsData.data);
      // find out which day of the week is today
      final int dayOfTheWeek = DateTime.now().weekday;
      // get the stats for that day
      final dayStats = statsModel.dayStats[dayOfTheWeek - 1];
      // check if the today stats are of today and not of previous week
      // and if they are, reset them
      // also make a check if the user has entered task for the t+1 day
      // and if so, then do not reset the stat
      if (dayStats.runningDate.day != DateTime.now().day) {
        dayStats.runningDate = DateTime.now();
        dayStats.tasksCreated = 0;
        dayStats.tasksCompleted = 0;
        dayStats.tasksDeleted = 0;
      }
      return statsModel;
    } catch (ex) {
      throw ServerException(message: FIREBASE_ERROR);
    }
  }

  void addTaskAndIncrementScore(DateTime runningDate, int urgency) async {
    try {
      // fetch the stats table form the firestore
      final fetchedStatsData = await fetchStatsTable();
      // find out what day does the task belong to
      final int dayOfTheWeek = runningDate.weekday;
      // get the stats for that day
      final dayStats = fetchedStatsData.dayStats[dayOfTheWeek - 1];
      // add the task to the day stats
      dayStats.tasksCreated += 1;
      // assign the running date to that day stats
      dayStats.runningDate = runningDate;
      // increment the score
      fetchedStatsData.score +=
          (urgency * TASK_CREATION_POINTS / TASK_MEASUREMENT_DIVISION_CONSTANT)
              .floor();
      // assign the day Stats back to the list
      fetchedStatsData.dayStats[dayOfTheWeek - 1] = dayStats;
      // convert the data back to desired format
      final statsJson = fetchedStatsData.toJson();
      // update the data back to database
      firestore
          .collection(STATS_COLLECTION)
          .document(sharedPreferences.getString(USER_KEY))
          .setData(statsJson);
    } catch (ex) {
      // Do nothing
    }
  }

  void deleteTaskAndDecrementScore(DateTime runningDate, int urgency) async {
    try {
      // fetch the stats table form the firestore
      final fetchedStatsData = await fetchStatsTable();
      // find out what day does the task belong to
      final int dayOfTheWeek = runningDate.weekday;
      // get the stats for that day
      final dayStats = fetchedStatsData.dayStats[dayOfTheWeek - 1];
      // add the task to the day stats
      dayStats.tasksDeleted += 1;
      // assign the running date to that day stats
      dayStats.runningDate = runningDate;
      // decrement the score
      fetchedStatsData.score -=
          (urgency * TASK_DELETION_POINTS / TASK_MEASUREMENT_DIVISION_CONSTANT)
              .floor();
      // avoid non negative score, if any
      if (fetchedStatsData.score < 0) {
        fetchedStatsData.score = 0;
      }
      // assign the day Stats back to the list
      fetchedStatsData.dayStats[dayOfTheWeek - 1] = dayStats;
      // convert the data back to desired format
      final statsJson = fetchedStatsData.toJson();
      // update the data back to database
      firestore
          .collection(STATS_COLLECTION)
          .document(sharedPreferences.getString(USER_KEY))
          .setData(statsJson);
    } catch (Ex) {
      // Do nothing
    }
  }

  void completeTaskAndUpdateScore(
      DateTime runningDate, bool isCompleted, int urgency) async {
    try {
      // fetch the stats table form the firestore
      final fetchedStatsData = await fetchStatsTable();
      // find out what day does the task belong to
      final int dayOfTheWeek = runningDate.weekday;
      // get the stats for that day
      final dayStats = fetchedStatsData.dayStats[dayOfTheWeek - 1];
      if (isCompleted) {
        // add the task to the day stats
        dayStats.tasksCompleted += 1;
        // add the score
        fetchedStatsData.score += (urgency *
                TASK_COMPLETION_POINTS /
                TASK_MEASUREMENT_DIVISION_CONSTANT)
            .floor();
      } else {
        // remove the task to the day stats
        dayStats.tasksCompleted -= 1;
        // decrement the score
        fetchedStatsData.score -= (urgency *
                TASK_COMPLETION_POINTS /
                TASK_MEASUREMENT_DIVISION_CONSTANT)
            .floor();
      }
      // assign the running date to that day stats
      dayStats.runningDate = runningDate;
      // assign the day Stats back to the list
      fetchedStatsData.dayStats[dayOfTheWeek - 1] = dayStats;
      // convert the data back to desired format
      final statsJson = fetchedStatsData.toJson();
      // update the data back to database
      firestore
          .collection(STATS_COLLECTION)
          .document(sharedPreferences.getString(USER_KEY))
          .setData(statsJson);
    } catch (ex) {
      // Do nothing
    }
  }

  @override
  Future<PuzzleModel> getPuzzle(int puzzleId) async {
    try {
      // get the puzzle required
      // userScore = puzzleId
      final firestoreResponse = await firestore
          .collection(PUZZLE_COLLECTION)
          .where("puzzleId", isEqualTo: puzzleId)
          .getDocuments();

      // take out the puzzle if present
      if (firestoreResponse.documents.length > 0) {
        // model the response
        final puzzleModel =
            PuzzleModel.fromJson(firestoreResponse.documents[0].data);
        return puzzleModel;
      } else {
        // throw exception if no puzzle for that puzzle id found
        throw ServerException(message: NO_NEW_PUZZLE_ERROR);
      }
    } on ServerException catch (ex) {
      throw ServerException(message: ex.message);
    } catch (ex) {
      throw ServerException(message: FIREBASE_ERROR);
    }
  }

  @override
  Future<UserPuzzleModel> getPuzzleSolution(UserPuzzleModel userPuzzleModel) {
    // TODO: implement getPuzzleSolution
    throw UnimplementedError();
  }

  @override
  Future<List<UserPuzzleModel>> getPuzzleSolvedList(String userId) async {
    try {
      // get the puzzle solved solution
      // for the user with latest puzzles
      // of only last 7 puzzles so that it doesn't
      // take too much time nor consume database read-writes
      final firestoreResponse = await firestore
          .collection(USER_PUZZLE_COLLECTION)
          .where("userId", isEqualTo: userId)
          .orderBy("puzzleId", descending: true)
          .limit(7)
          .getDocuments();
      // check if user has solved any puzzle
      if (firestoreResponse.documents.length > 0) {
        List<UserPuzzleModel> solvedPuzzleList = List();
        for (int i = 0; i < firestoreResponse.documents.length; i++) {
          // model the response
          final userPuzzleModel =
              UserPuzzleModel.fromJson(firestoreResponse.documents[i].data);
          solvedPuzzleList.add(userPuzzleModel);
        }
        return solvedPuzzleList;
      } else {
        // throw exception if the user hasn't solved any puzzle
        throw ServerException(message: NO_PUZZLE_SOLVED_ERROR);
      }
    } on ServerException catch (ex) {
      throw ServerException(message: ex.message);
    } catch (ex) {
      throw ServerException(message: FIREBASE_ERROR);
    }
  }

  @override
  Future<UserPuzzleModel> setPuzzleSolution(
      UserPuzzleModel userPuzzleModel) async {
    try {
      // add data if the user solves the puzzle
      await firestore
          .collection(USER_PUZZLE_COLLECTION)
          .add(userPuzzleModel.toJson());

      return userPuzzleModel;
    } catch (ex) {
      throw ServerException(message: FIREBASE_ERROR);
    }
  }
}
