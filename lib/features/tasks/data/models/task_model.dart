import 'package:flutter/material.dart';
import 'package:project_runway/core/date_time_parser.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  TaskModel({
    @required String userId,
    @required String taskId,
    @required String taskTitle,
    @required String description,
    @required int urgency,
    @required String tag,
    @required DateTime notificationTime,
    @required DateTime createdAt,
    @required DateTime runningDate,
    @required DateTime lastUpdatedAt,
    @required bool isSynced,
    @required bool isDeleted,
    @required bool isMovable,
    @required bool isCompleted,
  }) : super(
          taskId: taskId,
          userId: userId,
          taskTitle: taskTitle,
          description: description,
          urgency: urgency,
          tag: tag,
          notificationTime: notificationTime,
          createdAt: createdAt,
          runningDate: runningDate,
          lastUpdatedAt: lastUpdatedAt,
          isSynced: isSynced,
          isDeleted: isDeleted,
          isMovable: isMovable,
          isCompleted: isCompleted,
        );

  factory TaskModel.fromJson(Map<String, dynamic> map) {
    return TaskModel(
      userId: map["userId"],
      taskId: map["taskId"],
      taskTitle: map["taskTitle"],
      description: map["description"],
      urgency: map["urgency"],
      tag: map["tag"],
      notificationTime: dateParser(map["notificationTime"]),
      createdAt: dateParser(map["createdAt"]),
      runningDate: dateParser(map["runningDate"]),
      lastUpdatedAt: dateParser(map["lastUpdatedAt"]),
      isSynced: map["isSynced"],
      isDeleted: map["isDeleted"],
      isMovable: map["isMovable"],
      isCompleted: map["isCompleted"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": "uid",
      "taskId": "tid",
      "taskTitle": "tTitle",
      "description": "tDescription",
      "urgency": 2,
      "tag": "rag",
      "notificationTime": dateToStringParser(notificationTime),
      "createdAt": dateToStringParser(createdAt),
      "runningDate": dateToStringParser(runningDate),
      "lastUpdatedAt": dateToStringParser(lastUpdatedAt),
      "isSynced": isSynced,
      "isDeleted": isDeleted,
      "isMovable": isMovable,
      "isCompleted": isCompleted
    };
  }
}
