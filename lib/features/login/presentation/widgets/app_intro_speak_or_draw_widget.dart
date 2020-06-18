import 'package:flutter/material.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';

class AppIntroSpeakOrDrawWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              left: CommonDimens.MARGIN_20,
              bottom: CommonDimens.MARGIN_20,
            ),
            child: Text(
              "Speak or\nDraw",
              style: CommonTextStyles.defineTextStyle(context),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(
                left: CommonDimens.MARGIN_20,
                right: CommonDimens.MARGIN_20,
              ),
              child: Container(
                color: CommonColors.scaffoldColor,
                height: MediaQuery.of(context).size.height / 2,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  color: CommonColors.darkGreyColor,
                  elevation: 24,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        CommonDimens.MARGIN_20,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          top: CommonDimens.MARGIN_40,
                          left: CommonDimens.MARGIN_20,
                          right: CommonDimens.MARGIN_20,
                        ),
                        child: Text(
                          "Our Machine Learning Models will translate them for you",
                          style: CommonTextStyles.taskTextStyle(context),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: CommonDimens.MARGIN_40,),
                        child: Row(
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
