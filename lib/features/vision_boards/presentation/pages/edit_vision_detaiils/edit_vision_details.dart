import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/common_ui/custom_snackbar.dart';
import 'package:project_runway/core/common_ui/custom_text_field.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/storage_utils.dart';
import 'package:project_runway/features/vision_boards/data/models/vision_model.dart';
import 'package:project_runway/features/vision_boards/presentation/manager/bloc.dart';
import 'package:project_runway/features/vision_boards/presentation/pages/image_selector.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class EditVisionRoute extends StatefulWidget {
  static const String routeName = "${APP_NAME}_v1_image_selector";
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
  FILE_SELECTION_METHOD fileSelectionMethod;
  String visionImageUrl;
  PickedFile pickedFile;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final uploadState =
        Provider.of<VisionUploadProviderModel>(context, listen: false);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocListener<VisionBoardBloc, VisionBoardState>(
        listener: (_, state) {
          if (state is LoadedCreateVisionState) {
            Navigator.pop(context);
          }

          if (state is ErrorVisionBoardState) {
            // show the error
            _scaffoldKey.currentState.showSnackBar(
              CustomSnackbar.withAnimation(
                context,
                "Sorry, could not create your vision at the moment",
              ),
            );
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
                  Padding(
                    padding: const EdgeInsets.only(
                      top: CommonDimens.MARGIN_20,
                      bottom: CommonDimens.MARGIN_20,
                      left: CommonDimens.MARGIN_40,
                      right: CommonDimens.MARGIN_40,
                    ),
                    child: buildImage(context),
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
                      color: uploadState.response != null
                          ? CommonColors.chartColor
                          : CommonColors.disabledTaskTextColor,
                      onPressed: uploadState.response != null
                          ? () {
                              createVision();
                            }
                          : null,
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

  Widget buildImage(BuildContext providerContext) {
    final uploadState = Provider.of<VisionUploadProviderModel>(
      providerContext,
    );
    if (uploadState.response != null && uploadState.response.isNotEmpty) {
      return buildSelectedImageContainer(providerContext, uploadState);
    } else {
      if (fileSelectionMethod != null) {
        if (fileSelectionMethod == FILE_SELECTION_METHOD.CAMERA ||
            fileSelectionMethod == FILE_SELECTION_METHOD.GALLERY) {
          if (pickedFile != null) {
            return buildContainerForFileUpload(providerContext);
          } else {
            return buildAddImageContainer(providerContext);
          }
        } else {
          if (uploadState.response != null) {
            return buildSelectedImageContainer(providerContext, uploadState);
          } else {
            return buildAddImageContainer(providerContext);
          }
        }
      } else {
        return buildAddImageContainer(providerContext);
      }
    }
  }

  Widget buildSelectedImageContainer(
      BuildContext providerContext, VisionUploadProviderModel uploadState) {
    return Stack(
      children: <Widget>[
        Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
            color: CommonColors.disabledTaskTextColor,
          ),
          child: CachedNetworkImage(
            imageUrl: uploadState.response,
            height: 200,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (_, __, progress) {
              return Center(
                child: SizedBox(
                  height: 5,
                  child: LinearProgressIndicator(
                    value: progress.progress,
                  ),
                ),
              );
            },
          ),
        ),
        IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              buildChooseFromOptions(providerContext);
            }),
      ],
    );
  }

  void createVision() {
    final vision = VisionModel(
      visionBoardId: widget.visionBoardId,
      visionId: Uuid().v1(),
      imageUrl: Provider.of<VisionUploadProviderModel>(context, listen: false)
          .response,
      visionName: visionName,
      quote: null,
      createdAt: DateTime.now(),
      points: urgencyValue.toInt(),
      anotherVariable:
          Provider.of<VisionUploadProviderModel>(context, listen: false)
              .profileLink,
      isDeleted: false,
      isCompleted: false,
      profileImageUrl:
          Provider.of<VisionUploadProviderModel>(context, listen: false)
              .profileImageUrl,
      fullName: Provider.of<VisionUploadProviderModel>(context, listen: false)
          .fullName,
    );

    BlocProvider.of<VisionBoardBloc>(context).add(
      CreateVisionEvent(
        vision: vision,
      ),
    );
  }

  pickImageFromDevice(BuildContext providerContext) async {
    final ImagePicker _picker = ImagePicker();
    if (fileSelectionMethod == FILE_SELECTION_METHOD.CAMERA) {
      pickedFile = await _picker.getImage(
        source: ImageSource.camera,
      );
    } else if (fileSelectionMethod == FILE_SELECTION_METHOD.GALLERY) {
      pickedFile = await _picker.getImage(
        source: ImageSource.gallery,
      );
    }
    final uploadState =
        Provider.of<VisionUploadProviderModel>(providerContext, listen: false);
    if (pickedFile != null && pickedFile.path != null) {
      uploadState.assignResponse(null);
      StorageUtils.uploadFile(
          pickedFile.path, widget.visionBoardId, uploadState);
    }
  }

  Widget buildAddImageContainer(BuildContext providerContext) {
    return Material(
      child: InkWell(
        onTap: () {
          buildChooseFromOptions(providerContext);
        },
        child: Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
            color: CommonColors.disabledTaskTextColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Add Image",
                style: CommonTextStyles.taskTextStyle(context),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  left: CommonDimens.MARGIN_20 / 2,
                ),
                child: Icon(
                  Icons.photo_library,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContainerForFileUpload(BuildContext providerContext) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(
            10,
          ),
        ),
        color: CommonColors.disabledTaskTextColor,
      ),
      child: Center(
        child: LinearProgressIndicator(
          value: buildProgress(providerContext),
        ),
      ),
    );
  }

  double buildProgress(BuildContext providerContext) {
    int progress =
        Provider.of<VisionUploadProviderModel>(providerContext, listen: false)
            .progress;
    if (progress != null) {
      return progress.toDouble();
    } else {
      return 0;
    }
  }

  buildChooseFromOptions(BuildContext providerContext) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      context: context,
      builder: (_) => Container(
        color: CommonColors.scaffoldColor,
        height: MediaQuery.of(context).size.width * 1.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: CommonDimens.MARGIN_20,
            vertical: CommonDimens.MARGIN_60 / 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  bottom: CommonDimens.MARGIN_20,
                ),
                child: Text(
                  "Select a photo",
                  style: CommonTextStyles.taskTextStyle(context),
                ),
              ),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Material(
                    child: InkWell(
                      onTap: () async {
                        setState(() {
                          fileSelectionMethod = FILE_SELECTION_METHOD.UNSPLASH;
                        });
                        final result = await Navigator.pushNamed(
                            context, ImageSelectorRoute.routeName);
                        if (result != null) {
                          final uploadState =
                              Provider.of<VisionUploadProviderModel>(
                                  providerContext,
                                  listen: false);
                          List<String> responseArray = result;
                          try {
                            uploadState.assignResponse(responseArray[0]);
                            uploadState.profileImageUrl = responseArray[1];
                            uploadState.fullName = responseArray[2];
                            uploadState.profileLink = responseArray[3];
                          } catch (ex) {}
                          Navigator.pop(
                            context,
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: CommonDimens.MARGIN_20 / 2,
                          bottom: CommonDimens.MARGIN_20 / 2,
                        ),
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 3,
                              backgroundColor: CommonColors.chartColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: CommonDimens.MARGIN_20,
                              ),
                              child: Text("Select from our selection",
                                  style:
                                      CommonTextStyles.taskTextStyle(context)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Material(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          fileSelectionMethod = FILE_SELECTION_METHOD.CAMERA;
                        });
                        pickImageFromDevice(providerContext);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: CommonDimens.MARGIN_20 / 2,
                          bottom: CommonDimens.MARGIN_20 / 2,
                        ),
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 3,
                              backgroundColor: CommonColors.chartColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: CommonDimens.MARGIN_20,
                              ),
                              child: Text("Select from your Camera",
                                  style:
                                      CommonTextStyles.taskTextStyle(context)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Material(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          fileSelectionMethod = FILE_SELECTION_METHOD.GALLERY;
                        });
                        pickImageFromDevice(providerContext);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: CommonDimens.MARGIN_20 / 2,
                          bottom: CommonDimens.MARGIN_20 / 2,
                        ),
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 3,
                              backgroundColor: CommonColors.chartColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: CommonDimens.MARGIN_20,
                              ),
                              child: Text("Select from your Gallery",
                                  style:
                                      CommonTextStyles.taskTextStyle(context)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum FILE_SELECTION_METHOD {
  CAMERA,
  GALLERY,
  LINK,
  UNSPLASH,
  EMPTY,
}

class VisionUploadProviderModel extends ChangeNotifier {
  int progress;
  String response;
  String profileImageUrl;
  String fullName;
  String profileLink;

  void assignProgress(int value) {
    progress = value;
    notifyListeners();
  }

  void assignResponse(String response) {
    this.response = response;
    notifyListeners();
  }
}
