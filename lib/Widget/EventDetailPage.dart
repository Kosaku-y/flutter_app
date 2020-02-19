import 'package:flutter/material.dart';
import 'package:flutter_app2/Entity/EventDetail.dart';
import 'package:flutter_app2/Entity/PageParts.dart';
import 'package:intl/intl.dart';

/*----------------------------------------------

イベントの詳細ページ出力クラス(Stateless)

----------------------------------------------*/

class EventDetailPage extends StatelessWidget {
  EventDetail event;
  EventDetailPage(this.event);
  PageParts set = new PageParts();
  var formatter = new DateFormat('yyyy年 M月d日(E) HH時mm分');

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: set.baseColor,
        title: Text('イベント詳細',
            style: TextStyle(
              color: set.pointColor,
            )),
      ),
      backgroundColor: set.backGroundColor,
      body: Center(
        child: Column(children: <Widget>[
          //イベント詳細
          Text(
            "イベントID:" +
                event.eventId.toString() +
                "\n"
                    "最寄駅:" +
                event.station +
                "\n"
                    "募集人数:" +
                event.recruitMember +
                "\n"
                    "開始時刻:" +
                event.startingTime +
                "\n"
                    "終了時刻:" +
                event.endingTime +
                "\n"
                    "備考:" +
                event.comment +
                "\n",
            style: TextStyle(
              fontFamily: 'Roboto',
              color: set.fontColor,
              fontSize: 20,
            ),
          ),

          //戻るボタン
          set.backButton(
            onTap: () => Navigator.pop(context),
          ),
        ]),
      ),
    );
  }
}
