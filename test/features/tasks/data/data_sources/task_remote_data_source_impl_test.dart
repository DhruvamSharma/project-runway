import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_runway/core/keys.dart';
import 'package:project_runway/features/tasks/data/data_sources/task_remote_data_source.dart';
import 'package:project_runway/features/tasks/data/models/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockFirestoreInstance extends Mock implements Firestore {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences sharedPreferences;
  MockFirestoreInstance firestoreInstance;
  TaskRemoteDataSourceImpl remoteDataSourceImpl;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
    firestoreInstance = MockFirestoreInstance();
    remoteDataSourceImpl = TaskRemoteDataSourceImpl(
      firestore: firestoreInstance,
      sharedPreferences: sharedPreferences,
    );
  });

  final tTaskModel = TaskModel(
    userId: "Dhruvam",
    taskId: null,
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

  test("create task method calls firestore.instance.add method", () async {
    // assemble
    when(sharedPreferences.containsKey(USER_KEY)).thenReturn(true);
    when(sharedPreferences.getString(USER_KEY)).thenReturn("Dhruvam");

    // act
    await remoteDataSourceImpl.createTask(tTaskModel);
    // assert
    verify(firestoreInstance.collection(USER_KEY).add(tTaskModel.toJson()));
  }, skip: true);
}
