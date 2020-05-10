import 'package:flutter/material.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/home_screen.dart';

class CongratulatoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        CommonDimens.MARGIN_20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Congratulations\nYou are all set up to increase your productivity",
            style: CommonTextStyles.loginTextStyle(),
            textAlign: TextAlign.center,
          ),

          Padding(
            padding: const EdgeInsets.only(top: CommonDimens.MARGIN_60,),
            child: OutlineButton(onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, HomeScreen.routeName);
            }, child: Text("Let's Begin"),),
          ),

        ],
      ),
    );
  }
}
