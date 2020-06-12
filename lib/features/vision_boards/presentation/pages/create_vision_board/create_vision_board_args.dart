import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CreateVisionBoardArgs extends Equatable {
  final String visionBoardId;

  CreateVisionBoardArgs({
    @required this.visionBoardId,
  });

  @override
  List<Object> get props => [visionBoardId];
}
