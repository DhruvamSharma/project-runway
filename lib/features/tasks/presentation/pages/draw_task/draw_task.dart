import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/common_ui/custom_snackbar.dart';
import 'package:project_runway/core/common_ui/under_maintainance_widget.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/core/remote_config/remote_config_service.dart';
import 'package:project_runway/features/tasks/presentation/pages/draw_task/task_painter.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class DrawTaskRoute extends StatelessWidget {
  static const String routeName = "${APP_NAME}_v1_tasks_draw-task";
  final RemoteConfigService _remoteConfigService = sl<RemoteConfigService>();

  final TextRecognizer textRecognizer =
      FirebaseVision.instance.textRecognizer();
  final ScreenshotController _screenshotController = ScreenshotController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ChangeNotifierProvider<DrawingPointsModel>(
        create: (_) => DrawingPointsModel(),
        child: Builder(
          builder: (providerContext) => buildRoute(providerContext),
        ),
      ),
    );
  }

  Widget buildRoute(BuildContext context) {
    if (_remoteConfigService.drawTaskEnabled) {
      return drawingWidget(context);
    } else {
      return UnderMaintenanceWidget();
    }
  }

  Widget drawingWidget(BuildContext providerContext) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onPanUpdate: (dragUpdateDetails) {
            Provider.of<DrawingPointsModel>(providerContext, listen: false)
                .assignOffset(dragUpdateDetails.globalPosition);
          },
          onPanStart: (dragUpdateDetails) {
            Provider.of<DrawingPointsModel>(providerContext, listen: false)
                .assignOffset(dragUpdateDetails.globalPosition);
          },
          onPanEnd: (dragUpdateDetails) {
            Provider.of<DrawingPointsModel>(providerContext, listen: false)
                .assignOffset(null);
          },
          child: Screenshot(
            controller: _screenshotController,
            child: Center(
              child: CustomPaint(
                painter: TaskPainter(
                    offsets: Provider.of<DrawingPointsModel>(
                  providerContext,
                ).offsets),
                child: Container(
                  height: MediaQuery.of(providerContext).size.height,
                  width: MediaQuery.of(providerContext).size.width,
                ),
              ),
            ),
          ),
        ),
        SafeArea(
          child: SizedBox(
            child: AppBar(
              backgroundColor: Colors.transparent,
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      Provider.of<DrawingPointsModel>(providerContext,
                              listen: false)
                          .clearOffsets();
                    }),
              ],
            ),
            height: 52,
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "* Text sometimes might not be accurately recognised",
              style: CommonTextStyles.disabledTaskTextStyle()
                  .copyWith(fontSize: 12),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(
              right: CommonDimens.MARGIN_20,
              bottom: CommonDimens.MARGIN_20,
            ),
            child: FloatingActionButton(
              onPressed: () async {
                mlTheHellOutOfImage(providerContext);
              },
              mini: true,
              child: Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }

  void mlTheHellOutOfImage(BuildContext context) async {
    _screenshotController
        .capture(
      pixelRatio: 5.0,
      delay: Duration(milliseconds: 500),
    )
        .then((File imageFile) async {
      final visionImage = FirebaseVisionImage.fromFile(imageFile);
      final VisionText visionText =
          await textRecognizer.processImage(visionImage);
      String taskTitle = "";
      for (TextBlock block in visionText.blocks) {
        final String text = block.text;
        taskTitle += text;
        taskTitle += " ";
      }
      showFinalText(taskTitle.trim(), context);
    }).catchError((onError) {
      print(onError);
    });
  }

  void showFinalText(String taskTitle, BuildContext context) async {
    if (taskTitle == null || taskTitle.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        CustomSnackbar.withAnimation(
          context,
          "Your task title is empty",
        ),
      );
    } else {
      await showModalBottomSheet(
        context: context,
        builder: (_) => Container(
          color: CommonColors.bottomSheetColor,
          height: 200,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(CommonDimens.MARGIN_20),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Your Task Title:      ",
                    style: CommonTextStyles.taskTextStyle(context),
                  ),
                  Expanded(
                    child: Text(
                      taskTitle,
                      style: CommonTextStyles.taskTextStyle(context),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: CommonDimens.MARGIN_40,
                ),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(taskTitle);
                  },
                  color: Colors.black,
                  child: Text("Confirm Title"),
                ),
              ),
            ],
          ),
        ),
      );
      Navigator.pop(context, taskTitle);
    }
  }
}

class DrawingPointsModel extends ChangeNotifier {
  final offsets = <Offset>[];
  String recognisedText;
  assignOffset(Offset offset) {
    offsets.add(offset);
    notifyListeners();
  }

  clearOffsets() {
    offsets.clear();
    notifyListeners();
  }
}
