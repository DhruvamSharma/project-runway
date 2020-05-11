import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/features/login/domain/entities/user_entity.dart';

abstract class LoginBlocState extends Equatable {
  const LoginBlocState();
}

class InitialLoginBlocState extends LoginBlocState {
  @override
  List<Object> get props => [];
}

// Find User
class LoadingFindUserBlocState extends LoginBlocState {
  @override
  List<Object> get props => [];
}

class LoadedFindBlocState extends LoginBlocState {
  final UserEntity user;

  LoadedFindBlocState({
    @required this.user,
  });

  @override
  List<Object> get props => [];
}

class ErrorFindUserBlocState extends LoginBlocState {
  final String message;

  ErrorFindUserBlocState({
    @required this.message,
  });

  @override
  List<Object> get props => [message];
}

// Login
class LoadingLoginBlocState extends LoginBlocState {
  @override
  List<Object> get props => [];
}

class LoadedLoginBlocState extends LoginBlocState {
  final UserEntity user;

  LoadedLoginBlocState({@required this.user});

  @override
  List<Object> get props => [user];
}

class ErrorLoginBlocState extends LoginBlocState {
  final String message;

  ErrorLoginBlocState({
    @required this.message,
  });

  @override
  List<Object> get props => [message];
}
