import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../Entity/PageParts.dart';
import '../Entity/User.dart';
import '../Repository/CommonData.dart';

class Data {
  String name;
  int value;
  Color color;
  Data(this.name, this.value, this.color);
}

class PieChartScreen extends StatefulWidget {
  final User user;
  PieChartScreen({key, this.user});
  @override
  State<StatefulWidget> createState() {
    return new PieChartScreenState();
  }
}

class PieChartScreenState extends State<PieChartScreen> {
  List<charts.Series<Data, String>> seriesPieData;
  PageParts _parts = new PageParts();
  CommonData cd = CommonData();
  int max, remain, userRank;
  String rankColorString;

  PieChartScreenState();
  @override
  void initState() {
    super.initState();
    seriesPieData = List<charts.Series<Data, String>>();
    generateData(int.parse(widget.user.rank));
  }

  generateData(int rank) {
    userRank = rank;
    for (int r in cd.rankMap.keys) {
      if (rank <= r) {
        max = r;
        rankColorString = cd.rankMap[r];
        break;
      }
    }
    remain = max - rank;
    var pieData = [
      new Data('rank', rank, cd.colorMap[rankColorString].withOpacity(0.8)),
      new Data('brank', remain, Colors.white.withOpacity(0.0)),
    ];

    seriesPieData.add(
      charts.Series(
        domainFn: (Data data, _) => data.name,
        measureFn: (Data data, _) => data.value,
        colorFn: (Data data, _) => charts.ColorUtil.fromDartColor(data.color),
        data: pieData,
        id: 'rank',
        labelAccessorFn: (Data row, _) => '${row.value}',
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _parts.appBar(title: "ランク"),
      backgroundColor: _parts.backGroundColor,
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Text('Player rank',
                  style: TextStyle(
                    color: _parts.pointColor,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  )),
              Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: '現在のランク:', style: TextStyle(color: _parts.fontColor, fontSize: 20.0)),
                    TextSpan(
                        text: '$rankColorString',
                        style: TextStyle(color: cd.colorMap[rankColorString], fontSize: 25.0)),
                  ],
                ),
              ),
              Text('ランクアップまであと $remain', style: TextStyle(color: _parts.fontColor, fontSize: 20.0)),
              Expanded(
                child: pieChart(),
              ),
              _parts.backButton(
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget pieChart() {
    return charts.PieChart(seriesPieData,
        animate: true,
        animationDuration: Duration(seconds: 2),
        defaultRenderer: new charts.ArcRendererConfig(arcWidth: 70, arcRendererDecorators: [
          new charts.ArcLabelDecorator(labelPosition: charts.ArcLabelPosition.inside)
        ]));
  }
}
