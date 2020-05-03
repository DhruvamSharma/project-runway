import 'package:flutter/widgets.dart';
import 'package:project_runway/features/tasks/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    @required String userId,
    @required String userName,
    @required String phoneNumber,
    @required int age,
    @required String gender,
    @required DateTime createdAt,
    @required double score,
    @required bool isVerified,
    @required bool isDeleted,
    @required bool isLoggedIn,
  }) : super(
          userId: userId,
          userName: userName,
          phoneNumber: phoneNumber,
          age: age,
          gender: gender,
          createdAt: createdAt,
          score: score,
          isVerified: isVerified,
          isDeleted: isDeleted,
          isLoggedIn: isLoggedIn,
        );
}
