import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/date_time_parser.dart';
import 'package:project_runway/features/vision_boards/data/models/vision_model.dart';
import 'package:project_runway/features/vision_boards/presentation/manager/bloc.dart';
import 'package:project_runway/features/vision_boards/presentation/pages/view_vision_details/view_vision_details.dart';
import 'package:project_runway/features/vision_boards/presentation/widgets/view_vision_board_details/complete_state.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewVisionBoardDetailsWidget extends StatelessWidget {
  final VisionModel vision;

  ViewVisionBoardDetailsWidget(this.vision);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MarVisionWidgetDirtyModel>(
      create: (_) => MarVisionWidgetDirtyModel(),
      child: Builder(
        builder: (providerContext) => Scaffold(
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
                      style: CommonTextStyles.taskTextStyle(context)
                          .copyWith(color: CommonColors.accentColor),
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Importance: ",
                          style:
                              CommonTextStyles.disabledTaskTextStyle().copyWith(
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: "${vision.points ?? "30"}",
                          style: CommonTextStyles.disabledTaskTextStyle()
                              .copyWith(
                                  fontWeight: FontWeight.w900, fontSize: 16),
                        ),
                      ]),
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Vision create on: ",
                          style:
                              CommonTextStyles.disabledTaskTextStyle().copyWith(
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: "${beautifyDate(vision.createdAt)}",
                          style:
                              CommonTextStyles.disabledTaskTextStyle().copyWith(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: CommonDimens.MARGIN_60 / 2),
                      child: VisionCompleteStatus(vision: vision),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: CommonDimens.MARGIN_20 / 2),
                      child: MaterialButton(
                        onPressed: () {
                          Provider.of<MarVisionWidgetDirtyModel>(
                                  providerContext,
                                  listen: false)
                              .isDirty = true;
                          final deletedVision =
                              changeDeletedStatus(!vision.isDeleted);
                          BlocProvider.of<VisionBoardBloc>(context)
                              .add(DeleteVisionEvent(vision: deletedVision));
                          Navigator.pop(context);
                          Navigator.pop(context, true);
                        },
                        color: Colors.white,
                        textColor: CommonColors.disabledTaskTextColor,
                        child: Text("Delete Vision"),
                      ),
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
                          height: 700,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.black, Colors.transparent],
                                begin: Alignment.bottomCenter,
                                end: Alignment.center,
                              ),
                            ),
                            child: vision.profileImageUrl != null
                                ? GestureDetector(
                                    onTap: () async {
                                      print(vision.anotherVariable);
                                      if (vision.anotherVariable != null &&
                                          await canLaunch(
                                              vision.anotherVariable)) {
                                        launch(vision.anotherVariable);
                                      }
                                    },
                                    child: Container(
                                      height: 50,
                                      color: Colors.transparent,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: CommonDimens.MARGIN_40 / 1.5,
                                          right: CommonDimens.MARGIN_20,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            ClipRRect(
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    vision.profileImageUrl,
                                                height: 20,
                                                width: 20,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                            SizedBox(width: 10.0),
                                            Text(
                                              vision.fullName,
                                              style: CommonTextStyles
                                                      .scaffoldTextStyle(
                                                          context)
                                                  .copyWith(
                                                      color: CommonColors
                                                          .accentColor),
                                            ),
                                            Expanded(
                                              child: Text(
                                                " On Unsplash",
                                                style: CommonTextStyles
                                                        .scaffoldTextStyle(
                                                            context)
                                                    .copyWith(
                                                        color: CommonColors
                                                            .accentColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
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
              SizedBox(
                height: 56,
                child: AppBar(
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(
                            context,
                            Provider.of<MarVisionWidgetDirtyModel>(
                                    providerContext,
                                    listen: false)
                                .isDirty);
                      }),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  VisionModel changeDeletedStatus(bool isDeleted) {
    return VisionModel(
      visionBoardId: vision.visionBoardId,
      visionId: vision.visionId,
      imageUrl: vision.imageUrl,
      visionName: vision.visionName,
      quote: vision.quote,
      createdAt: vision.createdAt,
      points: vision.points,
      anotherVariable: vision.anotherVariable,
      isDeleted: isDeleted,
      isCompleted: vision.isCompleted,
      profileImageUrl: vision.profileImageUrl,
      fullName: vision.fullName,
    );
  }
}
