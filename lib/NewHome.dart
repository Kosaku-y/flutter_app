import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'Entity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'DashBoardElement.dart';

class NewHomeManage extends StatelessWidget {
  @override
  //EventManage({Key key}) : super(key: key);
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NewHome(),
      routes: <String, WidgetBuilder>{
        '/Newhome': (BuildContext context) => new NewHome(),
      },
    );
  }
}

class NewHome extends StatefulWidget {
  final Widget child;
  User user;
  NewHome({Key key, this.child}) : super(key: key);
  _NewHomeState createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {
  PageParts set = new PageParts();
  final userReference = FirebaseDatabase.instance.reference().child("gmail");
  User user = User();
  int totalInfo = 0; //お知らせ件数
  //後々はここでrankかUserを渡したい
  PieChartDetailPageState pie = new PieChartDetailPageState();
  int userRank = 21;
  String userName = "Kosaku";

  String rankColorString;
  _NewHomeState();

  @override
  void initState() {
    super.initState();
    for (int r in user.rankMap.keys) {
      if (userRank <= r) {
        rankColorString = user.rankMap[r];
        break;
      }
    }
    pie.seriesPieData = List<charts.Series<Data, String>>();
    pie.generateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*
        appBar: AppBar(
          elevation: 2.0,
          backgroundColor: set.baseColor,
          title: Text('Dashboard',
              style: TextStyle(color:set.fontColor, fontWeight: FontWeight.w700, fontSize: 30.0,)
          ),
        ),
        */
        backgroundColor: set.backGroundColor,
        body: StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(2.0),
              child: Text('ようこそ　' + '$userName' + '　さん',
                  style: TextStyle(
                      color: set.fontColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 20.0)),
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
                              style: TextStyle(
                                  color: set.fontColor, fontSize: 12.0)),
                          //                          Text('$totalInfo件', style: TextStyle(color: Colors.blueAccent)),
                        ],
                      ),
                      Material(
                          //                        color: Colors.blue,
                          color: set.fontColor,
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.info,
                                color: Colors.white, size: 30.0),
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
                          color: set.fontColor,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Image.asset('assets/piece/0m5.png'),
                          )),
                      Padding(padding: EdgeInsets.only(bottom: 12.0)),
                      Text('How to 役',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 20.0)),
                      Text('役を覚えよう',
                          style:
                              TextStyle(color: set.fontColor, fontSize: 12.0)),
                    ]),
              ),
              onTap: () => Navigator.push(
                this.context,
                MaterialPageRoute(
                  builder: (context) => MahjongHandPage(),
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
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold)),
                    Text.rich(
                      TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: '現在のランク:',
                              style: TextStyle(
                                  color: set.fontColor, fontSize: 12.0)),
                          TextSpan(
                              text: '$rankColorString',
                              style: TextStyle(
                                  color: user.colorMap[rankColorString],
                                  fontSize: 12.0)),
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
                  builder: (context) => new PieChartDetailPage(),
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
                          color: set.fontColor,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.show_chart,
                                color: Colors.white, size: 30.0),
                          )),
                      Padding(padding: EdgeInsets.only(bottom: 12.0)),
                      Text('戦績',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 20.0)),
                      Text(
                        '勝敗分析をしよう',
                        style: TextStyle(color: set.fontColor, fontSize: 12.0),
                      ),
                    ]),
              ),
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
                          Text('一言コメント欄',
                              style: TextStyle(
                                  color: set.fontColor, fontSize: 12.0)),
                          Text('開発中',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 20.0,
                              ))
                        ],
                      ),
                      Material(
                          color: set.fontColor,
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center(
                              child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Icon(Icons.store,
                                color: Colors.white, size: 30.0),
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
}
