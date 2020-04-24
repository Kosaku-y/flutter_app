import 'package:flutter/material.dart';
import 'package:flutter_app2/Screen/Home/HomeScreenElement.dart';
import '../PageParts.dart';

class RankPieChartScreen extends StatelessWidget {
  final HomeScreenElement element = HomeScreenElement();
  final String rank;
  final PageParts _parts = PageParts();
  RankPieChartScreen({key, @required this.rank});

  Widget build(BuildContext context) {
    element.generateGaugeData(int.parse(rank));
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
                  TextSpan(
                      text: '${element.rankColorStr}',
                      style: TextStyle(color: element.rankColor, fontSize: 25.0)),
                ],
              ),
            ),
            Expanded(child: element.rankGauge(size: 300, lineWidth: 10.0)),
            Text('ランクアップまであと ${element.remain}',
                style: TextStyle(color: _parts.fontColor, fontSize: 20.0)),
            _parts.backButton(context)
          ]),
        ),
      ),
    );
  }
}
