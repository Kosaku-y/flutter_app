import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

class HomeScreenElement {
  HomeScreenElement();

  Widget rankGage({Size size, double labelSize, int rank, int max, Color color}) {
    double rankPercentage = rank * 100 / max;
    return AnimatedCircularChart(
      key: GlobalKey<AnimatedCircularChartState>(),
      size: size,
      duration: Duration(milliseconds: 1500),
      initialChartData: <CircularStackEntry>[
        new CircularStackEntry(
          <CircularSegmentEntry>[
            new CircularSegmentEntry(
              rankPercentage,
              color,
              rankKey: 'completed',
            ),
            new CircularSegmentEntry(
              100 - rankPercentage,
              Colors.blueGrey[600],
              rankKey: 'remaining',
            ),
          ],
        ),
      ],
      chartType: CircularChartType.Radial,
      percentageValues: true,
      holeLabel: '$rank',
      labelStyle: new TextStyle(
        color: color,
        fontSize: labelSize,
      ),
    );
  }
}
