import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class UserEntity extends Equatable {
  final String userId;
  final String userName;
  final String phoneNumber;
  final int age;
  final String gender;
  final DateTime createdAt;
  final double score;
  final bool isVerified;
  final bool isDeleted;
  final bool isLoggedIn;

  UserEntity({
    @required this.userId,
    @required this.userName,
    @required this.phoneNumber,
    @required this.age,
    @required this.gender,
    @required this.createdAt,
    @required this.score,
    @required this.isVerified,
    @required this.isDeleted,
    @required this.isLoggedIn,
  });

  @override
  List<Object> get props => [
        userId,
        userName,
        phoneNumber,
        age,
        gender,
        createdAt,
        score,
        isVerified,
        isDeleted,
        isLoggedIn,
      ];

  @override
  bool get stringify => true;
}
