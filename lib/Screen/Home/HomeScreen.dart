import 'package:flutter/material.dart';
import 'package:flutter_app2/Util/ScreenParts.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:flutter_app2/Util/CommonData.dart';
import 'package:flutter_app2/Screen/Home/HomeScreenElement.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../RankPieChartScreen.dart';
import '../MahjongHandScreen.dart';
import '../Score/ScoreManageScreen.dart';
import 'NoticeScreen.dart';

/*----------------------------------------------

ホームScreenクラス(Stateless)

----------------------------------------------*/

class HomeScreen extends StatelessWidget {
  final User user;
  HomeScreen({Key key, this.user}) : super(key: key);
  final ScreenParts _parts = new ScreenParts();
  final HomeScreenElement element = HomeScreenElement();

  @override
  Widget build(BuildContext context) {
    int totalInfo = 0; //お知らせ件数
    element.generateGaugeData(int.parse(user.rank));
    final TextStyle titleStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20.0);
    final TextStyle explainStyle = TextStyle(color: _parts.fontColor, fontSize: 12.0);
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
              child: Text('ようこそ ${user.name} さん',
                  style: TextStyle(
                      color: _parts.fontColor, fontWeight: FontWeight.w700, fontSize: 20.0)),
            ),
            _buildTile(
                //お知らせ
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
                            Text('お知らせ', style: titleStyle),
                            Text('新着$totalInfo件', style: explainStyle),
                            //                          Text('$totalInfo件', style: TextStyle(color: Colors.blueAccent)),
                          ],
                        ),
                        Material(
                          color: _parts.fontColor,
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center(
                            child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(Icons.info, color: Colors.white, size: 30.0)),
                          ),
                        )
                      ]),
                ), onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  settings: const RouteSettings(name: "/Notice"),
                  builder: (context) => NoticeScreen(),
                ),
              );
            }),
            _buildTile(
              //戦績管理
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
                      Text('戦績', style: titleStyle),
                      Text(
                        '勝敗分析をしよう',
                        style: explainStyle,
                      ),
                    ]),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    settings: const RouteSettings(name: "/ScoreManage"),
                    builder: (context) => ScoreManageScreen(),
                  ),
                );
              },
            ),
            _buildTile(
              //役一覧
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
                          padding: EdgeInsets.all(20.0),
                          child: Image.asset('assets/piece/0m5.png', scale: 0.75),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 30.0)),
                      Text('How to 役', style: titleStyle),
                      Text('役を覚えよう', style: explainStyle),
                    ]),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  settings: const RouteSettings(name: "/MahjongHand"),
                  builder: (context) => MahjongHandScreen(),
                ),
              ),
            ),
            _buildTile(
              //playerRank
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Player rank', style: titleStyle),
                    Text.rich(
                      TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: '現在のランクカラー:', style: explainStyle),
                          TextSpan(
                              text: '${element.rankColorStr}',
                              style: TextStyle(
                                  color: CommonData.colorMap[element.rankColorStr],
                                  fontSize: 12.0)),
                        ],
                      ),
                    ),
                    element.rankGauge(size: 140.0, lineWidth: 8.0),
                  ],
                ),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  settings: const RouteSettings(name: "/PieChart"),
                  builder: (context) => new RankPieChartScreen(rank: user.rank),
                ),
              ),
            ),
            _buildTile(
                //開発中
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
                            Text('一言コメント欄', style: explainStyle),
                            Text('開発中', style: titleStyle)
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
                onTap: () {})
          ],
          staggeredTiles: [
            StaggeredTile.extent(2, 40.0), //メッセージ部
            StaggeredTile.extent(2, 110.0), //お知らせ
            StaggeredTile.extent(2, 200.0), //戦績
            StaggeredTile.extent(1, 220.0), //How to 役
            StaggeredTile.extent(1, 220.0), //rank
            StaggeredTile.extent(2, 110.0), //開発中
          ],
        ));
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
      elevation: 7.0,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: Color(0x802196F3),
      child: InkWell(onTap: onTap != null ? () => onTap() : () => null, child: child),
    );
  }
}
