import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_runway/core/errors/exceptions.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/network/network_info.dart';
import 'package:project_runway/features/tasks/data/data_sources/task_local_data_source.dart';
import 'package:project_runway/features/tasks/data/data_sources/task_remote_data_source.dart';
import 'package:project_runway/features/tasks/data/models/task_list_model.dart';
import 'package:project_runway/features/tasks/data/models/task_model.dart';
import 'package:project_runway/features/tasks/data/repositories/task_repository_impl.dart';

class MockRemoteDataSource extends Mock implements TaskRemoteDataSource {}

class MockLocalDataSource extends Mock implements TaskLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockLocalDataSource localDataSource;
  MockRemoteDataSource remoteDataSource;
  MockNetworkInfo networkInfo;
  TaskRepositoryImpl repositoryImpl;

  setUp(() {
    localDataSource = MockLocalDataSource();
    remoteDataSource = MockRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repositoryImpl = TaskRepositoryImpl(
      localDataSource: localDataSource,
      networkInfo: networkInfo,
      remoteDataSource: remoteDataSource,
    );
  });

  void isConnected(bool connected) {
    setUp(() {
      when(networkInfo.isConnected).thenAnswer((_) async => connected);
    });
  }

  group("getAllTasksForTheDate", () {
    final tRunningDate = DateTime.parse("2020-05-02 15:24:55.987577");
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

    final tTaskListModel = TaskListModel(
      isSynced: true,
      taskList: [tTaskModel],
      runningDate: tRunningDate,
    );

    group("internet is on", () {
      // turns internet on
      isConnected(true);

      test("check internet is on", () async {
        // act
        repositoryImpl.getAllTasksForTheDate(tRunningDate);
        // assert
        verify(networkInfo.isConnected);
      });

      test("should get the data from local storage", () async {
        // assemble
        // act
        await repositoryImpl.getAllTasksForTheDate(tRunningDate);
        // assert
        verify(localDataSource.getAllTasksForTheDate(tRunningDate));
      });

      test("if the call is successful, should get the data from local storage",
          () async {
        // assemble
        when(localDataSource.getAllTasksForTheDate(tRunningDate))
            .thenAnswer((_) async => tTaskListModel);
        // act
        final response =
            await repositoryImpl.getAllTasksForTheDate(tRunningDate);
        // assert
        expect(response, Right(tTaskListModel));
      });

      test(
          "should not make a call to remote data source if there is data in local storage ",
          () async {
        // assemble
        when(localDataSource.getAllTasksForTheDate(tRunningDate))
            .thenAnswer((_) async => tTaskListModel);
        // act
        await repositoryImpl.getAllTasksForTheDate(tRunningDate);
        // assert
        verifyZeroInteractions(remoteDataSource);
      });

      test("if there is no data in local storage, get data from remote storage",
          () async {
        // assemble
        when(localDataSource.getAllTasksForTheDate(tRunningDate))
            .thenThrow(CacheException());
        when(remoteDataSource.getAllTasksForTheDate(tRunningDate))
            .thenAnswer((_) async => tTaskListModel);
        // act
        final response =
            await repositoryImpl.getAllTasksForTheDate(tRunningDate);
        // assert
        expect(response, Right(tTaskListModel));
        verify(remoteDataSource.getAllTasksForTheDate(tRunningDate));
      });

      test(
          "if there is no data in local storage, and data from remote storage throws exception, return failure",
          () async {
        // assemble
        when(localDataSource.getAllTasksForTheDate(tRunningDate))
            .thenThrow(CacheException());
        when(remoteDataSource.getAllTasksForTheDate(tRunningDate))
            .thenThrow(ServerException());
        // act
        final response =
            await repositoryImpl.getAllTasksForTheDate(tRunningDate);
        // assert
        expect(response, Left(ServerFailure()));
      });
    });

    group("internet is off", () {
      isConnected(false);

      test("check internet is off", () async {
        // act
        repositoryImpl.getAllTasksForTheDate(tRunningDate);
        // assert
        verify(networkInfo.isConnected);
      });

      test("should get the data from local storage", () async {
        // assemble
        // act
        await repositoryImpl.getAllTasksForTheDate(tRunningDate);
        // assert
        verify(localDataSource.getAllTasksForTheDate(tRunningDate));
      });

      test("if the call is successful, should get the data from local storage",
          () async {
        // assemble
        when(localDataSource.getAllTasksForTheDate(tRunningDate))
            .thenAnswer((_) async => tTaskListModel);
        // act
        final response =
            await repositoryImpl.getAllTasksForTheDate(tRunningDate);
        // assert
        expect(response, Right(tTaskListModel));
      });

      test("should not make a call to remote data source ", () async {
        // assemble
        when(localDataSource.getAllTasksForTheDate(tRunningDate))
            .thenAnswer((_) async => tTaskListModel);
        // act
        await repositoryImpl.getAllTasksForTheDate(tRunningDate);
        // assert
        verifyZeroInteractions(remoteDataSource);
      });

      test("if there is no data in local storage, return a server failure",
          () async {
        // assemble
        when(localDataSource.getAllTasksForTheDate(tRunningDate))
            .thenThrow(CacheException());
        // act
        final response =
            await repositoryImpl.getAllTasksForTheDate(tRunningDate);
        // assert
        expect(response, Left(ServerFailure()));
        verifyZeroInteractions(remoteDataSource);
      });
    });
  });

  group("createTask", () {
    final tRunningDate = DateTime.parse("2020-05-02 15:24:55.987577");
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

    final tTaskModelSynced = TaskModel(
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
      isSynced: true,
      isDeleted: false,
      isMovable: false,
      isCompleted: false,
    );
    group(
      "internet is on",
      () {
        isConnected(true);
        test("checks for internet", () async {
          // act
          await repositoryImpl.createTask(tTaskModel);
          // assert
          verify(networkInfo.isConnected);
        });

        test("stores the task in local storage", () async {
          // assemble
          when(remoteDataSource.createTask(tTaskModelSynced))
              .thenAnswer((_) async => tTaskModelSynced);
          // act
          await repositoryImpl.createTask(tTaskModel);
          // assert
          verify(localDataSource.createTask(tTaskModel));
        });

        test(
          "stores the task in remote storage too",
          () async {
            // assemble
            when(remoteDataSource.createTask(tTaskModelSynced))
                .thenAnswer((_) async => tTaskModelSynced);
            // act
            await repositoryImpl.createTask(tTaskModel);
            // assert
            verify(localDataSource.createTask(tTaskModel));
            verify(remoteDataSource.createTask(tTaskModelSynced));
          },
        );

        test(
          "returns the model back",
          () async {
            // assemble
            when(remoteDataSource.createTask(tTaskModelSynced))
                .thenAnswer((_) async => tTaskModelSynced);
            // act
            final response = await repositoryImpl.createTask(tTaskModel);
            // assert
            expect(response, Right(tTaskModelSynced));
            verify(localDataSource.createTask(tTaskModel));
            verify(remoteDataSource.createTask(tTaskModelSynced));
          },
        );

        test(
          "if the call to remote data source is successful,"
          " store the object back into local storage with isSynced = true",
          () async {
            // assemble
            when(remoteDataSource.createTask(tTaskModelSynced))
                .thenAnswer((_) async => tTaskModelSynced);
            // act
            final response = await repositoryImpl.createTask(tTaskModel);
            // assert
            verify(localDataSource.createTask(tTaskModel));
            verify(remoteDataSource.createTask(tTaskModelSynced));
            verify(localDataSource.updateTask(tTaskModelSynced));
            expect(response, Right(tTaskModelSynced));
          },
        );

        test("if there is an exception, return the failure", () async {
          when(localDataSource.createTask(tTaskModel))
              .thenThrow(CacheException());
          // act
          final response = await repositoryImpl.createTask(tTaskModel);
          // assert
          expect(response, Left(CacheFailure()));
        });

        test(
          "if the call to remote data source fails,"
          " don't update the object to local data source",
          () async {
            // assemble
            when(remoteDataSource.createTask(tTaskModelSynced))
                .thenThrow(ServerException());
            // act
            final response = await repositoryImpl.createTask(tTaskModel);
            // assert
            verify(localDataSource.createTask(tTaskModel));
            verify(remoteDataSource.createTask(tTaskModelSynced));
            verifyNoMoreInteractions(localDataSource);
            expect(response, Right(tTaskModel));
          },
        );
      },
    );

    group("internet is off", () {
      isConnected(false);
      test("store the task in the local", () async {
        // act
        await repositoryImpl.createTask(tTaskModel);
        // assert
        verify(localDataSource.createTask(tTaskModel));
      });
      test("there is no call to remote data source", () async {
        await repositoryImpl.createTask(tTaskModel);
        // assert
        verify(localDataSource.createTask(tTaskModel));
      });

      test("return the data", () async {
        // assemble
        when(localDataSource.createTask(tTaskModel))
            .thenAnswer((_) async => tTaskModel);
        // act
        final response = await repositoryImpl.createTask(tTaskModel);
        // assert
        verify(localDataSource.createTask(tTaskModel));
        expect(response, Right(tTaskModelSynced));
      });

      test("return the unsynced data when firebase throws an error", () async {
        // assemble
        when(remoteDataSource.createTask(tTaskModelSynced))
            .thenThrow(ServerException());
        // act
        final response = await repositoryImpl.createTask(tTaskModel);
        // assert
        verify(localDataSource.createTask(tTaskModel));
        expect(response, Right(tTaskModel));
      });

      test("if there is an exception, return the failure", () async {
        when(localDataSource.createTask(tTaskModel))
            .thenThrow(CacheException());
        // act
        final response = await repositoryImpl.createTask(tTaskModel);
        // assert
        expect(response, Left(CacheFailure()));
      });
    });
  });

  group("readTask", () {
    final tRunningDate = DateTime.parse("2020-05-02 15:24:55.987577");
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
    final tTaskId = "uid";

    group("internet is on", () {
      isConnected(true);
      test("checks for internet", () async {
        // act
        await repositoryImpl.readTask(tTaskId);
        // assert
        verify(networkInfo.isConnected);
      });

      test("looks for the task in local data source", () async {
        // act
        await repositoryImpl.readTask(tTaskId);
        // assert
        verify(localDataSource.readTask(tTaskId));
      });

      test("task should be returned", () async {
        // assemble
        when(localDataSource.readTask(tTaskId))
            .thenAnswer((_) async => tTaskModel);
        // act
        final response = await repositoryImpl.readTask(tTaskId);
        // assert
        expect(response, Right(tTaskModel));
      });

      test("if no task is found in local storage, then search in the remote",
          () async {
        // assemble
        when(localDataSource.readTask(tTaskId)).thenThrow(CacheException());
        // act
        final response = await repositoryImpl.readTask(tTaskId);
        // assert
        verify(remoteDataSource.readTask(tTaskId));
      });

      test(
          "if no task is found in local storage, then remote data should be returned",
          () async {
        // assemble
        when(localDataSource.readTask(tTaskId)).thenThrow(CacheException());
        when(remoteDataSource.readTask(tTaskId))
            .thenAnswer((_) async => tTaskModel);
        // act
        final response = await repositoryImpl.readTask(tTaskId);
        // assert
        expect(response, Right(tTaskModel));
      });

      test(
          "if both local and remote data storage doesnot contain the task, then return failure",
          () async {
        // assemble
        when(localDataSource.readTask(tTaskId)).thenThrow(CacheException());
        when(remoteDataSource.readTask(tTaskId)).thenThrow(ServerException());
        // act
        final response = await repositoryImpl.readTask(tTaskId);
        // assert
        expect(response, Left(ServerFailure()));
      });
    });

    group("internet is off", () {
      isConnected(false);
      test("looks for the task in local data source", () async {
        // act
        await repositoryImpl.readTask(tTaskId);
        // assert
        verify(localDataSource.readTask(tTaskId));
      });

      test("task should be returned", () async {
        // assemble
        when(localDataSource.readTask(tTaskId))
            .thenAnswer((_) async => tTaskModel);
        // act
        final response = await repositoryImpl.readTask(tTaskId);
        // assert
        expect(response, Right(tTaskModel));
      });

      test("task should be returned", () async {
        // assemble
        when(localDataSource.readTask(tTaskId))
            .thenAnswer((_) async => tTaskModel);
        // act
        final response = await repositoryImpl.readTask(tTaskId);
        // assert
        expect(response, Right(tTaskModel));
      });

      test(
          "if no task is found in local storage, then failure should be returned",
          () async {
        // assemble
        when(localDataSource.readTask(tTaskId)).thenThrow(CacheException());
        // act
        final response = await repositoryImpl.readTask(tTaskId);
        // assert
        expect(response, Left(CacheFailure()));
      });
    });
  });

  group("updateTask", () {
    final tRunningDate = DateTime.parse("2020-05-02 15:24:55.987577");
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
    final tSyncedTask = TaskModel(
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
      isSynced: true,
      isDeleted: false,
      isMovable: false,
      isCompleted: false,
    );

    group("internet is on", () {
      isConnected(true);
      test("checks for internet", () async {
        // act
        await repositoryImpl.updateTask(tTaskModel);
        // assert
        verify(networkInfo.isConnected);
      });

      test("looks for the task in local data source", () async {
        // act
        await repositoryImpl.updateTask(tTaskModel);
        // assert
        verify(localDataSource.updateTask(tTaskModel));
      });

      test("task should be returned", () async {
        // assemble
        when(localDataSource.updateTask(tTaskModel))
            .thenAnswer((_) async => tTaskModel);
        // act
        final response = await repositoryImpl.updateTask(tTaskModel);
        // assert
        expect(response, Right(tTaskModel));
      });

      test("if no task is found in local storage, then search in the remote",
          () async {
        // assemble
        when(localDataSource.updateTask(tTaskModel))
            .thenThrow(CacheException());
        // act
        final response = await repositoryImpl.updateTask(tTaskModel);
        // assert
        verify(remoteDataSource.updateTask(tSyncedTask));
      });

      test(
          "if no task is found in local storage, then remote data should be returned",
          () async {
        // assemble
        when(localDataSource.updateTask(tTaskModel))
            .thenThrow(CacheException());
        when(remoteDataSource.updateTask(tSyncedTask))
            .thenAnswer((_) async => tSyncedTask);
        // act
        final response = await repositoryImpl.updateTask(tTaskModel);
        // assert
        expect(response, Right(tSyncedTask));
      });

      test(
          "if both local and remote data storage does not contain the task, then return failure",
          () async {
        // assemble
        when(localDataSource.updateTask(tTaskModel))
            .thenThrow(CacheException());
        when(remoteDataSource.updateTask(tSyncedTask))
            .thenThrow(ServerException());
        // act
        final response = await repositoryImpl.updateTask(tTaskModel);
        // assert
        expect(response, Left(ServerFailure()));
      });
    });

    group("internet is off", () {
      isConnected(false);
      test("looks for the task in local data source", () async {
        // act
        await repositoryImpl.updateTask(tTaskModel);
        // assert
        verify(localDataSource.updateTask(tTaskModel));
      });

      test("task should be returned", () async {
        // assemble
        when(localDataSource.updateTask(tTaskModel))
            .thenAnswer((_) async => tTaskModel);
        // act
        final response = await repositoryImpl.updateTask(tTaskModel);
        // assert
        expect(response, Right(tTaskModel));
      });

      test(
          "if no task is found in local storage, then failure should be returned",
          () async {
        // assemble
        when(localDataSource.updateTask(tTaskModel))
            .thenThrow(CacheException());
        // act
        final response = await repositoryImpl.updateTask(tTaskModel);
        // assert
        expect(response, Left(CacheFailure()));
      });

      test(
          "regardless of internet, task should be updated in remote storage",
              () async {
            // assemble
            when(localDataSource.updateTask(tTaskModel))
                .thenThrow(CacheException());
            // act
            final response = await repositoryImpl.updateTask(tTaskModel);
            // assert
            verify(remoteDataSource.updateTask(tSyncedTask));
          });
    });
  });
}
