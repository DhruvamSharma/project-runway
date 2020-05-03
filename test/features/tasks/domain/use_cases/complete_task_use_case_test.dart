import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/use_case.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';
import 'package:project_runway/features/tasks/domain/entities/task_list_entity.dart';
import 'package:project_runway/features/tasks/domain/repositories/task_repository.dart';
import 'package:project_runway/features/tasks/domain/use_cases/complete_task_use_case.dart';
import 'package:project_runway/features/tasks/domain/use_cases/create_task_use_case.dart';
import 'package:project_runway/features/tasks/domain/use_cases/delete_task_use_case.dart';
import 'package:project_runway/features/tasks/domain/use_cases/get_all_tasks_for_date_use_case.dart';
import 'package:project_runway/features/tasks/domain/use_cases/read_task_use_case.dart';
import 'package:project_runway/features/tasks/domain/use_cases/update_task_use_case.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  MockTaskRepository taskRepository;
  GetCompleteTaskUseCase useCase;

  setUp(() {
    taskRepository = MockTaskRepository();
    useCase = GetCompleteTaskUseCase(
      repository: taskRepository,
    );
  });

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

  test("GetCompleteTaskUseCase should extend the abstract class usecase", () {
    // assert
    expect(useCase, isA<UseCase>());
  });

  test("GetCompleteTaskUseCase should should get data from a repository",
          () async {
        // arrange
        when(taskRepository.completeTask(any))
            .thenAnswer((_) async => Right(tTaskEntity));
        // act
        await useCase(TaskParam(
          taskEntity: tTaskEntity,
        ));
        // assert
        verify(taskRepository.completeTask(tTaskEntity));
      });

  test(
      "GetCompleteTaskUseCase if success is returned, the task list should be returned",
          () async {
        // arrange
        when(taskRepository.completeTask(any))
            .thenAnswer((_) async => Right(tTaskEntity));
        // act
        final response = await useCase(TaskParam(
          taskEntity: tTaskEntity,
        ));
        // assert
        expect(response, Right(tTaskEntity));
        verify(taskRepository.completeTask(tTaskEntity));
      });

  test(
      "GetCompleteTaskUseCase if failure is returned, Failure should be returned",
          () async {
        // arrange
        when(taskRepository.completeTask(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // act
        final response = await useCase(TaskParam(
          taskEntity: tTaskEntity,
        ));
        // assert
        expect(response, Left(ServerFailure()));
        verify(taskRepository.completeTask(tTaskEntity));
      });
}
