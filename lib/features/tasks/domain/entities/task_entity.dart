import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class TaskEntity extends Equatable {
  String userId;
  String taskId;
  String taskTitle;
  String description;
  // defines a score to task
  int urgency;
  // defines a type to task
  String tag;
  // when to update about the task
  DateTime notificationTime;
  DateTime createdAt;
  // will be same as createdAt when created
  // If the object is moved to the next day
  // the running date will be changed
  DateTime runningDate;
  DateTime lastUpdatedAt;
  bool isSynced;
  bool isDeleted;
  bool isMovable;
  bool isCompleted;

  TaskEntity({
    @required this.userId,
    @required this.taskId,
    @required this.taskTitle,
    @required this.description,
    @required this.urgency,
    @required this.tag,
    @required this.notificationTime,
    @required this.createdAt,
    @required this.runningDate,
    @required this.lastUpdatedAt,
    @required this.isSynced,
    @required this.isDeleted,
    @required this.isMovable,
    @required this.isCompleted,
  });

  @override
  List<Object> get props => [
        userId,
        taskId,
        taskTitle,
        description,
        urgency,
        tag,
        notificationTime,
        createdAt,
        runningDate,
        lastUpdatedAt,
        isSynced,
        isDeleted,
        isMovable,
        isCompleted,
      ];

  @override
  bool get stringify => true;
}
