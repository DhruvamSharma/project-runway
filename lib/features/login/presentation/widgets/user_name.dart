import 'package:flutter/material.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/common_ui/custom_text_field.dart';
import 'package:project_runway/core/notifications/local_notifications.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:project_runway/features/login/presentation/pages/user_entry_route.dart';
import 'package:provider/provider.dart';

class UserNameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeModel appState = context.watch<ThemeModel>();
    final userEntryModel = context.watch<UserEntryProviderHolder>();
    return Padding(
      padding: const EdgeInsets.all(
        CommonDimens.MARGIN_20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Select a time\n\n".toUpperCase(),
            style: CommonTextStyles.defineTextStyle(context),
            textAlign: TextAlign.center,
          ),
          Text(
            "This will help you build your own runway to success".toUpperCase(),
            style: CommonTextStyles.taskTextStyle(context),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: CommonDimens.MARGIN_20 * 4,
            ),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(CommonDimens.MARGIN_20))),
              child: MaterialButton(
                padding: const EdgeInsets.symmetric(
                  horizontal: CommonDimens.MARGIN_40,
                  vertical: CommonDimens.MARGIN_20 / 2,
                ),
                onPressed: () async {
                  TimeOfDay timeOfDay = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.dark().copyWith(
                            accentColor:
                                CommonColors.chartColor.withOpacity(0.50),
                          ),
                          child: child,
                        );
                      });
                  if (timeOfDay != null) {
                    scheduleDailyNotification(context, timeOfDay);
                    userEntryModel.assignNotificationTime(timeOfDay);
                  }
                },
                child: Text(
                  "Let us remind you",
                  style: CommonTextStyles.taskTextStyle(context).copyWith(
                    color: buildButtonTextColor(appState, userEntryModel),
                  ),
                ),
                color: buildButtonColor(appState, userEntryModel),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color buildButtonColor(
      ThemeModel appState, UserEntryProviderHolder userEntryState) {
    if (userEntryState.time == null) {
      return appState.currentTheme.accentColor;
    } else {
      return CommonColors.chartColor;
    }
  }

  Color buildButtonTextColor(
      ThemeModel appState, UserEntryProviderHolder userEntryState) {
    if (userEntryState.time == null) {
      return appState.currentTheme.scaffoldBackgroundColor;
    } else {
      return appState.currentTheme.accentColor;
    }
  }
}
