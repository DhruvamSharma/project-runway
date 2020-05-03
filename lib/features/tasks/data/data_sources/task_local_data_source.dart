import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:project_runway/core/date_time_parser.dart';
import 'package:project_runway/core/errors/exceptions.dart';
import 'package:project_runway/features/tasks/data/common_task_method.dart';
import 'package:project_runway/features/tasks/data/models/task_list_model.dart';
import 'package:project_runway/features/tasks/data/models/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TaskLocalDataSource {
  Future<TaskListModel> getAllTasksForTheDate(DateTime runningDate);
  Future<TaskModel> createTask(TaskModel taskModel);
  Future<TaskModel> updateTask(TaskModel taskModel);
  Future<TaskModel> deleteTask(TaskModel taskModel);
  Future<TaskModel> readTask(String taskId);
  Future<TaskModel> completeTask(String taskId);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final SharedPreferences sharedPreferences;

  TaskLocalDataSourceImpl({
    @required this.sharedPreferences,
  });

  @override
  Future<TaskModel> completeTask(String taskId) async {
    // only for firebase based solution
    throw CacheException(message: "only for firebase based solution");
  }

  @override
  Future<TaskModel> createTask(TaskModel taskModel) {
    try {
      final taskListKey = dateToStringParser(taskModel.runningDate);
      final taskListString = sharedPreferences.getString(taskListKey);
      TaskListModel taskListModel;
      if (taskListString == null) {
        taskListModel = TaskListModel(
          isSynced: false,
          taskList: [taskModel],
          runningDate: taskModel.runningDate,
        );
      } else {
        final Map<String, dynamic> taskMap = json.decode(taskListString);
        taskListModel = TaskListModel.fromJson(taskMap);
        taskListModel.taskList.add(taskModel);
      }
      sharedPreferences.setString(
          taskListKey, json.encode(taskListModel.toJson()));
      return Future.value(taskModel);
    } on Exception {
      throw CacheException(message: "Failed: Creating a task failed");
    }
  }

  @override
  Future<TaskModel> deleteTask(TaskModel taskModel) {

    if (taskModel.isDeleted) {
      return Future.value(taskModel);
    }

    try {
      final taskListKey = dateToStringParser(taskModel.runningDate);
      final taskListString = sharedPreferences.getString(taskListKey);
      TaskListModel taskListModel;
      if (taskListString == null || taskListString.isEmpty) {
        throw CacheException(message: "Failed: No data found to delete");
      } else {
        final Map<String, dynamic> taskMap = json.decode(taskListString);
        taskListModel = TaskListModel.fromJson(taskMap);
        taskListModel.taskList.remove(taskModel);
      }
      taskListModel = markTaskListAsSynced(taskListModel, false);
      sharedPreferences.setString(
          taskListKey, json.encode(taskListModel.toJson()));
      final deletedTask = markTaskAsDeleted(taskModel);
      return Future.value(deletedTask);
    } on Exception {
      throw CacheException(message: "Failed: Deleting a task failed");
    }
  }

  @override
  Future<TaskListModel> getAllTasksForTheDate(DateTime runningDate) async {
    try {
      final taskListKey = dateToStringParser(runningDate);
      final taskListString = sharedPreferences.getString(taskListKey);
      TaskListModel taskListModel;
      if (taskListString == null || taskListString.isEmpty) {
        taskListModel = TaskListModel(
          isSynced: false,
          taskList: [],
          runningDate: runningDate,
        );
      } else {
        final Map<String, dynamic> taskMap = json.decode(taskListString);
        taskListModel = TaskListModel.fromJson(taskMap);
      }
      return Future.value(taskListModel);
    } on Exception {
      throw CacheException(message: "Failed: Deleting a task failed");
    }
  }

  @override
  Future<TaskModel> readTask(String taskId) {
    // Only firebase based. No local solution
    throw CacheException(message: "Only firebase based. No local solution");
  }

  @override
  Future<TaskModel> updateTask(TaskModel taskModel) {
    try {
      final taskListKey = dateToStringParser(taskModel.runningDate);
      final taskListString = sharedPreferences.getString(taskListKey);
      TaskListModel taskListModel;
      if (taskListString == null || taskListString.isEmpty) {
        throw CacheException(message: "Failed: No data found to update");
      } else {
        final Map<String, dynamic> taskMap = json.decode(taskListString);
        taskListModel = TaskListModel.fromJson(taskMap);
        for (int i = 0; i < taskListModel.taskList.length; i ++) {
          if(taskListModel.taskList[i].taskId == taskModel.taskId) {
            taskListModel.taskList.removeAt(i);
            taskListModel.taskList.add(taskModel);
            break;
          }
        }
        sharedPreferences.setString(
            taskListKey, json.encode(taskListModel.toJson()));
      }
      return Future.value(taskModel);
    } on Exception {
      throw CacheException(message: "Failed: Deleting a task failed");
    }
  }
}
