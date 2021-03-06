import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/common_ui/custom_text_field.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/keys/keys.dart';
import 'package:project_runway/features/vision_boards/data/models/retreived_photo_model.dart';
import 'package:project_runway/features/vision_boards/data/repositories/photo_repository.dart';
import 'package:project_runway/features/vision_boards/data/repositories/photos_state.dart';
import 'package:project_runway/features/vision_boards/presentation/manager/photos_bloc.dart';
import 'package:provider/provider.dart';

class ImageSelectorRoute extends StatefulWidget {
  static const String routeName = "${APP_NAME}_v1";
  @override
  _ImageSelectorRouteState createState() => _ImageSelectorRouteState();
}

class _ImageSelectorRouteState extends State<ImageSelectorRoute> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    bloc.init();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PhotoSelector>(
      create: (_) => PhotoSelector(),
      child: Builder(
        builder: (BuildContext providerContext) {
          final photoState =
              Provider.of<PhotoSelector>(providerContext, listen: false);
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text(''),
              automaticallyImplyLeading: true,
              elevation: 0.0,
              backgroundColor: Colors.transparent,
            ),
            floatingActionButton: FloatingActionButton.extended(
              tooltip: "Select the image",
              onPressed: () {
                triggerDownloadEventForUnsplash(photoState);
                Navigator.pop(context, [
                  photoState.imageUrl,
                  photoState.profileImageUrl,
                  photoState.fullName,
                  photoState.profileLink,
                ]);
              },
              label: Text(
                "Copy image",
                style: CommonTextStyles.scaffoldTextStyle(context)
                    .copyWith(color: Colors.white),
              ),
            ),
            body: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: CommonDimens.MARGIN_40,
                      vertical: CommonDimens.MARGIN_20,
                    ),
                    child: CustomTextField(
                      null,
                      null,
                      label: "Search",
                      trailingWidget: IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: Icon(
                            Icons.search,
                            size: 21,
                            color: CommonColors.accentColor,
                          ),
                          onPressed: () {
                            bloc.findPhotos(photoState.query);
                          }),
                      isRequired: false,
                      onValueChange: (query) {
                        photoState.query = query;
                      },
                      onSubmitted: (query) {
                        photoState.query = query;
                        bloc.findPhotos(query);
                      },
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<Photos>(
                      stream: bloc.photosList(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.results.isEmpty) {
                            return Center(
                              child: Text(
                                "No pictures found. Please change the keyword",
                                style: CommonTextStyles.loginTextStyle(context),
                                textAlign: TextAlign.center,
                              ),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: snapshot.data.results.length,
                              itemBuilder: (_, index) {
                                return listItem(snapshot.data.results[index],
                                    index, photoState);
                              },
                            );
                          }
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: Text(
                            "Search for a picture",
                            style: CommonTextStyles.loginTextStyle(context),
                          ));
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget listItem(Result result, int index, PhotoSelector photoState) {
    return GestureDetector(
      onTap: () {
        setState(() {
          photoState.downloadLink = result.links.downloadLocation;
          photoState.profileLink =
              "https://unsplash.com/@${result.user.username}?utm_source=$APP_NAME&utm_medium=referral";
          photoState.imageUrl = result.urls.regular;
          photoState.assignSelectedIndex(index);
          photoState.profileImageUrl = result.user.profileImage.small;
          photoState.fullName = buildFirstName(result.user);
        });
      },
      child: SizedBox(
        height: 200,
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(
              color: index == photoState.selectedIndex
                  ? Colors.white
                  : Colors.transparent,
              width: 2,
            ),
          ),
          elevation: 10.0,
          margin: EdgeInsets.all(16.0),
          child: Stack(
            children: <Widget>[
              Container(
                child: CachedNetworkImage(
                  imageUrl: result.urls.regular,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
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
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          child: CachedNetworkImage(
                            imageUrl: result.user.profileImage.small,
                            height: 20,
                            width: 20,
                          ),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: Text(
                            "${buildFirstName(result.user)} on Unsplash",
                            style: CommonTextStyles.scaffoldTextStyle(context)
                                .copyWith(color: CommonColors.accentColor),
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void triggerDownloadEventForUnsplash(PhotoSelector photoState) async {
    try {
      await http.get("${photoState.downloadLink}?client_id=$UNSPLASH_KEY");
    } catch (ex) {
      // Do nothing
    }
  }

  String buildFirstName(User user) {
    if (user.lastName != null) {
      return "${user.firstName} ${user.lastName}";
    } else {
      return user.firstName;
    }
  }
}

class PhotoSelector extends ChangeNotifier {
  int selectedIndex;
  String imageUrl;
  String profileImageUrl;
  String fullName;
  String downloadLink;
  String profileLink;
  String query;

  assignSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
