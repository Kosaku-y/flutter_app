import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../Util/ScreenParts.dart';

class AnalyzeScreenParts {
  final ScreenParts _parts = ScreenParts();

  //パーセンテージを表すメーター
  Widget percentIndicator(String text, double percentage) {
    return LinearPercentIndicator(
        width: 250,
        animation: true,
        leading: Text(text, style: TextStyle(fontSize: 15.0)),
        lineHeight: 20.0,
        animationDuration: 2000,
        percent: percentage,
        center: Text("${(percentage * 100).toStringAsFixed(2)}%"),
        linearStrokeCap: LinearStrokeCap.roundAll,
        progressColor: Color(0xffb39ddb));
  }
}

/*----------------------------------------------

ポイント推移の線グラフクラス

----------------------------------------------*/
class PointsLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;

  PointsLineChart(this.seriesList);

  factory PointsLineChart.withSampleData(List<int> lineData) {
    return new PointsLineChart(_createSampleData(lineData));
  }

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(seriesList,
        animate: true,
        animationDuration: Duration(seconds: 2),
        defaultRenderer: charts.LineRendererConfig(includeArea: true, includePoints: true),
        primaryMeasureAxis: new charts.NumericAxisSpec(
            tickProviderSpec: new charts.BasicNumericTickProviderSpec(desiredTickCount: 4)),
        behaviors: [
          charts.LinePointHighlighter(
              showHorizontalFollowLine: charts.LinePointHighlighterFollowLineType.none,
              showVerticalFollowLine: charts.LinePointHighlighterFollowLineType.nearest),
        ]);
  }

  // データ作成
  static List<charts.Series<LineGraphEntry, int>> _createSampleData(List<int> lineData) {
    List<LineGraphEntry> data = [];
    for (int x = 0; x < lineData.length; x++) {
      data.add(LineGraphEntry(x, lineData[x]));
    }
    return [
      new charts.Series<LineGraphEntry, int>(
        id: 'Lines',
        domainFn: (LineGraphEntry sales, _) => sales.x,
        measureFn: (LineGraphEntry sales, _) => sales.y,
        data: data,
        strokeWidthPxFn: (_, __) => 3, // 太さ
        fillColorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xff6200ea)), // プロットの色
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xff7c4dff)), // 線の色
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

/*----------------------------------------------

着順チャートクラス

----------------------------------------------*/
class RankPieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  RankPieChart(this.seriesList);

  factory RankPieChart.withSampleData(List<int> ranking) {
    return RankPieChart(_createSampleData(ranking));
  }

  @override
  Widget build(BuildContext context) {
    return charts.PieChart(
      seriesList,
      animate: true,
      animationDuration: Duration(seconds: 2),
      defaultRenderer: new charts.ArcRendererConfig(
        arcWidth: 50,
        arcRendererDecorators: [new charts.ArcLabelDecorator()],
      ),
      behaviors: [
        new charts.DatumLegend(
          position: charts.BehaviorPosition.end,
          horizontalFirst: false,
          cellPadding: new EdgeInsets.only(right: 15.0, bottom: 15.0),
          legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
          showMeasures: true,
          measureFormatter: (num value) {
            return value == null ? '-' : '${value}回';
          },
          entryTextStyle: charts.TextStyleSpec(fontSize: 15),
        ),
      ],
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
  final int ranking; // 着順(1~4)
  final int sales; // 回数
  final Color color;
  RankingPieChartEntry(this.ranking, this.sales, this.color);
}
