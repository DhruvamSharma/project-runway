import 'package:flutter/material.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';

class AppIntroSpeakOrDrawWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: CommonDimens.MARGIN_80 / 2 + 10,
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Icon(
                    Icons.mic,
                    size: 150,
                  ),
                  Icon(
                    Icons.gesture,
                    size: 150,
                    color: CommonColors.chartColor,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: CommonDimens.MARGIN_60,
                ),
                child: Text(
                  "Speak or Draw",
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
                  "Our Machine Learning Models will translate them for you",
                  style: CommonTextStyles.taskTextStyle(context),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
