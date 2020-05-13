import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/date_time_parser.dart';
import 'package:project_runway/core/errors/exceptions.dart';
import 'package:project_runway/core/keys.dart';
import 'package:project_runway/features/tasks/data/common_task_method.dart';
import 'package:project_runway/features/stats/data/models/managed_stats_model.dart';
import 'package:project_runway/features/stats/data/models/stats_model.dart';
import 'package:project_runway/features/tasks/data/models/task_list_model.dart';
import 'package:project_runway/features/tasks/data/models/task_model.dart';
import 'package:project_runway/features/tasks/domain/entities/task_list_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TaskRemoteDataSource {
  Future<TaskListModel> getAllTasksForTheDate(DateTime runningDate);
  Future<TaskModel> createTask(TaskModel taskModel);
  Future<TaskModel> updateTask(TaskModel taskModel);
  Future<TaskModel> deleteTask(TaskModel taskModel);
  Future<TaskModel> completeTask(TaskModel taskModel);
  Future<TaskModel> readTask(String taskId);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final Firestore firestore;
  final SharedPreferences sharedPreferences;
  static const taskCollection = TASK_COLLECTION;

  TaskRemoteDataSourceImpl({
    @required this.firestore,
    @required this.sharedPreferences,
  });

  @override
  Future<TaskModel> createTask(TaskModel taskModel) async {
    try {
      // check if the user key is present inside the
      // shared preferences
      if (!sharedPreferences.containsKey(USER_KEY)) {
        throw ServerException(
            message:
                "Sorry, User key not found. Please login again into the app");
      }
      // add user id from the shared preferences
      final task = _addUserId(taskModel);
      final syncedTask = markTaskAsSynced(task);
      // create the document
      final uploadedDocument =
          await firestore.collection(taskCollection).add(syncedTask.toJson());
      // Do not wait for this to finish
      // Update the task id into the database
      await firestore
          .collection(taskCollection)
          .document(uploadedDocument.documentID)
          .updateData({"taskId": uploadedDocument.documentID});
      // add this taskId into the model
      final response = _updateTaskId(task, uploadedDocument.documentID);
      return response;
    } on Exception {
      throw ServerException(message: "Error occurred during task transaction");
    }
  }

  @override
  Future<TaskModel> deleteTask(TaskModel taskModel) async {
    try {
      initialChecks(taskModel);
      // add user id from the shared preferences
      final task = _addUserId(taskModel);
      final syncedTask = markTaskAsSynced(task);
      // update the document for isDeleted = true
      firestore
          .collection(taskCollection)
          .document(syncedTask.taskId)
          .updateData({"isDeleted": true});
      // update the model with isDeleted = true
      final response = _updateIsDeleted(syncedTask);
      return response;
    } on Exception {
      throw ServerException(message: "Error occurred during task transaction");
    }
  }

  @override
  Future<TaskListModel> getAllTasksForTheDate(DateTime runningDate) async {
    try {
      // checking for the nullability of running date
      if (runningDate == null) {
        throw ServerException(
            message: "Sorry, some error occurred"
                " Please login into the app again");
      }
      // checking for null user key
      if (!sharedPreferences.containsKey(USER_KEY)) {
        throw ServerException(
            message:
                "Sorry, User key not found. Please login again into the app");
      }
      final documentList = await firestore
          .collection(taskCollection)
          .where("userId", isEqualTo: sharedPreferences.getString(USER_KEY))
          .where("runningDate", isEqualTo: dateToStringParser(runningDate))
          .where("isDeleted", isEqualTo: false)
          .getDocuments();
      List<TaskModel> taskList = List();
      // collecting all the documents
      for (int i = 0; i < documentList.documents.length; i++) {
        final response = TaskModel.fromJson(documentList.documents[i].data);
        taskList.add(response);
      }
      print("in remote ${taskList.length}");
      // mark the list in shared preferences as synced
      final response = TaskListModel(
        isSynced: true,
        taskList: taskList,
        runningDate: runningDate,
      );
      return response;
    } on Exception {
      throw ServerException(message: "Error occurred during task transaction");
    }
  }

  @override
  Future<TaskModel> readTask(String taskId) async {
    try {
      if (taskId == null || taskId.isEmpty) {
        throw ServerException(
            message: "Sorry, task not found."
                " Please login again into the app");
      }
      // find the document for taskId = x
      final documentReference =
          await firestore.collection(taskCollection).document(taskId).get();

      // convert the document to task
      final response = TaskModel.fromJson(documentReference.data);
      return response;
    } on Exception {
      throw ServerException(message: "Error occurred during task transaction");
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel taskModel) async {
    try {
      initialChecks(taskModel);
      // add user id from the shared preferences
      final task = _addUserId(taskModel);
      final syncedTask = markTaskAsSynced(task);

      firestore
          .collection(taskCollection)
          .document(syncedTask.taskId)
          .updateData(syncedTask.toJson());
      return syncedTask;
    } on Exception catch (ex) {
      throw ServerException(message: "Error occurred during task transaction");
    }
  }

  @override
  Future<TaskModel> completeTask(TaskModel taskModel) async {
    try {
      initialChecks(taskModel);
      // add user id from the shared preferences
      final task = _addUserId(taskModel);
      final syncedTask = markTaskAsSynced(task);

      final firestoreDocument = await firestore
          .collection(taskCollection)
          .document(taskModel.taskId)
          .get();
      final firestoreTask = TaskModel.fromJson(firestoreDocument.data);
      final response =
          markTaskAsCompleted(firestoreTask, !firestoreTask.isCompleted);
      // update last Updated time
      response.lastUpdatedAt = taskModel.lastUpdatedAt;
      firestore
          .collection(taskCollection)
          .document(response.taskId)
          .updateData(response.toJson());
      return response;
    } on Exception catch (ex) {
      throw ServerException(message: "Error occurred during task transaction");
    }
  }

  void initialChecks(TaskModel task) {
    if (!sharedPreferences.containsKey(USER_KEY)) {
      throw ServerException(
          message:
              "Sorry, User key not found. Please login again into the app");
    }
    if (task.taskId == null ||
        task.taskId.isEmpty ||
        task.userId == null ||
        task.userId.isEmpty) {
      throw ServerException(
          message: "Sorry, User or the task not found."
              " Please login again into the app");
    }
  }

  TaskModel _addUserId(TaskModel oldTask) {
    Map<String, dynamic> taskMap = oldTask.toJson();
    taskMap.update("userId", (value) => sharedPreferences.getString(USER_KEY),
        ifAbsent: () => sharedPreferences.getString(USER_KEY));
    final updatedTask = TaskModel.fromJson(taskMap);
    return updatedTask;
  }

  TaskModel _updateTaskId(TaskModel oldTask, String taskId) {
    Map<String, dynamic> taskMap = oldTask.toJson();
    taskMap.update("taskId", (value) => taskId, ifAbsent: () => taskId);
    final syncedTask = TaskModel.fromJson(taskMap);
    return syncedTask;
  }

  TaskModel _updateIsDeleted(TaskModel task) {
    Map<String, dynamic> taskMap = task.toJson();
    taskMap.update("isDeleted", (value) => true, ifAbsent: () => true);
    final updatedTask = TaskModel.fromJson(taskMap);
    return updatedTask;
  }
}
