/*
* テスト段階でrealtime databaseでchat機能を実装する
*
* @auther KosakuYamauchi
* */
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app2/Bloc/TalkBloc.dart';
import 'package:flutter_app2/Entity/PageParts.dart';
import 'package:flutter_app2/Entity/User.dart';

import 'TalkPage.dart';

/*----------------------------------------------
　ルームページクラス
----------------------------------------------*/
class TalkRoomPage extends StatelessWidget {
  User user;

  TalkRoomPage(this.user);
  PageParts set = PageParts();
  List<String> rooms = new List();

  @override
  Widget build(BuildContext context) {
    TalkBloc bloc = new TalkBloc(user);
    return Scaffold(
        appBar: AppBar(
          elevation: 2.0,
          backgroundColor: set.baseColor,
          title: Text('トークルーム',
              style: TextStyle(
                color: set.pointColor,
              )),
        ),
        backgroundColor: set.backGroundColor,
        body: Padding(
          padding: const EdgeInsets.all(80),
          child: StreamBuilder<List<String>>(
              stream: bloc.eventListStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text(
                    "トークルームはありません",
                    style: TextStyle(
                      color: set.pointColor,
                      fontSize: 20,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("エラーが発生しました" + snapshot.error.toString());
                } else {
                  rooms = snapshot.data;
                  if (snapshot.data.length == 0) {
                    return Text("トークルームはありません",
                        style: TextStyle(
                          color: set.pointColor,
                          fontSize: 20,
                        ));
                  }
                  return Container(
                      child: new Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return _buildRow(context, index);
                          },
                          itemCount: snapshot.data.length,
                        ),
                      ),
                    ],
                  ));
                }
              }),
        ));
  }

  // 投稿されたメッセージの1行を表示するWidgetを生成
  Widget _buildRow(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            settings: const RouteSettings(name: "/Talk"),
            builder: (context) => new TalkPage(user: user, opponentId: rooms[index]),
          ),
        );
      },
      child: new Column(children: <Widget>[
        Card(
          color: set.backGroundColor,
          child: ListTile(
            title: Text(
              rooms[index],
              style: TextStyle(
                fontSize: 20.0,
                color: set.pointColor,
              ),
            ),
          ),
        ),
        Divider(color: set.pointColor),
      ]),
    );
  }
}
