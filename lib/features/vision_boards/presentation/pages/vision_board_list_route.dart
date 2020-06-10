import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/core/keys.dart';
import 'package:project_runway/features/login/data/models/user_model.dart';
import 'package:project_runway/features/login/domain/entities/user_entity.dart';
import 'package:project_runway/features/vision_boards/data/models/vision_board_model.dart';
import 'package:project_runway/features/vision_boards/data/models/vision_model.dart';
import 'package:project_runway/features/vision_boards/presentation/manager/bloc.dart';
import 'package:project_runway/features/vision_boards/presentation/pages/edit_vision_detaiils/edit_vision_details.dart';
import 'package:project_runway/features/vision_boards/presentation/pages/edit_vision_detaiils/edit_vision_details_args.dart';
import 'package:project_runway/features/vision_boards/presentation/pages/view_vision_details/view_vision_details.dart';
import 'package:project_runway/features/vision_boards/presentation/pages/view_vision_details/view_vision_details_args.dart';
import 'package:screenshot/screenshot.dart';
import 'package:uuid/uuid.dart';

class VisionBoardListRoute extends StatefulWidget {
  static const String routeName =
      "${APP_NAME}_v1_vision-board_vision-board-list";
  @override
  _VisionBoardListRouteState createState() => _VisionBoardListRouteState();
}

class _VisionBoardListRouteState extends State<VisionBoardListRoute> {
  UserEntity user;
  static const String screenName = "Vision";
  List<VisionBoardModel> visionBoards;
  List<VisionModel> visions;
  bool isLoadingVisionBoards = true;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool isTakingScreenshot = false;
  ScreenshotController _screenshotController = ScreenshotController();
  @override
  void initState() {
    user = UserModel.fromJson(
        json.decode(sharedPreferences.getString(USER_MODEL_KEY)));
    loadAllVisionBoards();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VisionBoardBloc, VisionBoardState>(
      listener: (_, state) {
        if (state is LoadedGetAllVisionBoardState) {
          setState(() {
            visionBoards = state.visionBoardList;
            isLoadingVisionBoards = false;
            if (visionBoards.isNotEmpty) {
              loadAllVisions(visionBoards[0].visionBoardId);
            }
          });
        }

        if (state is LoadedGetAllVisionState) {
          setState(() {
            visions = state.visionList;
          });
        }

        if (state is ErrorVisionBoardState) {
          setState(() {
            visionBoards = null;
            isLoadingVisionBoards = false;
          });
        }
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          key: _scaffoldKey,
          floatingActionButton:
              (visions == null || visions.length == TOTAL_VISIONS_LIMIT + 1)
                  ? Container()
                  : FloatingActionButton.extended(
                      onPressed: () {
                        moveToCreateVisionRoute();
                      },
                      label: Text(
                        "Add More",
                        style: CommonTextStyles.scaffoldTextStyle(context)
                            .copyWith(color: Colors.white),
                      )),
          body: Stack(
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
              buildRoute(),
              SizedBox(
                height: 52,
                child: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                ),
              ),
              FloatingActionButton(onPressed: () async {
                if (await Permission.storage.request().isGranted) {
                  setState(() {
                    isTakingScreenshot = true;
                  });
                  _screenshotController
                      .capture(
                    pixelRatio: 3.0,
                  )
                      .then((File image) async {
                    final result = await ImageGallerySaver.saveImage(
                        image.readAsBytesSync());
                    setState(() {
                      isTakingScreenshot = false;
                    }); // Save image to gallery,  Needs plugin  https://pub.dev/packages/image_gallery_saver
                  }).catchError((onError) {
                    print(onError);
                    setState(() {
                      isTakingScreenshot = false;
                    });
                  });
                }
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRoute() {
    if (isLoadingVisionBoards) {
      return buildLoadingList();
    } else {
      if (visionBoards == null || visionBoards.isEmpty) {
        return buildEmptyList();
      } else {
        if (visions == null || visions.isEmpty) {
          return buildLoadingList();
        } else {
          return buildLoadedList();
        }
      }
    }
  }

  Widget buildLoadedList() {
    return Center(
      child: Screenshot(
        controller: _screenshotController,
        child: StaggeredGridView.countBuilder(
          itemCount: visions.length,
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          staggeredTileBuilder: (index) =>
              new StaggeredTile.count(2, index.isEven ? 3.0 : 2.0),
          itemBuilder: (_, index) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  ViewVisionDetailsRoute.routeName,
                  arguments: ViewVisionDetailsArgs(
                    vision: visions[index],
                  ),
                );
              },
              child: Hero(
                tag: visions[index].imageUrl,
                child: Material(
                  child: Stack(
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: visions[index].imageUrl,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
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
                          height: 400,
                          child: visions[index].profileImageUrl != null
                              ? Row(
                                  children: <Widget>[
                                    ClipRRect(
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            visions[index].profileImageUrl,
                                        height: isTakingScreenshot ? 10 : 20,
                                        width: isTakingScreenshot ? 10 : 20,
                                      ),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    SizedBox(width: 10.0),
                                    AnimatedDefaultTextStyle(
                                      child: Text(
                                        visions[index].fullName,
                                      ),
                                      style: CommonTextStyles.scaffoldTextStyle(
                                              context)
                                          .copyWith(
                                              color: CommonColors.accentColor,
                                              fontSize:
                                                  isTakingScreenshot ? 10 : 14),
                                      duration: Duration(milliseconds: 200),
                                    ),
                                  ],
                                )
                              : Container(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildLoadingList() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: CommonDimens.MARGIN_60,
      ),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildEmptyList() {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            screenName.toUpperCase(),
            style: CommonTextStyles.headerTextStyle(context),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            top: CommonDimens.MARGIN_40,
            left: CommonDimens.MARGIN_20,
            right: CommonDimens.MARGIN_20,
          ),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              color: CommonColors.accentColor,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: CachedNetworkImage(
            imageUrl:
                "https://images.unsplash.com/photo-1507361617237-221d9f2c84f7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1106&q=80",
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: CommonDimens.MARGIN_40,
          ),
          child: Text(
            "Vision Boards",
            textAlign: TextAlign.center,
            style: CommonTextStyles.loginTextStyle(context),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: CommonDimens.MARGIN_20,
          ),
          child: Text(
            "keep your productivity\nAt an all-time high",
            textAlign: TextAlign.center,
            style: CommonTextStyles.taskTextStyle(context),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: CommonDimens.MARGIN_40,
          ),
          child: MaterialButton(
            onPressed: () async {
              createVisionBoard();
              moveToCreateVisionRoute();
            },
            child: Text("Create"),
            color: CommonColors.chartColor,
          ),
        ),
      ],
    );
  }

  void loadAllVisionBoards() {
    BlocProvider.of<VisionBoardBloc>(context).add(GetAllVisionBoardsEvent(
      userId: user.userId,
    ));
  }

  void createVisionBoard() {
    final visionBoard = VisionBoardModel(
      visionBoardId: Uuid().v1(),
      userId: user.userId,
      createdAt: DateTime.now(),
      quote: null,
      userQuote: null,
      points: null,
      imageUrl: null,
      isDeleted: false,
      isCompleted: false,
      anotherVariable: null,
    );

    visionBoards.add(visionBoard);

    BlocProvider.of<VisionBoardBloc>(context)
        .add(CreateVisionBoardEvent(visionBoard: visionBoard));
  }

  void moveToCreateVisionRoute() async {
    await Navigator.pushNamed(
      context,
      EditVisionRoute.routeName,
      arguments: EditVisionArgs(
          visionBoardId: visionBoards[0].visionBoardId, imageUrl: ""),
    );
    setState(() {
      isLoadingVisionBoards = true;
      loadAllVisionBoards();
    });
  }

  void loadAllVisions(String visionBoardId) {
    BlocProvider.of<VisionBoardBloc>(context)
        .add(GetAllVisionsEvent(visionBoardId: visionBoardId));
  }
}
