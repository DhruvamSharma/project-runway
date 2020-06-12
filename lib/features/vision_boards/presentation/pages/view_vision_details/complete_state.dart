import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/features/vision_boards/data/models/vision_model.dart';
import 'package:project_runway/features/vision_boards/presentation/manager/bloc.dart';
import 'package:project_runway/features/vision_boards/presentation/pages/view_vision_details/view_vision_details.dart';
import 'package:provider/provider.dart';

class VisionCompleteStatus extends StatefulWidget {
  final VisionModel vision;

  VisionCompleteStatus({
    @required this.vision,
  });

  @override
  _VisionCompleteStatusState createState() => _VisionCompleteStatusState();
}

class _VisionCompleteStatusState extends State<VisionCompleteStatus> {
  bool isCompleted;
  @override
  void initState() {
    isCompleted = widget.vision.isCompleted;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          width: 250,
          child: Text(
            "Mark the vision as complete",
            style: CommonTextStyles.taskTextStyle(context)
                .copyWith(color: CommonColors.cursorColor),
          ),
        ),
        Theme(
          data: ThemeData(
              accentColor: Colors.transparent,
              unselectedWidgetColor: Colors.white),
          child: Checkbox(
              value: isCompleted,
              onChanged: (isCompleted) {
                Provider.of<MarVisionWidgetDirtyModel>(context, listen: false)
                    .isDirty = true;
                setState(() {
                  this.isCompleted = isCompleted;
                });
                final updatedVision = changeVisionStatus(isCompleted);
                BlocProvider.of<VisionBoardBloc>(context).add(UpdateVisionEvent(
                  vision: updatedVision,
                ));
              }),
        ),
      ],
    );
  }

  VisionModel changeVisionStatus(bool isCompleted) {
    return VisionModel(
      visionBoardId: widget.vision.visionBoardId,
      visionId: widget.vision.visionId,
      imageUrl: widget.vision.imageUrl,
      visionName: widget.vision.visionName,
      quote: widget.vision.quote,
      createdAt: widget.vision.createdAt,
      points: widget.vision.points,
      anotherVariable: widget.vision.anotherVariable,
      isDeleted: widget.vision.isDeleted,
      isCompleted: isCompleted,
      profileImageUrl: widget.vision.profileImageUrl,
      fullName: widget.vision.fullName,
    );
  }
}
