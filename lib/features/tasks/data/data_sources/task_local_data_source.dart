import 'package:project_runway/features/tasks/data/models/task_list_model.dart';
import 'package:project_runway/features/tasks/data/models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<TaskListModel> getAllTasksForTheDate(DateTime runningDate);
  Future<TaskModel> createTask(TaskModel taskModel);
  Future<TaskModel> updateTask(TaskModel taskModel);
  Future<TaskModel> deleteTask(TaskModel taskModel);
  Future<TaskModel> readTask(String taskId);
  Future<TaskModel> completeTask(TaskModel taskModel);
}