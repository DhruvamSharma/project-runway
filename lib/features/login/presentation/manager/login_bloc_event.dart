import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/features/login/domain/entities/user_entity.dart';

abstract class LoginBlocEvent extends Equatable {
  final List customProps = const <dynamic>[];
  const LoginBlocEvent();

  @override
  List<Object> get props => customProps;
}

class CheckIfUserExistsEvent extends LoginBlocEvent {
  final String googleId;

  CheckIfUserExistsEvent({
    @required this.googleId,
  });

  @override
  List<Object> get props => [googleId];
}

class LoginUserEvent extends LoginBlocEvent {
  final UserEntity user;

  LoginUserEvent({
    @required this.user,
  });

  @override
  List<Object> get props => [user];
}
