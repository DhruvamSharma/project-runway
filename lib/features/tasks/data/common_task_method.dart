import 'package:project_runway/features/tasks/data/models/task_list_model.dart';

import 'models/task_model.dart';

TaskModel markTaskAsSynced(TaskModel task, [bool isSynced]) {
  Map<String, dynamic> taskMap = task.toJson();
  taskMap.update("isSynced", (value) => isSynced?? true, ifAbsent: () => isSynced?? false);
  final syncedTask = TaskModel.fromJson(taskMap);
  return syncedTask;
}

TaskListModel markTaskListAsSynced(TaskListModel taskList, [bool isSynced]) {
  Map<String, dynamic> taskMap = taskList.toJson();
  taskMap.update("isSynced", (value) => isSynced?? true, ifAbsent: () => isSynced?? false);
  final syncedTask = TaskListModel.fromJson(taskMap);
  return syncedTask;
}

TaskModel markTaskAsCompleted(TaskModel task, [bool isCompleted]) {
  Map<String, dynamic> taskMap = task.toJson();
  taskMap.update("isCompleted", (value) => isCompleted?? true, ifAbsent: () => isCompleted?? false);
  final syncedTask = TaskModel.fromJson(taskMap);
  return syncedTask;
}

TaskModel markTaskAsDeleted(TaskModel task) {
  Map<String, dynamic> taskMap = task.toJson();
  taskMap.update("isDeleted", (value) => true, ifAbsent: () => false);
  final syncedTask = TaskModel.fromJson(taskMap);
  return syncedTask;
}