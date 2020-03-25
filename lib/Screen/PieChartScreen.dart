import 'package:flutter/material.dart';
import 'package:flutter_app2/Screen/HomeScreenElement.dart';
import '../PageParts.dart';
import '../CommonData.dart';

class PieChartScreen extends StatelessWidget {
  HomeScreenElement element = HomeScreenElement();
  final String rank;
  PieChartScreen({key, @required this.rank});
  final PageParts _parts = new PageParts();
  final CommonData _data = CommonData();
  Color _rankColor; //ランクカラー
  String _colorStr; //カラーの文字列(ex."赤")
  int remain = 0; //ランクアップまでのポイント
  int _max = 0; //現ランクのmaxポイント

  Future<void> _generateData() async {
    double userRank = double.parse(rank);
    for (int r in _data.rankMap.keys) {
      if (userRank < r) {
        _max = r;
        _colorStr = _data.rankMap[r];
        _rankColor = _data.colorMap[_colorStr];
        break;
      }
    }
    remain = (_max - userRank).toInt();
    return;
  }

  Widget build(BuildContext context) {
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
                  size: const Size(300.0, 300.0),
                  labelSize: 60.0,
                  rank: int.parse(rank),
                  max: _max,
                  color: _rankColor),
            ),
            Text('ランクアップまであと $remain', style: TextStyle(color: _parts.fontColor, fontSize: 20.0)),
            _parts.backButton(
              onPressed: () => Navigator.pop(context),
            ),
          ]),
        ),
      ),
    );
  }
}
