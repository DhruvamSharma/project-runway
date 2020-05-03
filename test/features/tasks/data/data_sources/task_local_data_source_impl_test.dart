import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_runway/core/errors/exceptions.dart';
import 'package:project_runway/features/tasks/data/data_sources/task_local_data_source.dart';
import 'package:project_runway/features/tasks/data/models/task_list_model.dart';
import 'package:project_runway/features/tasks/data/models/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences sharedPreferences;
  TaskLocalDataSourceImpl localDataSourceImpl;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
    localDataSourceImpl = TaskLocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
    );
  });

  group("createTask", () {
    final tTaskModel = TaskModel(
      userId: "Dhruvam",
      taskId: null,
      taskTitle: "tTitle",
      description: "tDescription",
      urgency: 2,
      tag: "rag",
      notificationTime: DateTime.parse("2020-05-02 15:24:55.987577"),
      createdAt: DateTime.parse("2020-05-02 15:24:55.987577"),
      runningDate: DateTime.parse("2020-05-02 15:24:55.987577"),
      lastUpdatedAt: DateTime.parse("2020-05-02 15:24:55.987577"),
      isSynced: false,
      isDeleted: false,
      isMovable: false,
      isCompleted: false,
    );

    final tTaskModel2 = TaskModel(
      userId: "Dhruvam",
      taskId: null,
      taskTitle: "tTitle_2",
      description: "tDescription",
      urgency: 2,
      tag: "rag",
      notificationTime: DateTime.parse("2020-05-02 15:24:55.987577"),
      createdAt: DateTime.parse("2020-05-02 15:24:55.987577"),
      runningDate: DateTime.parse("2020-05-02 15:24:55.987577"),
      lastUpdatedAt: DateTime.parse("2020-05-02 15:24:55.987577"),
      isSynced: false,
      isDeleted: false,
      isMovable: false,
      isCompleted: false,
    );

    final tTaskListModel = TaskListModel(
      isSynced: true,
      taskList: [tTaskModel, tTaskModel2],
      runningDate: DateTime.parse("2020-05-02 15:24:55.987577"),
    );

    final tInitialTaskListModel = TaskListModel(
      isSynced: false,
      taskList: [tTaskModel2],
      runningDate: DateTime.parse("2020-05-02 15:24:55.987577"),
    );

    test("shared preferences should be called with proper arguments", () {
      // assemble
      when(sharedPreferences.getString("2020-05-02 15:24:55.987577"))
          .thenReturn(fixture("task_list_model.json"));
      // act
      localDataSourceImpl.createTask(tTaskModel2);
      // assert
      verify(sharedPreferences.setString(
        "2020-05-02 15:24:55.987577",
        json.encode(tTaskListModel.toJson()),
      ));
    });

    test("if no item is found, create a new list", () {
      // assemble
      when(sharedPreferences.getString("2020-05-02 15:24:55.987577"))
          .thenReturn(null);
      // act
      localDataSourceImpl.createTask(tTaskModel2);
      // assert
      verify(sharedPreferences.setString(
        "2020-05-02 15:24:55.987577",
        json.encode(tInitialTaskListModel.toJson()),
      ));
    });

    test("if there is an error, throw cache exception", () {
      // assemble
      when(sharedPreferences.getString("2020-05-02 15:24:55.987577"))
          .thenThrow(Exception());
      // act
      final responseCall = localDataSourceImpl.createTask;
      // assert
      expect(() => responseCall(tTaskModel2),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("deleteTask", () {
    final tTaskModel = TaskModel(
      userId: "uid",
      taskId: "tid",
      taskTitle: "tTitle",
      description: "tDescription",
      urgency: 2,
      tag: "rag",
      notificationTime: DateTime.parse("2020-05-02 15:24:55.987577"),
      createdAt: DateTime.parse("2020-05-02 15:24:55.987577"),
      runningDate: DateTime.parse("2020-05-02 15:24:55.987577"),
      lastUpdatedAt: DateTime.parse("2020-05-02 15:24:55.987577"),
      isSynced: false,
      isDeleted: false,
      isMovable: false,
      isCompleted: false,
    );

    final tTaskModel2 = TaskModel(
      userId: "Dhruvam",
      taskId: null,
      taskTitle: "tTitle_2",
      description: "tDescription",
      urgency: 2,
      tag: "rag",
      notificationTime: DateTime.parse("2020-05-02 15:24:55.987577"),
      createdAt: DateTime.parse("2020-05-02 15:24:55.987577"),
      runningDate: DateTime.parse("2020-05-02 15:24:55.987577"),
      lastUpdatedAt: DateTime.parse("2020-05-02 15:24:55.987577"),
      isSynced: false,
      isDeleted: false,
      isMovable: false,
      isCompleted: false,
    );

    final tTaskListModel = TaskListModel(
      isSynced: true,
      taskList: [tTaskModel, tTaskModel2],
      runningDate: DateTime.parse("2020-05-02 15:24:55.987577"),
    );

    final tInitialTaskListModel = TaskListModel(
      isSynced: false,
      taskList: [],
      runningDate: DateTime.parse("2020-05-02 15:24:55.987577"),
    );

    test("shared preferences should be called with proper arguments", () {
      // assemble
      when(sharedPreferences.getString(any))
          .thenReturn(fixture("task_list_model.json"));
      final stringToStore = json.encode(tInitialTaskListModel.toJson());
      // act
      localDataSourceImpl.deleteTask(tTaskModel);
      // assert
      verify(sharedPreferences.setString(
        "2020-05-02 15:24:55.987577",
        stringToStore,
      ));
    });

    test("if no item is found, throw exception", () {
      // assemble
      when(sharedPreferences.getString("2020-05-02 15:24:55.987577"))
          .thenReturn(null);
      // act
      final responseCall = localDataSourceImpl.deleteTask;
      // assert
      expect(() => responseCall(tTaskModel2),
          throwsA(TypeMatcher<CacheException>()));
    });

    test("if there is an error, throw cache exception", () {
      // assemble
      when(sharedPreferences.getString("2020-05-02 15:24:55.987577"))
          .thenThrow(Exception());
      // act
      final responseCall = localDataSourceImpl.createTask;
      // assert
      expect(() => responseCall(tTaskModel2),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("getAllTaskForTheDate", () {
    final tTaskModel = TaskModel(
      userId: "uid",
      taskId: "tid",
      taskTitle: "tTitle",
      description: "tDescription",
      urgency: 2,
      tag: "rag",
      notificationTime: DateTime.parse("2020-05-02 15:24:55.987577"),
      createdAt: DateTime.parse("2020-05-02 15:24:55.987577"),
      runningDate: DateTime.parse("2020-05-02 15:24:55.987577"),
      lastUpdatedAt: DateTime.parse("2020-05-02 15:24:55.987577"),
      isSynced: false,
      isDeleted: false,
      isMovable: false,
      isCompleted: false,
    );

    final tTaskModel2 = TaskModel(
      userId: "Dhruvam",
      taskId: null,
      taskTitle: "tTitle_2",
      description: "tDescription",
      urgency: 2,
      tag: "rag",
      notificationTime: DateTime.parse("2020-05-02 15:24:55.987577"),
      createdAt: DateTime.parse("2020-05-02 15:24:55.987577"),
      runningDate: DateTime.parse("2020-05-02 15:24:55.987577"),
      lastUpdatedAt: DateTime.parse("2020-05-02 15:24:55.987577"),
      isSynced: false,
      isDeleted: false,
      isMovable: false,
      isCompleted: false,
    );

    final tRunningDate = DateTime.parse("2020-05-02 15:24:55.987577");

    final tTaskListModel = TaskListModel(
      isSynced: true,
      taskList: [tTaskModel],
      runningDate: DateTime.parse("2020-05-02 15:24:55.987577"),
    );

    final tInitialTaskListModel = TaskListModel(
      isSynced: false,
      taskList: [],
      runningDate: DateTime.parse("2020-05-02 15:24:55.987577"),
    );

    test("correct data should be returned", () async {
      // assemble
      when(sharedPreferences.getString(any))
          .thenReturn(fixture("task_list_model.json"));
      final stringToStore = json.encode(tTaskListModel.toJson());
      // act
      final response =
          await localDataSourceImpl.getAllTasksForTheDate(tRunningDate);
      // assert
      expect(response, tTaskListModel);
    });

    test("if no item is found, return an empty list", () async {
      // assemble
      when(sharedPreferences.getString("2020-05-02 15:24:55.987577"))
          .thenReturn(null);
      // act
      final response =
          await localDataSourceImpl.getAllTasksForTheDate(tRunningDate);
      // assert
      expect(response, tInitialTaskListModel);
    });

    test("if there is an error, throw cache exception", () {
      // assemble
      when(sharedPreferences.getString("2020-05-02 15:24:55.987577"))
          .thenThrow(Exception());
      // act
      final responseCall = localDataSourceImpl.createTask;
      // assert
      expect(() => responseCall(tTaskModel2),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("updateTask", () {
    final tTaskModel = TaskModel(
      userId: "uid",
      taskId: "tid",
      taskTitle: "tTitle",
      description: "tDescription",
      urgency: 2,
      tag: "rag",
      notificationTime: DateTime.parse("2020-05-02 15:24:55.987577"),
      createdAt: DateTime.parse("2020-05-02 15:24:55.987577"),
      runningDate: DateTime.parse("2020-05-02 15:24:55.987577"),
      lastUpdatedAt: DateTime.parse("2020-05-02 15:24:55.987577"),
      isSynced: false,
      isDeleted: false,
      isMovable: false,
      isCompleted: false,
    );

    final tTaskModel2 = TaskModel(
      userId: "Dhruvam",
      taskId: null,
      taskTitle: "tTitle_2",
      description: "tDescription",
      urgency: 2,
      tag: "rag",
      notificationTime: DateTime.parse("2020-05-02 15:24:55.987577"),
      createdAt: DateTime.parse("2020-05-02 15:24:55.987577"),
      runningDate: DateTime.parse("2020-05-02 15:24:55.987577"),
      lastUpdatedAt: DateTime.parse("2020-05-02 15:24:55.987577"),
      isSynced: false,
      isDeleted: false,
      isMovable: false,
      isCompleted: false,
    );

    final tTaskListModel = TaskListModel(
      isSynced: true,
      taskList: [
        tTaskModel,
      ],
      runningDate: DateTime.parse("2020-05-02 15:24:55.987577"),
    );

    final tInitialTaskListModel = TaskListModel(
      isSynced: true,
      taskList: [tTaskModel2],
      runningDate: DateTime.parse("2020-05-02 15:24:55.987577"),
    );

    test("shared preferences should be called with proper arguments", () {
      // assemble
      when(sharedPreferences.getString(any))
          .thenReturn(fixture("task_list_model.json"));
      final stringToStore = json.encode(tInitialTaskListModel.toJson());
      // act
      localDataSourceImpl.updateTask(tTaskModel2);
      // assert
      verify(sharedPreferences.setString(
        "2020-05-02 15:24:55.987577",
        stringToStore,
      ));
    });

    test("if no item is found, throw exception", () {
      // assemble
      when(sharedPreferences.getString("2020-05-02 15:24:55.987577"))
          .thenReturn(null);
      // act
      final responseCall = localDataSourceImpl.updateTask;
      // assert
      expect(() => responseCall(tTaskModel2),
          throwsA(TypeMatcher<CacheException>()));
    });

    test("if there is an error, throw cache exception", () {
      // assemble
      when(sharedPreferences.getString("2020-05-02 15:24:55.987577"))
          .thenThrow(Exception());
      // act
      final responseCall = localDataSourceImpl.updateTask;
      // assert
      expect(() => responseCall(tTaskModel2),
          throwsA(TypeMatcher<CacheException>()));
    });
  });
}
