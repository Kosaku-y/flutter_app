import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_database/firebase_database.dart';
import 'Entity/PageParts.dart';
import 'Entity/User.dart';
import 'Repository/CommonData.dart';

class PieChartDetailPage extends StatefulWidget {
  @override
//  String rank;
//  PieChartDetailPage(this.rank);
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
                onTap: () => Navigator.pop(context),
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

class Data {
  String name;
  int value;
  Color color;
  Data(this.name, this.value, this.color);
}

class MahjongHandPage extends StatelessWidget {
  PageParts set = PageParts();
  List<MahjongHand> entries = [
    MahjongHand("断么(タンヤオ)", "1", "中張牌（数牌の2〜8）のみを使って手牌を完成させた場合に成立する。断ヤオと略すことが多い。"),
    MahjongHand("平和(ピンフ)", "1", "面子が全て順子で、雀頭が役牌でなく、待ちが両面待ちになっている場合に成立する。"),
  ];
  MahjongHandPage();
  //画面全体のビルド
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("役一覧", style: TextStyle(color: set.pointColor)),
        backgroundColor: set.baseColor,
      ),
      backgroundColor: set.backGroundColor,
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: new Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return _buildRow(index);
                  },
                  itemCount: entries.length,
                ),
              ),
              Divider(
                height: 8.0,
              ),
              set.backButton(onTap: () => Navigator.pop(context))
//              Container(
//                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
//                  child: _buildInputArea()
//              )
            ],
          )),
    );
  }

  //リスト要素生成
  Widget _buildRow(int index) {
    //リストの要素一つづつにonTapを付加して、詳細ページに飛ばす
    return new GestureDetector(
      onTap: () {
//        Navigator.push(
//            this.context,
//            MaterialPageRoute(
//              // パラメータを渡す
//                builder: (context) => new EventDetailPage(entries[index])));
      },
      child: new SizedBox(
        child: new Card(
          elevation: 10,
          color: set.backGroundColor,
          child: new Container(
            decoration: BoxDecoration(
              border: Border.all(color: set.fontColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Row(// 1行目
                      children: <Widget>[
                    Expanded(
                      // 2.1列目
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            // 3.1.1行目
                            margin: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              entries[index].handName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: set.fontColor),
                            ),
                          ),
                          Container(
                            // 3.1.2行目
                            child: Text(
                              entries[index].explain,
                              style: TextStyle(fontSize: 12.0, color: set.fontColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      entries[index].hansu + "飜",
                      style: TextStyle(fontSize: 26.0, color: set.pointColor),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MahjongHand {
  String handName;
  String hansu;
  String explain;
  MahjongHand(this.handName, this.hansu, this.explain);
}
