import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/use_case.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';
import 'package:project_runway/features/tasks/domain/entities/task_list_entity.dart';
import 'package:project_runway/features/tasks/domain/use_cases/complete_task_use_case.dart';
import 'package:project_runway/features/tasks/domain/use_cases/get_all_tasks_for_date_use_case.dart';
import 'package:project_runway/features/tasks/presentation/manager/bloc.dart';

class MockGetCompleteTaskUseCase extends Mock
    implements GetCompleteTaskUseCase {}

class MockGetAllTasksForDateUseCase extends Mock
    implements GetAllTasksForDateUseCase {}

void main() {
  MockGetCompleteTaskUseCase completeTaskUseCase;
  MockGetAllTasksForDateUseCase allTasksForDateUseCase;
  HomeScreenTaskBloc homeScreenTaskBloc;

  setUp(() {
    completeTaskUseCase = MockGetCompleteTaskUseCase();
    allTasksForDateUseCase = MockGetAllTasksForDateUseCase();
    homeScreenTaskBloc = HomeScreenTaskBloc(
      completeTaskUseCase: completeTaskUseCase,
      allTasksForDateUseCase: allTasksForDateUseCase,
    );
  });

  group("GetCompleteTaskUseCase", () {
    final tTaskId = "uid";

    final tTaskEntity = TaskEntity(
      userId: tTaskId,
      taskId: "tid",
      taskTitle: "tTitle",
      description: "tDescription",
      urgency: 2,
      tag: "rag",
      notificationTime: DateTime(2020),
      createdAt: DateTime(2020),
      runningDate: DateTime(2020),
      lastUpdatedAt: DateTime(2020),
      isSynced: false,
      isDeleted: false,
      isMovable: false,
      isCompleted: false,
    );

    test("initial state should be empty", () {
      // assert
      expect(homeScreenTaskBloc.initialState, isA<InitialTaskBlocState>());
    });

    test("calls the usecase", () async {
      // assemble
//      when(completeTaskUseCase(StringParam(taskId: any)))
//          .thenAnswer((_) async => Right(tTaskEntity));
      // act
      homeScreenTaskBloc.dispatch(CompleteTaskEvent(task: tTaskEntity));
      await untilCalled(completeTaskUseCase(TaskParam(taskEntity: tTaskEntity)));
      // assert
      verify(completeTaskUseCase(TaskParam(taskEntity: tTaskEntity)));
    });

    test("bloc should yeild [LOADING, LOADED] states, when the data is successfully fetched", () async {
      // assemble
      when(completeTaskUseCase(TaskParam(taskEntity: tTaskEntity)))
          .thenAnswer((_) async => Right(tTaskEntity));
      final tStates = [
        InitialTaskBlocState(),
        LoadingHomeScreenState(),
        LoadedHomeScreenCompleteTaskState(taskEntity: tTaskEntity),
      ];
      // act
      homeScreenTaskBloc.dispatch(CompleteTaskEvent(task: tTaskEntity));
      // assert
      expectLater(homeScreenTaskBloc.state, emitsInOrder(tStates));
    });


    test("bloc should yeild [LOADING, ERROR] states, when the data is successfully fetched", () async {
      // assemble
      when(completeTaskUseCase(TaskParam(taskEntity: tTaskEntity)))
          .thenAnswer((_) async => Left(ServerFailure()));
      final tStates = [
        InitialTaskBlocState(),
        LoadingHomeScreenState(),
        ErrorHomeScreenCompleteTaskState(message: SERVER_FAILURE_MESSAGE),
      ];
      // act
      homeScreenTaskBloc.dispatch(CompleteTaskEvent(task: tTaskEntity));
      // assert
      expectLater(homeScreenTaskBloc.state, emitsInOrder(tStates));
    });
  });


  group("GetAllTasksForDateUseCase", () {
    final tRunningDate = DateTime(2020);

    final tTaskEntity = TaskEntity(
      userId: "uid",
      taskId: "tid",
      taskTitle: "tTitle",
      description: "tDescription",
      urgency: 2,
      tag: "rag",
      notificationTime: DateTime(2020),
      createdAt: DateTime(2020),
      runningDate: DateTime(2020),
      lastUpdatedAt: DateTime(2020),
      isSynced: false,
      isDeleted: false,
      isMovable: false,
      isCompleted: false,
    );

    final tTaskListEntity = TaskListEntity(
      isSynced: true,
      taskList: [tTaskEntity],
      runningDate: DateTime(2020),
    );

    test("initial state should be empty", () {
      // assert
      expect(homeScreenTaskBloc.initialState, isA<InitialTaskBlocState>());
    });

    test("calls the usecase", () async {
      // act
      homeScreenTaskBloc.dispatch(ReadAllTaskEvent(runningDate: tRunningDate));
      await untilCalled(allTasksForDateUseCase(DateParam(runningDate: tRunningDate)));
      // assert
      verify(allTasksForDateUseCase(DateParam(runningDate: tRunningDate)));
    });

    test("bloc should yeild [LOADING, LOADED] states, when the data is successfully fetched", () async {
      // assemble
      when(allTasksForDateUseCase(DateParam(runningDate: tRunningDate)))
          .thenAnswer((_) async => Right(tTaskListEntity));
      final tStates = [
        InitialTaskBlocState(),
        LoadingHomeScreenState(),
        LoadedHomeScreenAllTasksState(taskListEntity: tTaskListEntity),
      ];
      // act
      homeScreenTaskBloc.dispatch(ReadAllTaskEvent(runningDate: tRunningDate));
      // assert
      expectLater(homeScreenTaskBloc.state, emitsInOrder(tStates));
    });


    test("bloc should yeild [LOADING, ERROR] states, when the data is successfully fetched", () async {
      // assemble
      when(allTasksForDateUseCase(DateParam(runningDate: tRunningDate)))
          .thenAnswer((_) async => Left(ServerFailure()));
      final tStates = [
        InitialTaskBlocState(),
        LoadingHomeScreenState(),
        ErrorHomeScreenAllTasksState(message: SERVER_FAILURE_MESSAGE),
      ];
      // act
      homeScreenTaskBloc.dispatch(ReadAllTaskEvent(runningDate: tRunningDate));
      // assert
      expectLater(homeScreenTaskBloc.state, emitsInOrder(tStates));
    });
  });


}
