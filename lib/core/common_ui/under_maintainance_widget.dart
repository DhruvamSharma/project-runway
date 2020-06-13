import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';

class UnderMaintenanceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 300,
          width: double.infinity,
          child: Lottie.asset("assets/under_maintenance_animation.json",
              repeat: false, reverse: true, fit: BoxFit.fill),
        ),
        Text(
          "This page is under maintenance",
          style: CommonTextStyles.loginTextStyle(context),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.all(CommonDimens.MARGIN_20),
          child: Text(
            "Our developers are on the issue right now. Until then don't miss out on catching up your list of tasks",
            style: CommonTextStyles.taskTextStyle(context),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
