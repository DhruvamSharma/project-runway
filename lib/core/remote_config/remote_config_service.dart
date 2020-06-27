import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/core/keys/remote_config_keys.dart';

class RemoteConfigService {
  RemoteConfig _remoteConfig;
  final defaults = <String, dynamic>{
    STATS_ENABLED_KEY: true,
    VISION_BOARD_ENABLED_KEY: true,
    CREATE_TASK_ENABLED_KEY: true,
    DRAW_TASK_ENABLED_KEY: true,
    VIEW_VISION_BOARD_DETAILS_ENABLED_KEY: true,
    CREATE_VISION_ENABLED_KEY: true,
    LIGHT_THEME_OPTION_ENABLED_KEY: true,
    MAX_TASK_CREATION_LIMIT: 6,
    MAX_VISION_CREATION_LIMIT: 9,
  };
  static RemoteConfigService _instance;
  static Future<RemoteConfigService> getInstance() async {
    if (_instance == null) {
      _instance =
          RemoteConfigService(remoteConfig: await RemoteConfig.instance);
    }
    return _instance;
  }

  RemoteConfigService({@required RemoteConfig remoteConfig})
      : _remoteConfig = remoteConfig;

  // config value getters
  bool get statsEnabled => _remoteConfig.getBool(STATS_ENABLED_KEY);
  bool get visionBoardEnabled =>
      _remoteConfig.getBool(VISION_BOARD_ENABLED_KEY);
  bool get createTaskEnabled => _remoteConfig.getBool(CREATE_TASK_ENABLED_KEY);
  bool get drawTaskEnabled => _remoteConfig.getBool(DRAW_TASK_ENABLED_KEY);
  bool get viewVisionBoardDetailEnabled =>
      _remoteConfig.getBool(VIEW_VISION_BOARD_DETAILS_ENABLED_KEY);
  bool get createVisionEnabled =>
      _remoteConfig.getBool(CREATE_VISION_ENABLED_KEY);
  bool get lightThemeOptionEnabled =>
      _remoteConfig.getBool(LIGHT_THEME_OPTION_ENABLED_KEY);
  int get maxTaskLimit => _remoteConfig.getInt(MAX_TASK_CREATION_LIMIT);
  int get maxVisionLimit => _remoteConfig.getInt(MAX_VISION_CREATION_LIMIT);

  Future initialiseRemoteConfig() async {
    try {
      await _remoteConfig.setDefaults(defaults);
      await _remoteConfig.fetch(
        expiration: Duration(hours: 6),
      );
      await _remoteConfig.activateFetched();
    } on FetchThrottledException catch (ex) {
      print(ex.toString());
    } catch (ex) {
      print(ex);
    }
  }
}
