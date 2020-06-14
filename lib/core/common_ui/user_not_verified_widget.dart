import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';

class UserNotVerifiedWidget extends StatefulWidget {
  final String title;

  UserNotVerifiedWidget(this.title);

  @override
  _UserNotVerifiedWidgetState createState() => _UserNotVerifiedWidgetState();
}

class _UserNotVerifiedWidgetState extends State<UserNotVerifiedWidget> {
  bool isLoadingAnimation = true;
  @override
  Widget build(BuildContext context) {
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
                firstChild: Center(
                    child: Padding(
                  padding: const EdgeInsets.only(
                    top: CommonDimens.MARGIN_80 * 2,
                    left: CommonDimens.MARGIN_40,
                    right: CommonDimens.MARGIN_40,
                  ),
                  child: LinearProgressIndicator(),
                )),
                secondChild: Lottie.asset(
                    "assets/account_not_linked_animation.json",
                    fit: BoxFit.cover,
                    repeat: false,
                    height: 300, onLoaded: (composition) {
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
              top: CommonDimens.MARGIN_40,
              left: CommonDimens.MARGIN_20,
              right: CommonDimens.MARGIN_20,
            ),
            child: Text(
              "${widget.title} not turned on".toUpperCase(),
              style: CommonTextStyles.loginTextStyle(context),
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
              "Go to Settings and link your account to access",
              style: CommonTextStyles.taskTextStyle(context).copyWith(
                fontWeight: FontWeight.w200,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
