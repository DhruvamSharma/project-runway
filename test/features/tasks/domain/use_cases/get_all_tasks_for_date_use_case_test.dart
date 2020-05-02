import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/use_case.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';
import 'package:project_runway/features/tasks/domain/entities/task_list_entity.dart';
import 'package:project_runway/features/tasks/domain/repositories/task_repository.dart';
import 'package:project_runway/features/tasks/domain/use_cases/get_all_tasks_for_date_use_case.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  MockTaskRepository taskRepository;
  GetAllTasksForDateUseCase useCase;

  setUp(() {
    taskRepository = MockTaskRepository();
    useCase = GetAllTasksForDateUseCase(
      repository: taskRepository,
    );
  });

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
    isSuccess: true,
    taskList: [tTaskEntity],
    runningDate: DateTime(2020),
  );

  test("GetAllTasksForDateUseCase should extend the abstract class usecase",
      () {
    // assert
    expect(useCase, isA<UseCase>());
  });

  test("GetAllTasksForDateUseCase should should get data from a repository",
      () async {
    // arrange
    when(taskRepository.getAllTasksForTheDate(any))
        .thenAnswer((_) async => Right(tTaskListEntity));
    // act
       await useCase(DateParam(runningDate: tRunningDate,));
        // assert
        verify(taskRepository.getAllTasksForTheDate(tRunningDate));
  });

  test("GetAllTasksForDateUseCase if success is returned, the task list should be returned",
          () async {
        // arrange
        when(taskRepository.getAllTasksForTheDate(any))
            .thenAnswer((_) async => Right(tTaskListEntity));
        // act
        final response = await useCase(DateParam(runningDate: tRunningDate,));
        // assert
        expect(response, Right(tTaskListEntity));
        verify(taskRepository.getAllTasksForTheDate(tRunningDate));
      });

  test("GetAllTasksForDateUseCase if failure is returned, Failure should be returned",
          () async {
        // arrange
        when(taskRepository.getAllTasksForTheDate(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // act
        final response = await useCase(DateParam(runningDate: tRunningDate,));
        // assert
        expect(response, Left(ServerFailure()));
        verify(taskRepository.getAllTasksForTheDate(tRunningDate));
      });
}
