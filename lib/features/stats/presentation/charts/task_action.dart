import 'package:flutter/material.dart';
import 'package:charts_common/common.dart' as charts;

class TaskAction {
  final String dayOfTheWeek;
  final int taskAmount;
  final charts.Color color;

  TaskAction(this.dayOfTheWeek, this.taskAmount, Color color)
      : this.color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
