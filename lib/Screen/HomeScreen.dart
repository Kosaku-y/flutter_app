import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_app2/Entity/PageParts.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:flutter_app2/Repository/CommonData.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:firebase_database/firebase_database.dart';

import 'PieChartScreen.dart';
import 'MahjongHandScreen.dart';
import 'Score/ScoreManagePage.dart';
import 'Score/ScoreManagePage2.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  HomeScreen({Key key, this.user}) : super(key: key);
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  PageParts _parts = new PageParts();
  CommonData cd = CommonData();
  final userReference = FirebaseDatabase.instance.reference().child("gmail");
  int totalInfo = 0; //お知らせ件数

  PieChartScreenState pie = new PieChartScreenState();
  int userRank;
  String rankColorString;

  @override
  void initState() {
    super.initState();
    userRank = int.parse(widget.user.rank);
    for (int r in cd.rankMap.keys) {
      if (userRank <= r) {
        rankColorString = cd.rankMap[r];
        break;
      }
    }
    pie.seriesPieData = List<charts.Series<Data, String>>();
    pie.generateData(userRank);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _parts.appBar(title: "ホーム"),
        backgroundColor: _parts.backGroundColor,
        body: StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(2.0),
              child: Text('ようこそ ${widget.user.name} さん',
                  style: TextStyle(
                      color: _parts.fontColor, fontWeight: FontWeight.w700, fontSize: 20.0)),
            ),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('お知らせ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20.0)),
                          Text('新着$totalInfo件',
                              style: TextStyle(color: _parts.fontColor, fontSize: 12.0)),
                          //                          Text('$totalInfo件', style: TextStyle(color: Colors.blueAccent)),
                        ],
                      ),
                      Material(
                          //                        color: Colors.blue,
                          color: _parts.fontColor,
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.info, color: Colors.white, size: 30.0),
                          )))
                    ]),
              ),
            ),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Material(
                          color: _parts.fontColor,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Image.asset('assets/piece/0m5.png'),
                          )),
                      Padding(padding: EdgeInsets.only(bottom: 12.0)),
                      Text('How to 役',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20.0)),
                      Text('役を覚えよう', style: TextStyle(color: _parts.fontColor, fontSize: 12.0)),
                    ]),
              ),
              onTap: () => Navigator.push(
                this.context,
                MaterialPageRoute(
                  settings: const RouteSettings(name: "/MahjongHand"),
                  builder: (context) => MahjongHandScreen(),
                ),
              ),
            ),
            _buildTile(
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 24.0),
                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Player rank',
                        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
                    Text.rich(
                      TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: '現在のランク:',
                              style: TextStyle(color: _parts.fontColor, fontSize: 12.0)),
                          TextSpan(
                              text: '$rankColorString',
                              style:
                                  TextStyle(color: cd.colorMap[rankColorString], fontSize: 12.0)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: pie.pieChart(),
                    ),
                  ],
                ),
              ),
              onTap: () => Navigator.push(
                this.context,
                MaterialPageRoute(
                  settings: const RouteSettings(name: "/PieChartDetail"),
                  builder: (context) => new PieChartScreen(user: widget.user),
                ),
              ),
            ),
            _buildTile(
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Material(
                            color: _parts.fontColor,
                            shape: CircleBorder(),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Icon(Icons.show_chart, color: Colors.white, size: 30.0),
                            )),
                        Padding(padding: EdgeInsets.only(bottom: 12.0)),
                        Text('戦績',
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20.0)),
                        Text(
                          '勝敗分析をしよう',
                          style: TextStyle(color: _parts.fontColor, fontSize: 12.0),
                        ),
                      ]),
                ), onTap: () {
              Navigator.push(
                this.context,
                MaterialPageRoute(
                  settings: const RouteSettings(name: "/ScoreManagePage"),
                  builder: (context) => ScoreManagePage2(),
                ),
              );
            }),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('一言コメント欄',
                              style: TextStyle(color: _parts.fontColor, fontSize: 12.0)),
                          Text('開発中',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 20.0,
                              ))
                        ],
                      ),
                      Material(
                          color: _parts.fontColor,
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center(
                              child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Icon(Icons.store, color: Colors.white, size: 30.0),
                          )))
                    ]),
              ),
              //onTap: () => Navigator.of(context).push(),
            )
          ],
          staggeredTiles: [
            StaggeredTile.extent(2, 40.0), //メッセージ部分
            StaggeredTile.extent(2, 110.0), //お知らせ
            StaggeredTile.extent(1, 180.0), //How to 役
            StaggeredTile.extent(1, 360.0), //rank
            StaggeredTile.extent(1, 170.0), //戦績
            StaggeredTile.extent(2, 110.0), //開発中
          ],
        ));
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 7.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
                    print('Not set yet');
                  },
            child: child));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
