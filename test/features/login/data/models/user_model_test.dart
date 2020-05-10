import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:project_runway/features/login/data/models/user_model.dart';
import 'package:project_runway/features/login/domain/entities/user_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tUserModel = UserModel(
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

  test("user model extends user entity", () async {
      // assemble
      // act
      // assert
      expect(tUserModel, isA<UserEntity>());
  });

  test("model should be converted from json", () async {
      // assemble
      final Map<String, dynamic> userModelMap = json.decode(fixture("user_model.json"));
      // act
      final response = UserModel.fromJson(userModelMap);
      // assert
      expect(response, tUserModel);
  });

  test("model should be converted to json", () async {
    // assemble
    final Map<String, dynamic> userModelMap = json.decode(fixture("user_model.json"));
    // act
    final response = tUserModel.toJson();
    // assert
    expect(response, userModelMap);
  });
}