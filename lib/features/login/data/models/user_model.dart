import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_runway/features/login/domain/entities/user_entity.dart';

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
    @required String googleId,
    @required String userPhotoUrl,
    @required String emailId,
  }) : super(
          userId: userId,
          emailId: emailId,
          userPhotoUrl: userPhotoUrl,
          googleId: googleId,
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

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      userId: map["userId"],
      userName: map["userName"],
      phoneNumber: map["phoneNumber"],
      age: map["age"],
      gender: map["gender"],
      createdAt:
          map["createdAt"] == null ? null : DateTime.parse(map["createdAt"]),
      score:
          map["score"] == null ? null : double.parse((map["score"]).toString()),
      isVerified: map["isVerified"],
      isDeleted: map["isDeleted"],
      isLoggedIn: map["isLoggedIn"],
      googleId: map["googleId"],
      userPhotoUrl: map["userPhotoUrl"],
      emailId: map["emailId"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "googleId": googleId,
      "userName": userName,
      "phoneNumber": phoneNumber,
      "age": age,
      "gender": gender,
      "userPhotoUrl": userPhotoUrl,
      "createdAt": createdAt == null ? null : createdAt.toString(),
      "score": score,
      "isVerified": isVerified,
      "isDeleted": isDeleted,
      "isLoggedIn": isLoggedIn,
      "emailId": emailId,
    };
  }
}
