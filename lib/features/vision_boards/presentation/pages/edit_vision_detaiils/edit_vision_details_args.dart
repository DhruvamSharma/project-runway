import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class EditVisionArgs extends Equatable {
  final String visionBoardId;

  EditVisionArgs({
    @required this.visionBoardId,
  });

  @override
  List<Object> get props => [visionBoardId];
}
