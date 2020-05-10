import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/errors/exceptions.dart';
import 'package:project_runway/core/keys.dart';
import 'package:project_runway/features/login/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> readUser(String userId);
  Future<UserModel> createUser(UserModel user);
  Future<UserModel> updateUser(UserModel user);
  Future<UserModel> deleteUser(UserModel user);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final SharedPreferences sharedPreferences;
  final Firestore firestore;

  UserRemoteDataSourceImpl({
    @required this.sharedPreferences,
    @required this.firestore,
  });

  @override
  Future<UserModel> createUser(UserModel user) {
    final response = updateUser(user);
    return response;
  }

  @override
  Future<UserModel> deleteUser(UserModel user) {
    final response = updateUser(user);
    return response;
  }

  @override
  Future<UserModel> readUser(String userId) async {
    try {
      final firebaseResponse =
          await firestore.collection(USER_COLLECTION).document(userId).get();
      final response = UserModel.fromJson(firebaseResponse.data);
      return response;
    } catch (ex) {
      throw ServerException(message: USER_NOT_FOUND_ERROR);
    }
  }

  @override
  Future<UserModel> updateUser(UserModel user) {
    try {
      firestore
          .collection(USER_COLLECTION)
          .document(user.userId)
          .setData(user.toJson());
      return Future.value(user);
    } catch (ex) {
      throw ServerException();
    }
  }
}
