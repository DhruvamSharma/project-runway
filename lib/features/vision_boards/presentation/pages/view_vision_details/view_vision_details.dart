import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/date_time_parser.dart';
import 'package:project_runway/features/vision_boards/data/models/vision_model.dart';

class ViewVisionDetailsRoute extends StatelessWidget {
  final VisionModel vision;
  static const String routeName = "${APP_NAME}_v1_vision-board_vision-details";
  ViewVisionDetailsRoute({
    @required this.vision,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: DraggableScrollableSheet(
        expand: false,
        builder: (_, controller) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: CommonColors.chartColor,
            ),
            child: ListView(
              shrinkWrap: true,
              controller: controller,
              padding: const EdgeInsets.all(
                CommonDimens.MARGIN_20,
              ),
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.arrow_upward,
                    size: 14,
                  ),
                ),
                Text(
                  vision.visionName ?? "Your Vision",
                  style: CommonTextStyles.taskTextStyle(context).copyWith(),
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: "Importance: ",
                      style: CommonTextStyles.disabledTaskTextStyle().copyWith(
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: "${vision.points ?? "30"}",
                      style: CommonTextStyles.disabledTaskTextStyle()
                          .copyWith(fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                  ]),
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: "Vision create on: ",
                      style: CommonTextStyles.disabledTaskTextStyle().copyWith(
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: "${beautifyDate(vision.createdAt)}",
                      style: CommonTextStyles.disabledTaskTextStyle().copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          );
        },
        initialChildSize: 0.20,
        minChildSize: 0.20,
        maxChildSize: 0.5,
      ),
      body: Stack(
        children: <Widget>[
          Hero(
            tag: vision.imageUrl,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.80,
              child: Material(
                child: Stack(
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: vision.imageUrl,
                      height: 600,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.topRight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black, Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.center,
                          ),
                        ),
                        child: vision.profileImageUrl != null
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  top: CommonDimens.MARGIN_40 / 1.5,
                                  right: CommonDimens.MARGIN_20,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    ClipRRect(
                                      child: CachedNetworkImage(
                                        imageUrl: vision.profileImageUrl,
                                        height: 20,
                                        width: 20,
                                      ),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    SizedBox(width: 10.0),
                                    Text(
                                      vision.fullName,
                                      style: CommonTextStyles.scaffoldTextStyle(
                                              context)
                                          .copyWith(
                                              color: CommonColors.accentColor),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
