import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserEntity extends Equatable {
  String userId;
  String googleId;
  String userName;
  String phoneNumber;
  String emailId;
  int age;
  String gender;
  DateTime createdAt;
  String userPhotoUrl;
  double score;
  bool isVerified;
  bool isDeleted;
  bool isLoggedIn;

  UserEntity({
    @required this.userId,
    @required this.googleId,
    @required this.userName,
    @required this.phoneNumber,
    @required this.age,
    @required this.gender,
    @required this.userPhotoUrl,
    @required this.createdAt,
    @required this.score,
    @required this.isVerified,
    @required this.isDeleted,
    @required this.isLoggedIn,
    @required this.emailId,
  });

  @override
  List<Object> get props => [
        userId,
        googleId,
        userName,
        phoneNumber,
        age,
        gender,
        createdAt,
        score,
        isVerified,
        isDeleted,
        isLoggedIn,
        emailId,
        userPhotoUrl,
      ];

  @override
  bool get stringify => true;
}
