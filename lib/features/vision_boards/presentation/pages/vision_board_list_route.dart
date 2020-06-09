import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
          print(state.visionList.length);
        }

        if (state is ErrorVisionBoardState) {
          setState(() {
            visionBoards = null;
            isLoadingVisionBoards = false;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
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
          ],
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
        return buildLoadedList();
      }
    }
  }

  Widget buildLoadedList() {
    return Center(
      child: Column(
        children: <Widget>[
          Expanded(
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              itemBuilder: (_, index) {
                return CachedNetworkImage(
                  imageUrl: visions[index].imageUrl,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(_).size.width,
                );
              },
              staggeredTileBuilder: (int index) =>
                  StaggeredTile.count(1, index.isEven ? 2 : 1),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              itemCount: visions.length,
            ),
          ),
          MaterialButton(
            onPressed: () {
              moveToCreateVisionRoute();
            },
            child: Text(
              "Add More +",
              style: CommonTextStyles.taskTextStyle(context),
            ),
          ),
        ],
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
