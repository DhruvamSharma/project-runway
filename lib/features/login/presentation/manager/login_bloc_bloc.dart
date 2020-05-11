import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/features/login/domain/repositories/user_repository.dart';
import 'package:project_runway/features/login/domain/use_cases/create_user_use_case.dart';
import 'package:project_runway/features/login/domain/use_cases/delete_user_use_case.dart';
import 'package:project_runway/features/login/domain/use_cases/read_user_use_case.dart';
import './bloc.dart';

class LoginBloc extends Bloc<LoginBlocEvent, LoginBlocState> {
  final ReadUserUseCase findUserUseCase;
  final CreateUserUseCase loginUserUseCase;

  LoginBloc({
    @required this.findUserUseCase,
    @required this.loginUserUseCase,
  });

  @override
  LoginBlocState get initialState => InitialLoginBlocState();

  @override
  Stream<LoginBlocState> mapEventToState(
    LoginBlocEvent event,
  ) async* {
    if (event is CheckIfUserExistsEvent) {
      yield LoadingFindUserBlocState();
      final response = await findUserUseCase(ReadUserUseCaseParams(
        googleId: event.googleId,
      ));
      yield response.fold(
        (failure) =>
            ErrorFindUserBlocState(message: mapFailureToMessage(failure)),
        (user) => LoadedFindBlocState(user: user),
      );
    } else if (event is LoginUserEvent) {
      yield LoadingLoginBlocState();
      final response = await loginUserUseCase(UserUseCaseParams(
        user: event.user,
      ));
      yield response.fold(
        (failure) => ErrorLoginBlocState(message: mapFailureToMessage(failure)),
        (user) => LoadedLoginBlocState(user: user),
      );
    }
  }
}
