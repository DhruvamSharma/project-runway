import 'package:flutter/material.dart';
import 'package:project_runway/core/common_text_styles.dart';

class TaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            "22 December",
            style: CommonTextStyles.dateTextStyle(),
          ),
        ),
      ],
    );
  }
}
