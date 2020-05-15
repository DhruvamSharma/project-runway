import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/errors/exceptions.dart';
import 'package:project_runway/core/keys.dart';
import 'package:project_runway/features/login/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> readUser(String googleId);
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
    sharedPreferences.setString(USER_KEY, user.userId);
    final response = updateUser(user);
    return response;
  }

  @override
  Future<UserModel> deleteUser(UserModel user) {
    // mark user as deleted in UI
    final response = updateUser(user);
    return response;
  }

  @override
  Future<UserModel> readUser(String googleId) async {
    try {
      final firebaseResponse = await firestore
          .collection(USER_COLLECTION)
          .where("googleId", isEqualTo: googleId)
          .getDocuments();
      if (firebaseResponse.documents.length > 1) {
        // report the error
      }
      if (firebaseResponse.documents.isNotEmpty) {
        DocumentSnapshot userObject = firebaseResponse.documents[0];
        final response = UserModel.fromJson(userObject.data);
        return response;
      } else {
        throw ServerException(message: USER_NOT_FOUND_ERROR);
      }
    } catch (ex) {
      throw ServerException(message: USER_NOT_FOUND_ERROR);
    }
  }

  @override
  Future<UserModel> updateUser(UserModel user) {
    print(user.userName);
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
