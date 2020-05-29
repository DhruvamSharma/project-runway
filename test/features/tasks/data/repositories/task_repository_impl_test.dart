import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_runway/core/errors/exceptions.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/network/network_info.dart';
import 'package:project_runway/features/tasks/data/data_sources/task_remote_data_source.dart';
import 'package:project_runway/features/tasks/data/models/task_list_model.dart';
import 'package:project_runway/features/tasks/data/models/task_model.dart';
import 'package:project_runway/features/tasks/data/repositories/task_repository_impl.dart';

class MockRemoteDataSource extends Mock implements TaskRemoteDataSource {}


class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockRemoteDataSource remoteDataSource;
  MockNetworkInfo networkInfo;
  TaskRepositoryImpl repositoryImpl;

  setUp(() {
    remoteDataSource = MockRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repositoryImpl = TaskRepositoryImpl(
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

      test(
          "should not make a call to remote data source if there is data in local storage ",
          () async {
        // assemble
        // act
        await repositoryImpl.getAllTasksForTheDate(tRunningDate);
        // assert
        verifyZeroInteractions(remoteDataSource);
      });

      test("if there is no data in local storage, get data from remote storage",
          () async {
        // assemble

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

        when(remoteDataSource.getAllTasksForTheDate(tRunningDate))
            .thenThrow(ServerException());
        // act
        final response =
            await repositoryImpl.getAllTasksForTheDate(tRunningDate);
        // assert
        expect(response, Left(ServerFailure()));
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

        test("stores the task in local storage", () async {
          // assemble
          when(remoteDataSource.createTask(tTaskModelSynced))
              .thenAnswer((_) async => tTaskModelSynced);
          // act
          await repositoryImpl.createTask(tTaskModel);
          // assert
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
            verify(remoteDataSource.createTask(tTaskModelSynced));
            expect(response, Right(tTaskModelSynced));
          },
        );

        test("if there is an exception, return the failure", () async {

          when(remoteDataSource.createTask(tTaskModelSynced))
              .thenThrow(ServerException());
          // act
          final response = await repositoryImpl.createTask(tTaskModel);
          // assert
          expect(response, Left(CacheFailure()));
        });

        test(
          "if the call to remote and local data source fails,"
          " don't update the object to local data source",
          () async {
            // assemble
            when(remoteDataSource.createTask(tTaskModelSynced))
                .thenThrow(ServerException());
            // act
            final response = await repositoryImpl.createTask(tTaskModel);
            // assert
            verify(remoteDataSource.createTask(tTaskModelSynced));
            expect(response, Left(CacheFailure()));
          },
        );
      },
    );
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



      test("if no task is found in local storage, then search in the remote",
          () async {
        // assemble
        // act
        final response = await repositoryImpl.readTask(tTaskId);
        // assert
        verify(remoteDataSource.readTask(tTaskId));
      });

      test(
          "if no task is found in local storage, then remote data should be returned",
          () async {
        // assemble
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
        when(remoteDataSource.readTask(tTaskId)).thenThrow(ServerException());
        // act
        final response = await repositoryImpl.readTask(tTaskId);
        // assert
        expect(response, Left(ServerFailure()));
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


  });

  group("completeTask", () {
    final tTaskId = "uid";
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

    final tCompletedTask = TaskModel(
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
      isCompleted: true,
    );

    final tSyncedCompletedTask = TaskModel(
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
      isCompleted: true,
    );


    test(
        "should return a completed and synced model on"
        " successful call to remote data source", () async {
      // assemble
      when(remoteDataSource.readTask(tTaskId))
          .thenAnswer((_) async => tTaskModel);
      // act
      final response = await repositoryImpl.completeTask(tTaskModel);
      // assert
      expect(response, Right(tSyncedCompletedTask));
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

    final tDeletedTaskModel = TaskModel(
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
      isDeleted: true,
      isMovable: false,
      isCompleted: false,
    );

    final tSyncedDeletedTask = TaskModel(
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
      isDeleted: true,
      isMovable: false,
      isCompleted: false,
    );



    test(
        "should return a deleted and synced model on"
            " successful call to remote data source", () async {
      // assemble
      when(remoteDataSource.deleteTask(tSyncedDeletedTask))
          .thenAnswer((_) async => tSyncedDeletedTask);
      // act
      final response = await repositoryImpl.deleteTask(tDeletedTaskModel);
      // assert
      expect(response, Right(tSyncedDeletedTask));
    });




  });
}
