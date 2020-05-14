import 'package:flutter/material.dart';
import 'package:project_runway/core/common_text_styles.dart';

class ScoreWidget extends StatefulWidget {
  final int weeklyScore;

  ScoreWidget(this.weeklyScore);

  @override
  _ScoreWidgetState createState() => _ScoreWidgetState();
}

class _ScoreWidgetState extends State<ScoreWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 1500,
        ));
    _controller.forward(from: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Text(
              timeLeftStringToShowToUser,
              style:
                  CommonTextStyles.headerTextStyle(context).copyWith(letterSpacing: 5),
            );
          },
        ),
      ],
    );
  }

  // This function will give us the time left
  // to show to the user for the transaction
  // to complete.
  String get timeLeftStringToShowToUser {
    return "${(widget.weeklyScore * _controller.value).floor()}";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
