import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:project_runway/features/login/data/data_sources/user_local_data_source.dart';
import 'package:project_runway/features/login/data/data_sources/user_remote_data_source.dart';
import 'package:project_runway/features/login/data/repositories/user_repository_impl.dart';
import 'package:project_runway/features/login/domain/repositories/user_repository.dart';
import 'package:project_runway/features/login/domain/use_cases/create_user_use_case.dart';
import 'package:project_runway/features/login/domain/use_cases/read_user_use_case.dart';
import 'package:project_runway/features/login/presentation/manager/bloc.dart';
import 'package:project_runway/features/stats/data/data_sources/stats_remote_data_source.dart';
import 'package:project_runway/features/stats/data/repositories/stats_repository_impl.dart';
import 'package:project_runway/features/stats/domain/repositories/stats_repository.dart';
import 'package:project_runway/features/stats/domain/use_cases/add_score_use_case.dart';
import 'package:project_runway/features/stats/domain/use_cases/get_puzzle_solved_list_use_case.dart';
import 'package:project_runway/features/stats/domain/use_cases/get_puzzle_use_case.dart';
import 'package:project_runway/features/stats/domain/use_cases/get_stats_table_use_case.dart';
import 'package:project_runway/features/stats/domain/use_cases/set_puzzle_solution_use_case.dart';
import 'package:project_runway/features/stats/presentation/manager/stats_bloc.dart';
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
import 'package:uuid/uuid.dart';

import 'network/network_info.dart';

final sl = GetIt.instance;
SharedPreferences sharedPreferences;

Future<void> serviceLocatorInit() async {
  taskInjection();

  loginInjection();

  statsInjection();

  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectionChecker: sl()));

  // External Dependencies
  sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerLazySingleton(() => Firestore.instance);
  sl.registerLazySingleton(() => Uuid());
}

void statsInjection() {
  // bloc
  sl.registerFactory(() => StatsBloc(
        getPuzzleSolvedListUseCase: sl(),
        setPuzzleSolutionUseCase: sl(),
        getPuzzleUseCase: sl(),
        statsTableUseCase: sl(),
        addScoreUseCase: sl(),
      ));
  // use case
  sl.registerLazySingleton(() => GetStatsTableUseCase(repository: sl()));
  sl.registerLazySingleton(() => AddScoreUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetPuzzleUseCase(repository: sl()));
  sl.registerLazySingleton(() => SetPuzzleSolutionUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetPuzzleSolvedListUseCase(repository: sl()));
  // repository
  sl.registerLazySingleton<StatsRepository>(() => StatsRepositoryImpl(
        networkInfo: sl(),
        remoteDataSource: sl(),
      ));
  // data sources
  sl.registerLazySingleton<StatsRemoteDataSource>(
      () => StatsRemoteDataSourceImpl(
            sharedPreferences: sl(),
            firestore: sl(),
          ));
}

void loginInjection() {
  // bloc
  sl.registerFactory(() => LoginBloc(
        loginUserUseCase: sl(),
        findUserUseCase: sl(),
      ));
  // use case
  sl.registerLazySingleton(() => ReadUserUseCase(repository: sl()));
  sl.registerLazySingleton(() => CreateUserUseCase(repository: sl()));
  // repository
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        networkInfo: sl(),
        uuid: sl(),
      ));
  // data sources
  sl.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(
        sharedPreferences: sl(),
        firestore: sl(),
      ));
  sl.registerLazySingleton<UserLocalDataSource>(() => UserLocalDataSourceImpl(
        sharedPreferences: sl(),
      ));
}

void taskInjection() {
  // bloc
  sl.registerFactory(() => HomeScreenTaskBloc(
        updateTaskUseCase: sl(),
        allTasksForDateUseCase: sl(),
        completeTaskUseCase: sl(),
        createTaskUseCase: sl(),
        deleteTaskUseCase: sl(),
      ));
  // use case
  sl.registerLazySingleton(() => GetAllTasksForDateUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetReadTaskUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCompleteTaskUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetDeleteTaskUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCreateTaskUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetUpdateTaskUseCase(repository: sl()));
  // repository
  sl.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
        statsRemoteDataSource: sl(),
      ));
  // data sources
  sl.registerLazySingleton<TaskRemoteDataSource>(() => TaskRemoteDataSourceImpl(
        sharedPreferences: sl(),
        firestore: sl(),
      ));
}
