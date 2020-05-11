import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_runway/features/login/data/data_sources/user_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences sharedPreferences;
  UserLocalDataSourceImpl localDataSourceImpl;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
    localDataSourceImpl = UserLocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
    );
  });
}