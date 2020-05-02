import 'package:flutter/widgets.dart';
import 'package:project_runway/core/date_time_parser.dart';
import 'package:project_runway/features/tasks/data/models/task_model.dart';
import 'package:project_runway/features/tasks/domain/entities/task_list_entity.dart';

class TaskListModel extends TaskListEntity {
  TaskListModel({
    @required bool isSuccess,
    @required List<TaskModel> taskList,
    @required DateTime runningDate,
  }) : super(
          isSuccess: isSuccess,
          taskList: taskList,
          runningDate: runningDate,
        );

  factory TaskListModel.fromJson(Map<String, dynamic> map) {
    final List<TaskModel> taskList = List();
    final List<dynamic> mapList = map["taskList"];
    for(int i = 0; i < mapList.length; i++) {
      final taskResponse = TaskModel.fromJson(mapList[i]);
      taskList.add(taskResponse);
    }
    return TaskListModel(
      isSuccess: map["isSuccess"],
      taskList: taskList,
      runningDate: dateParser(map["runningDate"]),
    );
  }

  Map<String, dynamic> toJson() {
    final List<dynamic> mapList = [];
    for(int i = 0; i < taskList.length; i++) {
      final taskResponse = (taskList[i] as TaskModel).toJson();
      mapList.add(taskResponse);
    }
    return {
      "isSuccess": isSuccess,
      "taskList": mapList,
      "runningDate": dateToStringParser(runningDate),
    };
  }
}
