import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class EditVisionArgs extends Equatable {
  final String visionBoardId;
  final String imageUrl;

  EditVisionArgs({
    @required this.visionBoardId,
    @required this.imageUrl,
  });

  @override
  List<Object> get props => [
        visionBoardId,
        imageUrl,
      ];
}
