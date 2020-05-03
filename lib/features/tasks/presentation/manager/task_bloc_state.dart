import 'package:equatable/equatable.dart';

abstract class TaskBlocState extends Equatable {
  const TaskBlocState();
}

class InitialTaskBlocState extends TaskBlocState {
  @override
  List<Object> get props => [];
}
