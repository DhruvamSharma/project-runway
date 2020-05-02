import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/core/errors/failures.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';

// Parameters have to be put into a container object so that they can be
// included in this abstract base class method definition.
abstract class UseCase<T, P> {
  Future<Either<Failure, T>> call(P params);
}

// This will be used by the code calling the use case whenever the use case
// doesn't accept any parameters.
class NoParams extends Equatable {
  @override
  List<Object> get props => null;
}

class DateParam extends Equatable {
  final DateTime runningDate;

  // If no date is send,
  // current date will be picked.
  DateParam({
    this.runningDate,
  });

  @override
  // TODO: implement props
  List<Object> get props => [runningDate];
}


class TaskParam extends Equatable {
  final TaskEntity taskEntity;

  TaskParam({
    @required this.taskEntity,
  });

  @override
  // TODO: implement props
  List<Object> get props => [taskEntity];
}

class StringParam extends Equatable {
  final String taskId;

  // If no date is send,
  // current date will be picked.
  StringParam({
    @required this.taskId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [taskId];
}
