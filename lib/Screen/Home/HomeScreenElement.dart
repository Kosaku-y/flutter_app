import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../CommonData.dart';

/*----------------------------------------------

//ホームElementクラス(Stateless)

----------------------------------------------*/

class HomeScreenElement {
  HomeScreenElement();
  int rank = 1;
  Color rankColor; //ランクカラー
  String rankColorStr; //カラーの文字列(ex."赤")
  int remain = 0; //ランクアップまでのポイント
  int max = 0; //現ランクのmaxポイント

  generateGaugeData(int rank) {
    this.rank = rank;
    for (int r in CommonData.rankMap.keys) {
      if (rank < r) {
        max = r;
        rankColorStr = CommonData.rankMap[r];
        rankColor = CommonData.colorMap[rankColorStr];
        break;
      }
    }
    remain = max - rank;
  }

  Widget rankGauge({double size, double lineWidth}) {
    double rankPercentage = rank.toDouble() / max;
    return CircularPercentIndicator(
      animation: true,
      animationDuration: 1500,
      radius: size,
      lineWidth: lineWidth,
      percent: rankPercentage,
      center: new Text("$rank", style: TextStyle(color: rankColor, fontSize: size * 0.2)),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: rankColor,
    );
  }
}
