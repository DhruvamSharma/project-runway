import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  // If the subclasses have some properties, they'll get passed to this constructor
  // so that Equatable can perform value comparison.
  final List customProps = const <dynamic>[];
  const Failure();

  @override
  List<Object> get props => customProps;
}

class ServerFailure extends Failure {
  final String message;

  ServerFailure({
    this.message,
  }) : super();

  @override
  List<Object> get props => [
        message,
      ];
}

class CacheFailure extends Failure {
  final String message;

  CacheFailure({
    this.message,
  }) : super();

  @override
  List<Object> get props => [
        message,
      ];
}

class PlatformFailure extends Failure {
  final String message;

  PlatformFailure({
    this.message,
  }) : super();

  @override
  List<Object> get props => [
        message,
      ];
}

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String PLATFORM_FAILURE_MESSAGE = 'Platform Failure';

String mapFailureToMessage(Failure failure) {
  // Instead of a regular 'if (failure is ServerFailure)...'
  switch (failure.runtimeType) {
    case ServerFailure:
      String message = (failure as ServerFailure).message;
      return message ?? SERVER_FAILURE_MESSAGE;
    case CacheFailure:
      String message = (failure as CacheFailure).message;
      return message ?? CACHE_FAILURE_MESSAGE;
    case PlatformFailure:
      String message = (failure as PlatformFailure).message;
      return message ?? PLATFORM_FAILURE_MESSAGE;
    default:
      return 'Unexpected Error';
  }
}
