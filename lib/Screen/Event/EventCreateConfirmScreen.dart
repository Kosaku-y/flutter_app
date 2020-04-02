import 'package:flutter/material.dart';
import 'package:flutter_app2/Entity/EventDetail.dart';
import 'package:flutter_app2/Entity/EventPlace.dart';
import 'package:flutter_app2/PageParts.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:flutter_app2/Repository/EventRepository.dart';

import '../ReturnTopScreen.dart';

/*----------------------------------------------

イベント作成・確認 Screenクラス

----------------------------------------------*/

class EventCreateConfirmScreen extends StatelessWidget {
  final User user;
  final Line line;
  final Station station;
  final EventDetail event;
  final PageParts _parts = new PageParts();
  EventCreateConfirmScreen({Key key, this.line, this.station, this.user, this.event})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _parts.appBar(title: "入力内容確認"),
      backgroundColor: _parts.backGroundColor,
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                "この内容で募集します。入力内容を確認して下さい。",
                style: TextStyle(color: _parts.pointColor),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("募集人数：${event.recruitMember}", style: TextStyle(color: _parts.pointColor)),
                  Text("路線　　：${line.name}", style: TextStyle(color: _parts.pointColor)),
                  Text("駅　　　：${event.station}", style: TextStyle(color: _parts.pointColor)),
                  Text("開始時間：${event.startingTime}", style: TextStyle(color: _parts.pointColor)),
                  Text("終了時間：${event.endingTime}", style: TextStyle(color: _parts.pointColor)),
                  Text("コメント：${event.comment}", style: TextStyle(color: _parts.pointColor)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(50.0),
              child: _parts.iconButton(
                message: "募集する",
                icon: Icons.event_available,
                onPressed: () {
                  final EventRepository repository = new EventRepository();
                  repository.createEvent(station.code, event);
                  //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      settings: const RouteSettings(name: "/ReturnTop"),
                      builder: (context) => ReturnTopScreen(message: "登録が完了しました。"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
