import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/use_case.dart';
import 'package:project_runway/features/login/domain/entities/user_entity.dart';
import 'package:project_runway/features/login/domain/repositories/user_repository.dart';
import 'package:project_runway/features/login/domain/use_cases/delete_user_use_case.dart';
import 'package:project_runway/features/login/domain/use_cases/read_user_use_case.dart';
import 'package:project_runway/features/login/domain/use_cases/update_user_use_case.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  MockUserRepository repository;
  UpdateUserUseCase useCase;

  setUp(() {
    repository = MockUserRepository();
    useCase = UpdateUserUseCase(
      repository: repository,
    );
  });

  final tGoogleId = "djbckue7geucbywecbu8wec";
  final tUserEntity = UserEntity(
    userId: "dsjhbcusdybcy8bhk",
    googleId: tGoogleId,
    userName: "Dhruvam",
    phoneNumber: null,
    age: null,
    gender: null,
    userPhotoUrl: null,
    createdAt: DateTime.now(),
    score: 12,
    isVerified: true,
    isDeleted: false,
    isLoggedIn: false,
    emailId: "dhruvamssharma@gmail.com",
  );

  final tUpdatedUserEntity = UserEntity(
    userId: "dsjhbcusdybcy8bhk",
    googleId: tGoogleId,
    userName: "Dhruvam",
    phoneNumber: null,
    age: null,
    gender: null,
    userPhotoUrl: "",
    createdAt: DateTime.now(),
    score: 12,
    isVerified: true,
    isDeleted: true,
    isLoggedIn: false,
    emailId: "dhruvamssharma@gmail.com",
  );

  test("UpdateUserUseCase extends usecase", () async {
    // assemble
    // act
    // assert
    expect(useCase, isA<UseCase>());
  });

  test("usecase gets data from repository", () async {
    // assemble
    // act
    await useCase(UserUseCaseParams(user: tUserEntity));
    // assert
    verify(repository.updateUser(tUserEntity));
  });

  test("if call is successful, deleted user entity is returned", () async {
    // assemble
    when(repository.updateUser(any))
        .thenAnswer((realInvocation) async => Right(tUpdatedUserEntity));
    // act
    final response = await useCase(UserUseCaseParams(user: tUserEntity));
    // assert
    expect(response, Right(tUpdatedUserEntity));
  });

  test("if call is unsuccessful, failure is returned", () async {
    // assemble
    when(repository.updateUser(any))
        .thenAnswer((realInvocation) async => Left(ServerFailure()));
    // act
    final response = await useCase(UserUseCaseParams(user: tUserEntity));
    // assert
    expect(response, Left(ServerFailure()));
  });
}
