import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_runway/core/errors/exceptions.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/core/network/network_info.dart';
import 'package:project_runway/features/login/data/data_sources/user_local_data_source.dart';
import 'package:project_runway/features/login/data/data_sources/user_remote_data_source.dart';
import 'package:project_runway/features/login/data/models/user_model.dart';
import 'package:project_runway/features/login/data/repositories/user_repository_impl.dart';
import 'package:uuid/uuid.dart';

class MockUserRemoteDataSource extends Mock implements UserRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockUserLocalDataSource extends Mock implements UserLocalDataSource {}

class MockUuid extends Mock implements Uuid {}

void main() {
  MockUserRemoteDataSource remoteDataSource;
  MockUserLocalDataSource localDataSource;
  MockUuid uuid = MockUuid();
  NetworkInfo networkInfo;
  UserRepositoryImpl repositoryImpl;

  setUp(() {
    remoteDataSource = MockUserRemoteDataSource();
    localDataSource = MockUserLocalDataSource();
    networkInfo = MockNetworkInfo();
    repositoryImpl = UserRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
      uuid: uuid,
    );
  });

  final tUserId = "dsjhbcusdybcy8bhk";
  final tGoogleId = "dhucbuey83becbijdbc39";
  final tUserModel = UserModel(
    userId: null,
    googleId: "dhucbuey83becbijdbc39",
    userName: "Dhruvam",
    phoneNumber: null,
    age: null,
    gender: null,
    userPhotoUrl: null,
    createdAt: DateTime.parse("2020-05-10 23:52:31.959041"),
    score: 12,
    isVerified: true,
    isDeleted: false,
    isLoggedIn: false,
    emailId: "dhruvamssharma@gmail.com",
  );

  final tUpdatedUserModel = UserModel(
    userId: "dsjhbcusdybcy8bhk",
    googleId: "dhucbuey83becbijdbc39",
    userName: "Dhruvam",
    phoneNumber: null,
    age: null,
    gender: null,
    userPhotoUrl: null,
    createdAt: DateTime.parse("2020-05-10 23:52:31.959041"),
    score: 12,
    isVerified: true,
    isDeleted: false,
    isLoggedIn: false,
    emailId: "dhruvamssharma@gmail.com",
  );

  final tDeletedUserModel = UserModel(
    userId: "dsjhbcusdybcy8bhk",
    googleId: "dhucbuey83becbijdbc39",
    userName: "Dhruvam",
    phoneNumber: null,
    age: null,
    gender: null,
    userPhotoUrl: null,
    createdAt: DateTime.parse("2020-05-10 23:52:31.959041"),
    score: 12,
    isVerified: true,
    isDeleted: true,
    isLoggedIn: false,
    emailId: "dhruvamssharma@gmail.com",
  );

  group("createUser", () {
    test("when request for create is made, a new user id should be generated",
        () async {
      // assemble
      when(uuid.v1()).thenReturn(tUserId);
      // act
      await repositoryImpl.createUser(tUserModel);
      // assert
      verify(uuid.v1());
    });

    test(
        "when request for create is made, user model should be sent to remote data source",
        () async {
      // assemble
      when(uuid.v1()).thenReturn(tUserId);
      when(remoteDataSource.createUser(any))
          .thenAnswer((realInvocation) async => tUpdatedUserModel);
      // act
      await repositoryImpl.createUser(tUserModel);
      // assert
      verify(remoteDataSource.createUser(tUpdatedUserModel));
    });

    test(
        "when request for create is made, user model should be returned from remote data source",
        () async {
      // assemble
      when(uuid.v1()).thenReturn(tUserId);
      when(remoteDataSource.createUser(any))
          .thenAnswer((realInvocation) async => tUpdatedUserModel);
      // act
      final response = await repositoryImpl.createUser(tUserModel);
      // assert
      expect(response, Right(tUpdatedUserModel));
    });

    test(
        "when request for create is made, and the call fails, Failure should be returned from remote data source",
        () async {
      // assemble
      when(uuid.v1()).thenReturn(tUserId);
      when(remoteDataSource.createUser(any)).thenThrow(ServerException());
      // act
      final response = await repositoryImpl.createUser(tUserModel);
      // assert
      expect(response, Left(ServerFailure()));
    });
  });

  group("deleteUser", () {
    test(
        "when request for delete is made, user model should be sent to remote data source",
        () async {
      // assemble
      when(remoteDataSource.deleteUser(any))
          .thenAnswer((realInvocation) async => tDeletedUserModel);
      // act
      await repositoryImpl.deleteUser(tUserModel);
      print("in test: ${tUserModel.toJson()}");
      print("in repo: ${tDeletedUserModel.toJson()}");
      // assert
      verify(remoteDataSource.deleteUser(tDeletedUserModel));
    }, skip: true);

    test(
        "when request for delete is made, user model should be returned from remote data source",
        () async {
      // assemble
      when(remoteDataSource.deleteUser(any))
          .thenAnswer((realInvocation) async => tDeletedUserModel);
      // act
      final response = await repositoryImpl.deleteUser(tUserModel);
      // assert
      expect(response, Right(tDeletedUserModel));
    });

    test(
        "when request for delete is made, and the call fails, Failure should be returned from remote data source",
        () async {
      // assemble
      when(remoteDataSource.deleteUser(any)).thenThrow(ServerException());
      // act
      final response = await repositoryImpl.deleteUser(tUserModel);
      // assert
      expect(response, Left(ServerFailure()));
    });
  });

  group("readUser", () {
    group("internet is on", () {
      setUp(() {
        when(networkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
      });
      test(
          "when request for read is made, user model should be sent to remote data source",
          () async {
        // assemble
        when(remoteDataSource.readUser(any))
            .thenAnswer((realInvocation) async => tUserModel);
        // act
        await repositoryImpl.readUser(tGoogleId);
        // assert
        verify(remoteDataSource.readUser(tGoogleId));
      });

      test(
          "when request for read is made, user model should be returned from remote data source",
          () async {
        // assemble
        when(remoteDataSource.readUser(any))
            .thenAnswer((realInvocation) async => tUserModel);
        // act
        final response = await repositoryImpl.readUser(tGoogleId);
        // assert
        expect(response, Right(tUserModel));
      });

      test(
          "when request for read is made, and the call fails, Failure should be returned from remote data source",
          () async {
        // assemble
        when(remoteDataSource.readUser(any)).thenThrow(ServerException());
        // act
        final response = await repositoryImpl.readUser(tGoogleId);
        // assert
        expect(response, Left(ServerFailure()));
      });
    });

    group("internet is off", () {
      setUp(() {
        when(networkInfo.isConnected)
            .thenAnswer((realInvocation) async => false);
      });
      test(
          "when request for read is made, user model should be sent to local data source",
              () async {
            // assemble
            when(localDataSource.readUser())
                .thenAnswer((realInvocation) async => tUserModel);
            // act
            await repositoryImpl.readUser(tGoogleId);
            // assert
            verify(localDataSource.readUser());
          });

      test(
          "when request for read is made, user model should be returned from local data source",
              () async {
            // assemble
            when(localDataSource.readUser())
                .thenAnswer((realInvocation) async => tUserModel);
            // act
            final response = await repositoryImpl.readUser(tGoogleId);
            // assert
            expect(response, Right(tUserModel));
          });

      test(
          "when request for read is made, and the call fails, Failure should be returned from remote data source",
              () async {
            // assemble
            when(localDataSource.readUser()).thenThrow(CacheException());
            // act
            final response = await repositoryImpl.readUser(tGoogleId);
            // assert
            expect(response, Left(CacheFailure()));
          });
    });
  });


  group("updateUser", () {
    test(
        "when request for update is made, user model should be sent to remote data source",
            () async {
          // assemble
          when(remoteDataSource.updateUser(any))
              .thenAnswer((realInvocation) async => tUserModel);
          // act
          await repositoryImpl.updateUser(tUserModel);
          // assert
          verify(remoteDataSource.updateUser(tUserModel));
        });

    test(
        "when request for update is made, user model should be returned from remote data source",
            () async {
          // assemble
          when(remoteDataSource.updateUser(any))
              .thenAnswer((realInvocation) async => tUpdatedUserModel);
          // act
          final response = await repositoryImpl.updateUser(tUserModel);
          // assert
          expect(response, Right(tUpdatedUserModel));
        });

    test(
        "when request for update is made, and the call fails, Failure should be returned from remote data source",
            () async {
          // assemble
          when(remoteDataSource.updateUser(any)).thenThrow(ServerException());
          // act
          final response = await repositoryImpl.updateUser(tUserModel);
          // assert
          expect(response, Left(ServerFailure()));
        });
  });
}
