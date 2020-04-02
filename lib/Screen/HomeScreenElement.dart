import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

/*----------------------------------------------

ホームElementクラス(Stateless)

----------------------------------------------*/

class HomeScreenElement {
  HomeScreenElement();

  Widget rankGauge({double size, double line, int rank, int max, Color color}) {
    double rankPercentage = rank.toDouble() / max;
    return CircularPercentIndicator(
      animation: true,
      animationDuration: 1500,
      radius: size,
      lineWidth: line,
      percent: rankPercentage,
      center: new Text(
        "$rank",
        style: TextStyle(
          color: color,
          fontSize: size * 0.2,
        ),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: color,
    );
  }
}
