import 'package:flutter/material.dart';
import 'package:flutter_app2/Screen/Home/HomeScreenElement.dart';
import '../PageParts.dart';
import '../CommonData.dart';

class RankPieChartScreen extends StatelessWidget {
  final HomeScreenElement element = HomeScreenElement();
  final String rank;
  final PageParts _parts = PageParts();
  RankPieChartScreen({key, @required this.rank});

  Widget build(BuildContext context) {
    Color _rankColor; //ランクカラー
    String _colorStr; //カラーの文字列(ex."赤")
    int _remain = 0; //ランクアップまでのポイント
    int _max = 0; //現ランクのmaxポイント

    Future<void> _generateData() async {
      double userRank = double.parse(rank);
      for (int r in CommonData.rankMap.keys) {
        if (userRank < r) {
          _max = r;
          _colorStr = CommonData.rankMap[r];
          _rankColor = CommonData.colorMap[_colorStr];
          break;
        }
      }
      _remain = (_max - userRank).toInt();
      return;
    }

    _generateData();

    return new Scaffold(
      appBar: _parts.appBar(title: "ランク(プレイヤー評価)"),
      backgroundColor: _parts.backGroundColor,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Center(
          child: Column(children: <Widget>[
            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: '現在のランク:', style: TextStyle(color: _parts.fontColor, fontSize: 20.0)),
                  TextSpan(text: '$_colorStr', style: TextStyle(color: _rankColor, fontSize: 25.0)),
                ],
              ),
            ),
            Expanded(
              child: element.rankGauge(
                  size: 300, line: 10.0, rank: int.parse(rank), max: _max, color: _rankColor),
            ),
            Text('ランクアップまであと $_remain', style: TextStyle(color: _parts.fontColor, fontSize: 20.0)),
            _parts.backButton(
              onPressed: () => Navigator.pop(context),
            ),
          ]),
        ),
      ),
    );
  }
}
