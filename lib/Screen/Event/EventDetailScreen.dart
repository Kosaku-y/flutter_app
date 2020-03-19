import 'package:flutter/material.dart';
import 'package:flutter_app2/Entity/EventDetail.dart';
import 'package:flutter_app2/Entity/PageParts.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:intl/intl.dart';

import 'EventCreateScreen.dart';
import '../ProfileScreen.dart';
import '../TalkScreen.dart';
import 'package:flutter/gestures.dart';

/*----------------------------------------------

イベントの詳細ページ出力クラス(Stateless)

----------------------------------------------*/

class EventDetailScreen extends StatelessWidget {
  final EventDetail event;
  final User user;
  EventDetailScreen({Key key, this.user, this.event}) : super(key: key);
  final PageParts _parts = new PageParts();
  final formatter = new DateFormat('yyyy年 M月d日(E) HH時mm分');

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _parts.appBar(title: "イベント詳細"),
      backgroundColor: _parts.backGroundColor,
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: <Widget>[
            //イベント詳細
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("募集人数：${event.recruitMember}",
                      style: TextStyle(color: _parts.pointColor, fontSize: 18)),
                  Text("駅　　　：${event.station}",
                      style: TextStyle(color: _parts.pointColor, fontSize: 18)),
                  Text("開始時間：${event.startingTime}",
                      style: TextStyle(color: _parts.pointColor, fontSize: 17)),
                  Text("終了時間：${event.endingTime}",
                      style: TextStyle(color: _parts.pointColor, fontSize: 17)),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "主催者：", style: TextStyle(color: _parts.pointColor, fontSize: 18)),
                      TextSpan(
                          text: event.userName,
                          style: TextStyle(color: _parts.fontColor, fontSize: 17),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).push<Widget>(
                                MaterialPageRoute(
                                  settings: const RouteSettings(name: "/Profile"),
                                  builder: (context) =>
                                      new ProfileScreen(user: user, userId: event.userId),
                                ),
                              );
                            }),
                    ]),
                  ),
                  Text("コメント：${event.comment}",
                      style: TextStyle(color: _parts.pointColor, fontSize: 18)),
                  _actionWidget(context),
                ],
              ),
            ),

            //戻るボタン
            _parts.backButton(
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionWidget(BuildContext context) {
    if (event.userId == user.userId) {
      return Container(
        padding: EdgeInsets.only(top: 20.0),
        child: Column(
          children: <Widget>[
            Center(
              child: _parts.iconButton(message: "削除", icon: Icons.delete, onPressed: () {}),
            ),
            Center(
              child: _parts.iconButton(
                  message: "修正",
                  icon: Icons.check,
                  onPressed: () {
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).push<Widget>(
                      MaterialPageRoute(
                        settings: const RouteSettings(name: "/EventCreate"),
                        builder: (context) => EventCreateScreen(user: user, mode: 1, event: event),
                      ),
                    );
                  }),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: _parts.iconButton(
              message: "メッセージを送る",
              icon: Icons.mail,
              onPressed: () {
                Navigator.of(context).push<Widget>(MaterialPageRoute(
                    settings: const RouteSettings(name: "/Talk"),
                    builder: (context) => new TalkScreen(
                        user: user, opponentId: event.userId, opponentName: event.userName)));
              }),
        ),
      );
    }
  }
}
