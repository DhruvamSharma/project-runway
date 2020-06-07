import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/common_ui/custom_text_field.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/features/vision_boards/data/models/vision_model.dart';
import 'package:project_runway/features/vision_boards/presentation/manager/bloc.dart';
import 'package:uuid/uuid.dart';

class EditVisionRoute extends StatefulWidget {
  static const String routeName = "${APP_NAME}_v1_vision-board_edit-vision";
  final String visionImageUrl;
  final String visionBoardId;

  EditVisionRoute({
    @required this.visionImageUrl,
    @required this.visionBoardId,
  });

  @override
  _EditVisionRouteState createState() => _EditVisionRouteState();
}

class _EditVisionRouteState extends State<EditVisionRoute> {
  static const String screenName = "Vision";
  double urgencyValue = 30;
  String visionName;
  @override
  void initState() {
    print(widget.visionBoardId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocListener<VisionBoardBloc, VisionBoardState>(
        listener: (_, state) {
          print(state);
        },
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: RotatedBox(
                quarterTurns: 3,
                child: Text(
                  screenName.toUpperCase(),
                  style: CommonTextStyles.rotatedDesignTextStyle(context),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      screenName.toUpperCase(),
                      style: CommonTextStyles.headerTextStyle(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: CommonDimens.MARGIN_20,
                      bottom: CommonDimens.MARGIN_20,
                    ),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(
                        10,
                      ))),
                      child: CachedNetworkImage(
                        imageUrl: widget.visionImageUrl,
                        height: 200,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: CommonDimens.MARGIN_60,
                      vertical: CommonDimens.MARGIN_20,
                    ),
                    child: CustomTextField(
                      null,
                      null,
                      label: "Vision Name",
                      isRequired: false,
                      onValueChange: (value) {
                        visionName = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: CommonDimens.MARGIN_40,
                      left: CommonDimens.MARGIN_40,
                      right: CommonDimens.MARGIN_40,
                    ),
                    child: SliderTheme(
                      data: SliderThemeData(
                          trackHeight: 6,
                          showValueIndicator: ShowValueIndicator.always,
                          valueIndicatorColor: CommonColors.chartColor),
                      child: Slider(
                        value: urgencyValue,
                        min: 0,
                        max: 100,
                        activeColor: CommonColors.chartColor,
                        inactiveColor: CommonColors.disabledTaskTextColor,
                        onChanged: (changedValue) {
                          setState(() {
                            urgencyValue = changedValue;
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: CommonDimens.MARGIN_40,
                    ),
                    child: MaterialButton(
                      color: CommonColors.chartColor,
                      onPressed: () {
                        createVision();
                      },
                      child: Text("Create Vision"),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void createVision() {
    final vision = VisionModel(
      visionBoardId: widget.visionBoardId,
      visionId: Uuid().v1(),
      imageUrl: widget.visionImageUrl,
      visionName: visionName,
      quote: null,
      createdAt: DateTime.now(),
      points: urgencyValue.toInt(),
      anotherVariable: null,
      isDeleted: false,
      isCompleted: false,
    );

    BlocProvider.of<VisionBoardBloc>(context).add(
      CreateVisionEvent(
        vision: vision,
      ),
    );
  }
}
