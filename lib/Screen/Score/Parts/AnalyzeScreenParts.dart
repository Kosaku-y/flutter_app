import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../../../PageParts.dart';

class AnalyzeScreenParts {
  //PageParts _parts = PageParts();
}

//線グラフ
class PointsLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final PageParts _parts = PageParts();

  PointsLineChart(this.seriesList);

  factory PointsLineChart.withSampleData() {
    return new PointsLineChart(_createSampleData());
  }

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(seriesList,
        animate: true,
        animationDuration: Duration(seconds: 2),
        defaultRenderer: new charts.LineRendererConfig(includePoints: true),
        primaryMeasureAxis: new charts.NumericAxisSpec(
            tickProviderSpec: new charts.BasicNumericTickProviderSpec(desiredTickCount: 4)),
        behaviors: [
          new charts.ChartTitle('総得点の推移',
              titleStyleSpec: charts.TextStyleSpec(
                  color: charts.ColorUtil.fromDartColor(_parts.pointColor), fontSize: 18),
              behaviorPosition: charts.BehaviorPosition.top,
              titleOutsideJustification: charts.OutsideJustification.start,
              innerPadding: 15),
        ]);
  }

  // データ作成
  static List<charts.Series<LineGraphEntry, int>> _createSampleData() {
    final data = [
      new LineGraphEntry(0, 5),
      new LineGraphEntry(1, -241),
      new LineGraphEntry(2, 905),
      new LineGraphEntry(3, 75),
    ];

    return [
      new charts.Series<LineGraphEntry, int>(
        id: 'Sales',
        domainFn: (LineGraphEntry sales, _) => sales.x,
        measureFn: (LineGraphEntry sales, _) => sales.y,
        fillColorFn: (LineGraphEntry sales, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff6200ea)), // plot
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xff7c4dff)), // Lines
        strokeWidthPxFn: (LineGraphEntry sales, _) => 3,
        data: data,
      )
    ];
  }
}

// 線グラフデータ
class LineGraphEntry {
  final int x;
  final int y;

  LineGraphEntry(this.x, this.y);
}

class RankPieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  RankPieChart(this.seriesList);

  factory RankPieChart.withSampleData(List<int> ranking) {
    return new RankPieChart(_createSampleData(ranking));
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
      seriesList,
      animate: true,
      animationDuration: Duration(seconds: 2),
      defaultRenderer: new charts.ArcRendererConfig(
        arcWidth: 50,
        arcRendererDecorators: [new charts.ArcLabelDecorator()],
      ),
    );
  }

  static List<charts.Series<RankingPieChartEntry, int>> _createSampleData(List<int> ranking) {
    final data = [
      new RankingPieChartEntry(1, ranking[0], Color(0xff6200ea)),
      new RankingPieChartEntry(2, ranking[1], Color(0xff651fff)),
      new RankingPieChartEntry(3, ranking[2], Color(0xff7c4dff)),
      new RankingPieChartEntry(4, ranking[3], Color(0xffb388ff)),
    ];

    return [
      new charts.Series<RankingPieChartEntry, int>(
        id: "RankingPieChart",
        domainFn: (RankingPieChartEntry e, _) => e.ranking,
        measureFn: (RankingPieChartEntry e, _) => e.sales,
        data: data,
        colorFn: (RankingPieChartEntry e, _) => charts.ColorUtil.fromDartColor(e.color),
        labelAccessorFn: (RankingPieChartEntry e, _) => e.sales != 0 ? '${e.ranking}着' : null,
      )
    ];
  }
}

class RankingPieChartEntry {
  final int ranking; // 着順
  final int sales; // 回数
  final Color color;
  RankingPieChartEntry(this.ranking, this.sales, this.color);
}
