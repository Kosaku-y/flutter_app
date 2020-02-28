import 'package:flutter/material.dart';
import 'package:flutter_app2/Entity/EventDetail.dart';
import 'package:flutter_app2/Entity/PageParts.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:flutter_app2/Repository/EventRepository.dart';
import 'package:flutter_app2/Widget/ReturnTopPage.dart';

class EventCreateConfirmPage extends StatelessWidget {
  User user;
  String pref;
  String line;
  EventDetail event;
  PageParts set = new PageParts();
  EventCreateConfirmPage({Key key, this.pref, this.line, this.user, this.event}) : super(key: key);

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
            Text(
              "この内容で募集します。入力内容を確認して下さい。",
              style: TextStyle(color: set.pointColor),
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("募集人数：${event.recruitMember}", style: TextStyle(color: set.pointColor)),
                  Text("都道府県：$pref", style: TextStyle(color: set.pointColor)),
                  Text("路線　　：$line", style: TextStyle(color: set.pointColor)),
                  Text("駅　　　：${event.station}", style: TextStyle(color: set.pointColor)),
                  Text("開始時間：${event.startingTime}", style: TextStyle(color: set.pointColor)),
                  Text("終了時間：${event.endingTime}", style: TextStyle(color: set.pointColor)),
                  Text("コメント：${event.comment}", style: TextStyle(color: set.pointColor)),
                ]),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: RaisedButton.icon(
                  label: Text("募集する"),
                  color: set.pointColor,
                  icon: Icon(
                    Icons.event_available,
                    color: set.fontColor,
                  ),
                  onPressed: () {
                    final EventRepository repository = new EventRepository();
                    repository.createEvent(pref, line, event);
                    //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: const RouteSettings(name: "/ReturnTop"),
                        builder: (context) => ReturnTopPage(message: "登録が完了しました。"),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
