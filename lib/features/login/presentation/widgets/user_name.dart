import 'package:flutter/material.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/common_ui/custom_text_field.dart';
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
            "Your turn now, \nwhat's your name?".toUpperCase(),
            style: CommonTextStyles.taskTextStyle(context),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: CommonDimens.MARGIN_60,
            ),
            child: CustomTextField(
              null,
              null,
              label: "Your Name",
              initialText: userEntryState.userName,
              onValueChange: (userName) {
                userEntryState.assignUserName(userName);
              },
            ),
          ),
        ],
      ),
    );
  }
}
