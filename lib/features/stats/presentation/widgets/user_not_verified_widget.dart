import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:provider/provider.dart';

class UserNotVerifiedWidget extends StatefulWidget {
  @override
  _UserNotVerifiedWidgetState createState() => _UserNotVerifiedWidgetState();
}

class _UserNotVerifiedWidgetState extends State<UserNotVerifiedWidget> {
  bool isLoadingAnimation = true;
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ThemeModel>(context, listen: false);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: CommonDimens.MARGIN_40,
              left: CommonDimens.MARGIN_20,
              right: CommonDimens.MARGIN_20,
            ),
            child: SizedBox(
              height: 300,
              child: AnimatedCrossFade(
                firstChild: Center(child: Padding(
                  padding: const EdgeInsets.only(top: CommonDimens.MARGIN_80 * 2, left: CommonDimens.MARGIN_40, right: CommonDimens.MARGIN_40,),
                  child: LinearProgressIndicator(),
                )),
                secondChild: Lottie.network(
                    "https://assets9.lottiefiles.com/packages/lf20_v4d0iG.json",
                    fit: BoxFit.cover,
                    height: 300,
                    onLoaded: (composition) {
                  setState(() {
                    isLoadingAnimation = false;
                  });
                }),
                crossFadeState: isLoadingAnimation
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: Duration(milliseconds: 300),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: CommonDimens.MARGIN_20,
              right: CommonDimens.MARGIN_20,
            ),
            child: Text(
              "Statistics tools not turned on",
              style: CommonTextStyles.loginTextStyle(context).copyWith(
                letterSpacing: 3,
                fontWeight: FontWeight.w900
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: CommonDimens.MARGIN_20,
              right: CommonDimens.MARGIN_20,
              top: CommonDimens.MARGIN_20,
            ),
            child: Text(
              "Go to Settings and link your account to see your stats",
              style: CommonTextStyles.taskTextStyle(context).copyWith(
                fontWeight: FontWeight.w200,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(CommonDimens.MARGIN_40),
            child: MaterialButton(
              child: Center(
                child: Text(
                  "Go Back",
                  style: CommonTextStyles.scaffoldTextStyle(context).copyWith(
                    fontSize: 18,
                  ),
                ),
              ),
              color: appState.currentTheme.accentColor,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}