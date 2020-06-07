import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/features/vision_boards/data/models/vision_model.dart';
import 'package:project_runway/features/vision_boards/presentation/manager/bloc.dart';
import 'package:project_runway/features/vision_boards/presentation/pages/edit_vision_detaiils/edit_vision_details.dart';
import 'package:project_runway/features/vision_boards/presentation/pages/edit_vision_detaiils/edit_vision_details_args.dart';

class CreateVisionBoardRoute extends StatefulWidget {
  static const String routeName =
      "${APP_NAME}_v1_vision-board_create-vision-board";
  final String visionBoardId;

  CreateVisionBoardRoute({
    @required this.visionBoardId,
  });

  @override
  _CreateVisionBoardRouteState createState() => _CreateVisionBoardRouteState();
}

class _CreateVisionBoardRouteState extends State<CreateVisionBoardRoute> {
  static const String screenName = "Create";
  List<VisionModel> visions;
  bool isLoadingVisions = true;
  @override
  void initState() {
    getAllVisions();
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
          if (state is LoadedGetAllVisionState) {
            setState(() {
              isLoadingVisions = false;
              visions = state.visionList;
            });
          }
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
                  if (isLoadingVisions)
                    SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator())),
                  SizedBox(
                    height: 200,
                    child: isLoadingVisions
                        ? Text(
                            "",
                            style: CommonTextStyles.loginTextStyle(context),
                          )
                        : Center(
                            child: Text(
                              visions.length.toString(),
                              style: CommonTextStyles.loginTextStyle(context),
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: CommonDimens.MARGIN_80,
                    ),
                    child: FlatButton(
                        onPressed: () async {
                          await Navigator.pushNamed(
                            context,
                            EditVisionRoute.routeName,
                            arguments: EditVisionArgs(
                              visionBoardId: widget.visionBoardId,
                            ),
                          );
                          setState(() {
                            isLoadingVisions = true;
                          });
                          getAllVisions();
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Add A Vision",
                              style: CommonTextStyles.loginTextStyle(context),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 4.0,
                                left: CommonDimens.MARGIN_20,
                              ),
                              child: Icon(Icons.add),
                            )
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: CommonDimens.MARGIN_40,
                    ),
                    child: Text(
                      "Adding a photo makes your goal\n"
                      "More approachable\n\n"
                      "You can add up to 10 Visions",
                      style: CommonTextStyles.taskTextStyle(context).copyWith(
                          color: CommonColors.disabledTaskTextColor,
                          fontSize: 18),
                      textAlign: TextAlign.center,
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

  void getAllVisions() {
    BlocProvider.of<VisionBoardBloc>(context)
        .add(GetAllVisionsEvent(visionBoardId: widget.visionBoardId));
  }
}
