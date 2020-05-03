import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';

/// This class will be used for checking the network connectivity,
/// If there is a reliable network connection or not.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl extends NetworkInfo {
  final DataConnectionChecker connectionChecker;

  NetworkInfoImpl({
    @required this.connectionChecker,
  });

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
