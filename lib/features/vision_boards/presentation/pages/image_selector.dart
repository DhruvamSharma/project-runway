import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/common_ui/custom_text_field.dart';
import 'package:project_runway/core/constants.dart';
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
        onPressed: () {
          Navigator.pop(context, [
            imageUrl,
            profileImageUrl,
            fullName,
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
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
              ),
              Expanded(
                flex: 5,
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
                                style: Theme.of(context).textTheme.display1,
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
          selectedIndex = index;
          imageUrl = result.urls.regular;
          profileImageUrl = result.user.profileImage.small;
          fullName = "${result.user.firstName} ${result.user.lastName}";
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
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      ClipRRect(
                        child: CachedNetworkImage(
                          imageUrl: result.user.profileImage.small,
                          height: 30,
                          width: 30,
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      SizedBox(width: 10.0),
                      Text(result.user.name),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
