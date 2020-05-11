import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/use_case.dart';
import 'package:project_runway/features/login/domain/entities/user_entity.dart';
import 'package:project_runway/features/login/domain/repositories/user_repository.dart';
import 'package:project_runway/features/login/domain/use_cases/create_user_use_case.dart';
import 'package:project_runway/features/login/domain/use_cases/delete_user_use_case.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  MockUserRepository repository;
  CreateUserUseCase useCase;

  setUp(() {
    repository = MockUserRepository();
    useCase = CreateUserUseCase(
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

  test("CreateUserUseCase extends usecase", () async {
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
    verify(repository.createUser(tUserEntity));
  });

  test("if call is successful, deleted user entity is returned", () async {
    // assemble
    when(repository.createUser(any))
        .thenAnswer((realInvocation) async => Right(tUserEntity));
    // act
    final response = await useCase(UserUseCaseParams(user: tUserEntity));
    // assert
    expect(response, Right(tUserEntity));
  });

  test("if call is unsuccessful, failure is returned", () async {
    // assemble
    when(repository.createUser(any))
        .thenAnswer((realInvocation) async => Left(ServerFailure()));
    // act
    final response = await useCase(UserUseCaseParams(user: tUserEntity));
    // assert
    expect(response, Left(ServerFailure()));
  });
}
