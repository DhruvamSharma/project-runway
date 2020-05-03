import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:project_runway/features/tasks/data/models/task_model.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {

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


  test("task_model is a type of task_entity", () {
    // assert
    expect(tTaskModel, isA<TaskEntity>());
  });

  test("task_model is successfullu converted to a map with toJson", () {
    // assemble
    final Map<String, dynamic> map = json.decode(fixture("task_model.json"));
    // act
    final response = TaskModel.fromJson(map);
    // assert
    expect(response, tTaskModel);
  });

  test("task_model is successfullu converted from a map with fromJson", () {
    // assemble
    final Map<String, dynamic> map = json.decode(fixture("task_model.json"));
    // act
    final response = tTaskModel.toJson();
    // assert
    expect(response, map);
  });
}