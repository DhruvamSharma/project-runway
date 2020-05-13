import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/errors/exceptions.dart';
import 'package:project_runway/core/keys.dart';
import 'package:project_runway/features/stats/data/models/managed_stats_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class StatsRemoteDataSource {
  Future<ManagedStatsTable> fetchStatsTable();
  void addTaskAndIncrementScore(DateTime runningDate, int urgency);
  void deleteTaskAndDecrementScore(DateTime runningDate, int urgency);
  void completeTaskAndUpdateScore(
      DateTime runningDate, bool isCompleted, int urgency);
  Future<bool> addScore(int score);
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
      final statsModel = ManagedStatsTable.fromJson(statsData.data);
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
}
