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
import 'package:project_runway/features/vision_boards/presentation/manager/photos_bloc.dart';

class ImageSelectorRoute extends StatefulWidget {
  static const String routeName = "${APP_NAME}_v1";
  @override
  _ImageSelectorRouteState createState() => _ImageSelectorRouteState();
}

class _ImageSelectorRouteState extends State<ImageSelectorRoute> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  int selectedIndex;
  String imageUrl;
  String profileImageUrl;
  String fullName;
  String downloadLink;
  String profileLink;
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
          triggerDownloadEventForUnsplash();
          Navigator.pop(context, [
            imageUrl,
            profileImageUrl,
            fullName,
            profileLink,
          ]);
        },
        label: Text(
          "Copy image",
          style: CommonTextStyles.scaffoldTextStyle(context)
              .copyWith(color: Colors.white),
        ),
      ),
      body: Center(
        child: Container(
          child: Column(
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
                  isRequired: false,
                  onValueChange: (value) {
                    bloc.changeQuery(value);
                  },
                ),
              ),
              Expanded(
                child: StreamBuilder(
                    stream: bloc.photosList(),
                    builder: (context, AsyncSnapshot<Photos> snapshot) {
                      if (snapshot.connectionState == ConnectionState.active &&
                          !snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data.results.length,
                            itemBuilder: (context, index) {
                              return listItem(
                                  snapshot.data.results[index], index);
                            });
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 20.0),
                              Flexible(
                                  child: Text(
                                'Type a word',
                                style: CommonTextStyles.disabledTaskTextStyle(),
                              ))
                            ],
                          ),
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listItem(Result result, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          downloadLink = result.links.downloadLocation;
          profileLink =
              "https://unsplash.com/@${result.user.username}?utm_source=$APP_NAME&utm_medium=referral";
          imageUrl = result.urls.regular;
          selectedIndex = index;
          profileImageUrl = result.user.profileImage.small;
          fullName = buildFirstName(result.user);
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
              color: index == selectedIndex ? Colors.white : Colors.transparent,
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
                            "${result.user.firstName} ${result.user.lastName} on Unsplash",
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

  void triggerDownloadEventForUnsplash() async {
    try {
      await http.get("$downloadLink?client_id=$UNSPLASH_KEY");
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
