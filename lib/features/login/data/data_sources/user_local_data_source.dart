import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/errors/exceptions.dart';
import 'package:project_runway/core/keys.dart';
import 'package:project_runway/features/login/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserLocalDataSource {
  Future<UserModel> readUser();
  Future<UserModel> updateUser(UserModel user);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;

  UserLocalDataSourceImpl({
    @required this.sharedPreferences,
  });

  @override
  Future<UserModel> readUser() {
    final userJson = sharedPreferences.getString(USER_MODEL_KEY);
    if (userJson != null) {
      final userMap = json.decode(userJson);
      final response = UserModel.fromJson(userMap);
      return Future.value(response);
    } else {
      throw CacheException(message: USER_NOT_FOUND_ERROR);
    }
  }

  @override
  Future<UserModel> updateUser(UserModel user) {
    try {
      sharedPreferences.setString(USER_MODEL_KEY, json.encode(user.toJson()));
      return Future.value(user);
    } catch (ex) {
      throw CacheException(message: SAVING_ERROR);
    }
  }
}
