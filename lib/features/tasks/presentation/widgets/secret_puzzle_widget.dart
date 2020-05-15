import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/common_ui/custom_text_field.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/theme/theme.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:provider/provider.dart';

class SecretPuzzleWidget extends StatefulWidget {
  static const String routeName = "${APP_NAME}_v1_user_secret-puzzle";
  @override
  _SecretPuzzleWidgetState createState() => _SecretPuzzleWidgetState();
}

class _SecretPuzzleWidgetState extends State<SecretPuzzleWidget> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ThemeModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: RotatedBox(
              quarterTurns: 3,
              child: Text(
                APP_NAME.toUpperCase(),
                style: CommonTextStyles.rotatedDesignTextStyle(context),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              "Secret".toUpperCase(),
              style: CommonTextStyles.headerTextStyle(context),
              textAlign: TextAlign.center,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    "Congratulations",
                    style: CommonTextStyles.loginTextStyle(context),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: CommonDimens.MARGIN_20,
                      right: CommonDimens.MARGIN_20,
                    ),
                    child: Text(
                      "Here is your secret puzzle 50 points",
                      style: CommonTextStyles.taskTextStyle(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: CommonDimens.MARGIN_60,
                      vertical: CommonDimens.MARGIN_20,
                    ),
                    child: CustomTextField(
                      null,
                      null,
                      isRequired: true,
                      label: "Answer",
                      type: TextInputType.number,
                      textInputFormatter: [
                        LengthLimitingTextInputFormatter(2),
                        WhitelistingTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(
                      CommonDimens.MARGIN_20,
                    ),
                    child: SizedBox(
                      height: 200,
                      child: CachedNetworkImage(imageUrl: appState.currentTheme != lightTheme
                          ? "https://imgur.com/ugK9wk9.png"
                          : "https://imgur.com/iYd1xS1.png"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text("Submit Answer"),
        icon: Icon(Icons.all_inclusive),
      ),
    );
  }
}
