import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class TaskBlocBloc extends Bloc<TaskBlocEvent, TaskBlocState> {
  @override
  TaskBlocState get initialState => InitialTaskBlocState();

  @override
  Stream<TaskBlocState> mapEventToState(
    TaskBlocEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
