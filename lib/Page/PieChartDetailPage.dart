import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_database/firebase_database.dart';
import '../Entity/PageParts.dart';
import '../Entity/User.dart';
import '../Repository/CommonData.dart';

class Data {
  String name;
  int value;
  Color color;
  Data(this.name, this.value, this.color);
}

class PieChartDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new PieChartDetailPageState();
  }
}

class PieChartDetailPageState extends State<PieChartDetailPage> {
  List<charts.Series<Data, String>> seriesPieData;
  PageParts set = new PageParts();
  CommonData cd = CommonData();
  User user = new User();
  final userReference = FirebaseDatabase.instance.reference().child("gmail");
  int rank = int.parse("21");
  int max, remain;
  String rankColorString;

  PieChartDetailPageState();
  @override
  void initState() {
    super.initState();
    seriesPieData = List<charts.Series<Data, String>>();
    generateData();
  }

  generateData() {
    for (int r in cd.rankMap.keys) {
      if (rank <= r) {
        max = r;
        rankColorString = cd.rankMap[r];
        break;
      }
    }
    remain = max - rank;
//  int rank = int.parse(user.rank);
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
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: set.baseColor,
        title: Text('現在のランク',
            style: TextStyle(
              color: set.pointColor,
            )),
      ),
      backgroundColor: set.backGroundColor,
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Text('Player rank',
                  style: TextStyle(
                    color: set.pointColor,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  )),
              Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: '現在のランク:', style: TextStyle(color: set.fontColor, fontSize: 20.0)),
                    TextSpan(
                        text: '$rankColorString',
                        style: TextStyle(color: cd.colorMap[rankColorString], fontSize: 25.0)),
                  ],
                ),
              ),
              Text('ランクアップまであと $remain', style: TextStyle(color: set.fontColor, fontSize: 20.0)),
              Expanded(
                child: pieChart(),
              ),
              set.backButton(
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
