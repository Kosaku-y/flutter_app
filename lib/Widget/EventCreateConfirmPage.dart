import 'package:flutter/material.dart';
import 'package:flutter_app2/Entity/EventDetail.dart';
import 'package:flutter_app2/Entity/EventPlace.dart';
import 'package:flutter_app2/Entity/PageParts.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:flutter_app2/Repository/EventRepository.dart';
import 'package:flutter_app2/Widget/ReturnTopPage.dart';

class EventCreateConfirmPage extends StatelessWidget {
  final User user;
  final Line line;
  final Station station;
  final EventDetail event;
  final PageParts set = new PageParts();
  EventCreateConfirmPage({Key key, this.line, this.station, this.user, this.event})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: set.baseColor,
        title: Text('確認ページ',
            style: TextStyle(
              color: set.pointColor,
            )),
      ),
      backgroundColor: set.backGroundColor,
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                "この内容で募集します。入力内容を確認して下さい。",
                style: TextStyle(color: set.pointColor),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("募集人数：${event.recruitMember}", style: TextStyle(color: set.pointColor)),
                  Text("路線　　：${line.name}", style: TextStyle(color: set.pointColor)),
                  Text("駅　　　：${event.station}", style: TextStyle(color: set.pointColor)),
                  Text("開始時間：${event.startingTime}", style: TextStyle(color: set.pointColor)),
                  Text("終了時間：${event.endingTime}", style: TextStyle(color: set.pointColor)),
                  Text("コメント：${event.comment}", style: TextStyle(color: set.pointColor)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(50.0),
              child: set.iconButton(
                message: "募集する",
                icon: Icons.event_available,
                onPressed: () {
                  final EventRepository repository = new EventRepository();
                  repository.createEvent(station.code, event);
                  //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: const RouteSettings(name: "/ReturnTop"),
                      builder: (context) => ReturnTopPage(message: "登録が完了しました。"),
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
