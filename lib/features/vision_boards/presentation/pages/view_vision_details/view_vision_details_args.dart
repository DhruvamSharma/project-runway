import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/features/vision_boards/data/models/vision_model.dart';

class ViewVisionDetailsArgs extends Equatable {
  final VisionModel vision;

  ViewVisionDetailsArgs({
    @required this.vision,
  });

  @override
  List<Object> get props => [
        vision,
      ];
}
