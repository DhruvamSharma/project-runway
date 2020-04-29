class ServerException implements Exception {
  final String message;

  ServerException({this.message});
}

class CacheException implements Exception {
  final String message;

  CacheException({this.message});
}

class CustomPlatformException implements Exception {
  final String message;

  CustomPlatformException({this.message});
}
