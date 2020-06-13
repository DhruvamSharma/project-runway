import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/core/keys/keys.dart';
import 'package:project_runway/features/login/data/models/user_model.dart';
import 'package:project_runway/features/login/domain/entities/user_entity.dart';

class AnalyticsUtils {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static UserEntity userEntity = UserModel.fromJson(
      json.decode(sharedPreferences.getString(USER_MODEL_KEY)));

  static sendAnalyticEvent(
      String eventName, Map<String, Object> props, String screenName) {
    try {
      analytics.setUserId(userEntity.googleId);
      analytics.setCurrentScreen(
        screenName: screenName,
      );
      analytics.logEvent(name: eventName, parameters: props);
    } catch (ex) {
      // Do nothing
    }
  }
}
