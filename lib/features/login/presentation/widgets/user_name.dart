import 'package:flutter/material.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/common_ui/custom_text_field.dart';
import 'package:project_runway/core/notifications/local_notifications.dart';
import 'package:project_runway/features/login/presentation/pages/user_entry_route.dart';
import 'package:provider/provider.dart';

class UserNameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userEntryState = Provider.of<UserEntryProviderHolder>(context);
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
              top: CommonDimens.MARGIN_60,
            ),
            child: MaterialButton(
              color: CommonColors.accentColor,
              child: Text(
                "Let us remind you",
                style: CommonTextStyles.scaffoldTextStyle(context),
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
                  Provider.of<UserEntryProviderHolder>(context, listen: false)
                      .assignNotificationTime(timeOfDay);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
