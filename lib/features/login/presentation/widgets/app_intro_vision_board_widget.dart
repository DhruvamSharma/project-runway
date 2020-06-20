import 'package:flutter/material.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';

class AppIntroVisionBoardWidget extends StatelessWidget {
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
              "Vision\nBoards",
              style: CommonTextStyles.defineTextStyle(context),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(
                left: CommonDimens.MARGIN_20,
                right: CommonDimens.MARGIN_20,
                top: CommonDimens.MARGIN_20,
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
                  child: Container(
                    width: MediaQuery.of(context).size.width,
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
                            "Build your yearly goals into your subconscious mind",
                            style: CommonTextStyles.taskTextStyle(context),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: CommonDimens.MARGIN_20,
                              top: CommonDimens.MARGIN_40,
                            ),
                            child: Icon(
                              Icons.grid_on,
                              size: 150,
                            ),
                          ),
                        ),
                      ],
                    ),
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
