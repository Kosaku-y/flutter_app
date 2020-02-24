import 'package:flutter/material.dart';
import 'package:flutter_app2/Entity/EventDetail.dart';
import 'package:flutter_app2/Entity/PageParts.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:flutter_app2/Widget/ReturnTopPage.dart';

class EventCreateConfirmPage extends StatelessWidget {
  User user;
  String pref;
  String line;
  EventDetail event;
  PageParts set = new PageParts();
  EventCreateConfirmPage(Key key, this.pref, this.line, this.user, this.event) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Center(
            child: Text("以下の内容で登録します。よろしければ登録ボタンを押して下さい。", style: TextStyle(color: set.pointColor)),
          ),
          Text("募集人数：${event.recruitMember}"),
          Text("都道府県：$pref"),
          Text("路線　　：$line"),
          Text("駅　　　：${event.station}"),
          Text("開始時間：${event.startingTime}"),
          Text("終了時間：${event.endingTime}"),
          Text("コメント：${event.comment}"),
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
    );
  }
}
