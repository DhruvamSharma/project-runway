import 'dart:convert';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_runway/core/analytics_utils.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/common_ui/custom_snackbar.dart';
import 'package:project_runway/core/common_ui/under_maintainance_widget.dart';
import 'package:project_runway/core/common_ui/user_not_verified_widget.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/core/keys/keys.dart';
import 'package:project_runway/core/remote_config/remote_config_service.dart';
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
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class VisionBoardListRoute extends StatefulWidget {
  static const String routeName =
      "${APP_NAME}_v1_vision-board_vision-board-list";
  final int pageNumber;

  VisionBoardListRoute(this.pageNumber);

  @override
  _VisionBoardListRouteState createState() => _VisionBoardListRouteState();
}

class _VisionBoardListRouteState extends State<VisionBoardListRoute> {
  UserEntity user;
  final RemoteConfigService _remoteConfigService = sl<RemoteConfigService>();
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
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // To turn off landscape mode
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
            isLoadingVisionBoards = false;
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
      child: buildRoute(),
    );
  }

  Widget buildRoute() {
    if (_remoteConfigService.visionBoardEnabled) {
      if (user.isVerified) {
        return visionBoardPageRoute();
      } else {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Padding(
              padding: const EdgeInsets.only(
                top: CommonDimens.MARGIN_40,
              ),
              child: UserNotVerifiedWidget("Vision Board"),
            ));
      }
    } else {
      return Scaffold(body: UnderMaintenanceWidget());
    }
  }

  void showVisionBoardInfo() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return Container(
            height: 700,
            padding: const EdgeInsets.symmetric(
              horizontal: CommonDimens.MARGIN_20,
              vertical: CommonDimens.MARGIN_40,
            ),
            decoration: BoxDecoration(
              color: CommonColors.bottomSheetColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(CommonDimens.MARGIN_20),
                topRight: Radius.circular(
                  CommonDimens.MARGIN_20,
                ),
              ),
            ),
            child: Column(
              children: [
                Text(
                  "What is a Vision Board?",
                  style: CommonTextStyles.loginTextStyle(context),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: CommonDimens.MARGIN_40,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          CommonDimens.MARGIN_20 / 2,
                        ),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: SizedBox(
                      height: 250,
                      child: buildVisionItem(
                        "https://images.unsplash.com/photo-1504805572947-34fad45aed93?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
                        "Clark Tibbs on Unsplash",
                        false,
                        "https://images.unsplash.com/profile-1539490885789-925542b900c4?dpr=1&auto=format&fit=crop&w=150&h=150&q=60&crop=faces&bg=fff",
                      ),
                    ),
                  ),
                ),
                Text(
                  "A vision board or dream board is a collage of images, pictures, and affirmations of one's dreams and desires, designed to serve as a source of inspiration and motivation, and to use the law of attraction to attain goals.",
                  style: CommonTextStyles.taskTextStyle(context),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () async {
                      final sourceLink =
                          "https://en.wikipedia.org/wiki/Dream_board";
                      if (await canLaunch(sourceLink)) {
                        launch(sourceLink);
                      }
                    },
                    child: Text(
                      "Source",
                      style: CommonTextStyles.linkTextStyle(context),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void saveVisionBoardToGallery() async {
    try {
      AnalyticsUtils.sendAnalyticEvent(
          DOWNLOAD_VISION_BOARD,
          {
            "vision count": visions.length.toString(),
          },
          "DOWNLOAD_VISION_BOARD");
    } catch (Ex) {}
    if (await Permission.storage.request().isGranted) {
      // To turn off landscape mode
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft]);
      setState(() {
        isTakingScreenshot = true;
      });
      _screenshotController
          .capture(
        pixelRatio: 5.0,
        delay: Duration(milliseconds: 500),
      )
          .then((File image) async {
        await ImageGallerySaver.saveImage(image.readAsBytesSync());
        setState(() {
          isTakingScreenshot = false;
        }); // Save image to gallery,  Needs plugin  https://pub.dev/packages/image_gallery_saver
        _scaffoldKey.currentState.removeCurrentSnackBar();
        _scaffoldKey.currentState.showSnackBar(
          CustomSnackbar.withAnimation(
            context,
            "Image saved to Gallery",
          ),
        );
      }).catchError((onError) {
        print(onError);
        setState(() {
          isTakingScreenshot = false;
        });
      });
      // To turn off landscape mode
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp]);
    }
  }

  Widget buildVisionBoardRoute() {
    if (isLoadingVisionBoards) {
      return buildLoadingList();
    } else {
      if (visionBoards == null ||
          visionBoards.isEmpty ||
          (visions != null && visions.isEmpty)) {
        return buildEmptyList();
      } else {
        if (visions == null) {
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
          crossAxisCount:
              MediaQuery.of(context).orientation == Orientation.landscape
                  ? 5
                  : 2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          shrinkWrap:
              MediaQuery.of(context).orientation == Orientation.landscape
                  ? true
                  : false,
          staggeredTileBuilder: (index) => new StaggeredTile.count(
              1,
              MediaQuery.of(context).orientation == Orientation.landscape
                  ? (index.isEven ? 1.0 : 1.5)
                  : (index.isEven ? 2.0 : 1.0)),
          itemBuilder: (_, index) {
            return GestureDetector(
              onTap: () async {
                final response = await Navigator.pushNamed(
                  context,
                  ViewVisionDetailsRoute.routeName,
                  arguments: ViewVisionDetailsArgs(
                    vision: visions[index],
                  ),
                );
                if (response != null && (response as bool) != false) {
                  setState(() {
                    isLoadingVisionBoards = true;
                    loadAllVisionBoards();
                  });
                }
              },
              child: Hero(
                tag: visions[index].imageUrl,
                child: Material(
                  child: buildVisionItem(
                    visions[index].imageUrl,
                    visions[index].fullName,
                    visions[index].isCompleted,
                    visions[index].profileImageUrl,
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
    return Padding(
      padding: const EdgeInsets.only(
        top: CommonDimens.MARGIN_80,
      ),
      child: Stack(
        children: [
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
                Card(
                  margin: const EdgeInsets.only(
                    top: CommonDimens.MARGIN_40,
                    left: CommonDimens.MARGIN_20,
                    right: CommonDimens.MARGIN_20,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://images.unsplash.com/photo-1507361617237-221d9f2c84f7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1106&q=80",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: CommonDimens.MARGIN_60,
                  ),
                  child: SizedBox(
                    width: 200,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Build",
                            style: CommonTextStyles.taskTextStyle(context)),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: CommonDimens.MARGIN_20),
                            child: RotateAnimatedTextKit(
                              totalRepeatCount: 4,
                              repeatForever:
                                  true, //this will ignore [totalRepeatCount]
                              pause: Duration(milliseconds: 1000),
                              text: ["VISIONS", "GOALS", "ABILITY"],
                              textStyle: GoogleFonts.anton().copyWith(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 28,
                                  color: CommonColors.chartColor),
                              displayFullTextOnTap:
                                  true, // or Alignment.topLeft
                            ),
                          ),
                        ),
                      ],
                    ),
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
                if (visionBoards.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: CommonDimens.MARGIN_40,
                    ),
                    child: Tooltip(
                      message: "Create a vision board",
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              CommonDimens.MARGIN_20,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          createVisionBoard();
                          moveToCreateVisionRoute();
                        },
                        child: Text("Create"),
                        color: CommonColors.chartColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(
                CommonDimens.MARGIN_20,
              ),
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.white,
                child: Center(
                  child: IconButton(
                      tooltip: "Download the vision board",
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.all(0),
                      icon: Text("i"),
                      onPressed: showVisionBoardInfo),
                ),
              ),
            ),
          ),
        ],
      ),
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

  Widget visionBoardPageRoute() {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: (!(visions == null ||
              visions.length >= _remoteConfigService.maxVisionLimit + 1))
          ? FloatingActionButton.extended(
              tooltip: "Add visions to the vision board",
              heroTag: "action_button_${widget.pageNumber}",
              onPressed: () {
                moveToCreateVisionRoute();
              },
              label: Text(
                "Add More",
                style: CommonTextStyles.scaffoldTextStyle(context)
                    .copyWith(color: Colors.white),
              ))
          : Container(),
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
          buildVisionBoardRoute(),
          SafeArea(
            child: SizedBox(
              height: 56,
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
          if (visions != null && visions.isNotEmpty)
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: CommonDimens.MARGIN_20 * 2,
                  right: CommonDimens.MARGIN_20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.black,
                      child: Center(
                        child: IconButton(
                            tooltip: "Download the vision board",
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.all(0),
                            icon: Text("i"),
                            onPressed: showVisionBoardInfo),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: CommonDimens.MARGIN_20 / 2),
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.black,
                        child: Center(
                          child: IconButton(
                              tooltip: "Download the vision board",
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.all(0),
                              icon: Icon(
                                Icons.save_alt,
                                size: 20,
                              ),
                              onPressed: saveVisionBoardToGallery),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  buildVisionItem(String imageUrl, String fullName, bool isCompleted,
      String profileImageUrl) {
    return Stack(
      children: <Widget>[
        CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        if (isCompleted)
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(
                  right: CommonDimens.MARGIN_20 / 2,
                  top: CommonDimens.MARGIN_20 / 2),
              child: CircleAvatar(
                  backgroundColor: CommonColors.chartColor,
                  radius: 10,
                  child: Center(
                      child: Icon(
                    Icons.check,
                    size: 14,
                  ))),
            ),
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
            child: profileImageUrl != null
                ? Row(
                    children: <Widget>[
                      ClipRRect(
                        child: CachedNetworkImage(
                          imageUrl: profileImageUrl,
                          height: isTakingScreenshot ? 10 : 15,
                          width: isTakingScreenshot ? 10 : 15,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(width: 10.0),
                            Expanded(
                              child: Text(
                                fullName,
                                style: CommonTextStyles.badgeTextStyle(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(),
          ),
        ),
      ],
    );
  }
}
