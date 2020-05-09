import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:project_runway/features/tasks/data/data_sources/task_local_data_source.dart';
import 'package:project_runway/features/tasks/data/data_sources/task_remote_data_source.dart';
import 'package:project_runway/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:project_runway/features/tasks/domain/repositories/task_repository.dart';
import 'package:project_runway/features/tasks/domain/use_cases/complete_task_use_case.dart';
import 'package:project_runway/features/tasks/domain/use_cases/create_task_use_case.dart';
import 'package:project_runway/features/tasks/domain/use_cases/delete_task_use_case.dart';
import 'package:project_runway/features/tasks/domain/use_cases/get_all_tasks_for_date_use_case.dart';
import 'package:project_runway/features/tasks/domain/use_cases/read_task_use_case.dart';
import 'package:project_runway/features/tasks/domain/use_cases/update_task_use_case.dart';
import 'package:project_runway/features/tasks/presentation/manager/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'network/network_info.dart';

final sl = GetIt.instance;

Future<void> serviceLocatorInit() async {
  taskInjection();

  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectionChecker: sl()));

  // External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerLazySingleton(() => Firestore.instance);
}

void taskInjection() {
  // bloc
  sl.registerFactory(() => HomeScreenTaskBloc(
        updateTaskUseCase: sl(),
        allTasksForDateUseCase: sl(),
        completeTaskUseCase: sl(),
        createTaskUseCase: sl(),
      ));
  // usecase
  sl.registerLazySingleton(() => GetAllTasksForDateUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetReadTaskUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCompleteTaskUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetDeleteTaskUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCreateTaskUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetUpdateTaskUseCase(repository: sl()));
  // repository
  sl.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        networkInfo: sl(),
      ));
  // data sources
  sl.registerLazySingleton<TaskRemoteDataSource>(() => TaskRemoteDataSourceImpl(
        sharedPreferences: sl(),
        firestore: sl(),
      ));
  sl.registerLazySingleton<TaskLocalDataSource>(() => TaskLocalDataSourceImpl(
        sharedPreferences: sl(),
      ));
}
