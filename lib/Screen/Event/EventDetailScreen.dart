import 'package:flutter/material.dart';
import 'package:flutter_app2/Entity/EventDetail.dart';
import 'package:flutter_app2/PageParts.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:intl/intl.dart';
import 'EventCreateScreen.dart';
import '../ProfileScreen.dart';
import '../Talk/TalkScreen.dart';
import 'package:flutter/gestures.dart';

/*----------------------------------------------

イベントの詳細Screenクラス(Stateless)

----------------------------------------------*/

class EventDetailScreen extends StatelessWidget {
  final EventDetail event;
  final User user;
  EventDetailScreen({Key key, this.user, this.event}) : super(key: key);
  final PageParts _parts = new PageParts();
  final formatter = new DateFormat('yyyy年 M月d日(E) HH時mm分');

  Widget build(BuildContext context) {
    final TextStyle basicWhite = TextStyle(color: Colors.white, fontSize: 17.0);
    return Scaffold(
      appBar: _parts.appBar(title: "イベント詳細"),
      backgroundColor: _parts.backGroundColor,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
        child: Column(
          children: <Widget>[
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
              Text(
                  event.userId == user.userId
                      ? "イベントの削除、変更ができます。"
                      : "募集条件は以下の通りです。この募集に参加したい場合は主催者にメッセージを送ってください",
                  style: _parts.guideWhite),
              Padding(padding: const EdgeInsets.symmetric(vertical: 20.0)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(text: "主催者　：", style: _parts.basicWhite),
                      TextSpan(
                        text: event.userName,
                        style: _parts.basicGreen,
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push<Widget>(
                              MaterialPageRoute(
                                settings: const RouteSettings(name: "/Profile"),
                                builder: (context) => new ProfileScreen(
                                    user: user, userId: event.userId, userName: event.userName),
                              ),
                            );
                          },
                      ),
                    ]),
                  ),
                  Text("募集人数：${event.recruitMember}", style: basicWhite),
                  Text("路線　　：${event.line}", style: basicWhite),
                  Text("駅　　　：${event.station}", style: basicWhite),
                  Text("開始時間：${event.startingTime}", style: basicWhite),
                  Text("終了時間：${event.endingTime}", style: basicWhite),
                  Text("コメント：${event.comment}", style: basicWhite),
                  _actionWidget(context),
                ],
              ),
            ]),

            //戻るボタン
            _parts.backButton(context),
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
            Center(child: _parts.iconButton(message: "削除", icon: Icons.delete, onPressed: () {})),
            Center(
                child: _parts.iconButton(
                    message: "修正",
                    icon: Icons.check,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push<Widget>(
                        MaterialPageRoute(
                            settings: const RouteSettings(name: "/EventCreate"),
                            builder: (context) =>
                                EventCreateScreen(user: user, mode: 1, event: event),
                            fullscreenDialog: true),
                      );
                    })),
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
                      user: user, toUserId: event.userId, toUserName: event.userName)));
            },
          ),
        ),
      );
    }
  }
}
