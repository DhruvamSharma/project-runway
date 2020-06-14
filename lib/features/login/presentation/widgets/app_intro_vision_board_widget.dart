import 'package:flutter/material.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';

class AppIntroVisionBoardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: CommonDimens.MARGIN_20,
      ),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.grid_on,
            size: 200,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: CommonDimens.MARGIN_60,
            ),
            child: Text(
              "Vision Boards",
              style: CommonTextStyles.loginTextStyle(
                context,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: CommonDimens.MARGIN_20,
              left: CommonDimens.MARGIN_20 / 2,
              right: CommonDimens.MARGIN_20 / 2,
            ),
            child: Text(
              "Build your yearly goals into your subconscious mind",
              style: CommonTextStyles.taskTextStyle(context),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
