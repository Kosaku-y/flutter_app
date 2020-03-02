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
  final User user;
  final PageParts set = PageParts();

  TalkRoomPage(this.user);

  @override
  Widget build(BuildContext context) {
    List<String> rooms;
    TalkBloc bloc = new TalkBloc(user);
    return Scaffold(
        appBar: AppBar(
          elevation: 2.0,
          backgroundColor: set.baseColor,
          title: Text('トークルーム一覧',
              style: TextStyle(
                color: set.pointColor,
              )),
        ),
        backgroundColor: set.backGroundColor,
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: StreamBuilder<List<String>>(
              stream: bloc.eventListStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text(
                      "トークルームはありません",
                      style: TextStyle(
                        color: set.pointColor,
                        fontSize: 20,
                      ),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Text("エラーが発生しました" + snapshot.error.toString());
                }
                rooms = snapshot.data;
                if (snapshot.data.length == 0) {
                  return Center(
                    child: Text("トークルームはありません",
                        style: TextStyle(
                          color: set.pointColor,
                          fontSize: 20,
                        )),
                  );
                } else {
                  return Container(
                      child: new Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return _buildRow(context, rooms[index]);
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
  Widget _buildRow(BuildContext context, String room) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            settings: const RouteSettings(name: "/Talk"),
            builder: (context) => new TalkPage(user: user, opponentId: room),
          ),
        );
      },
      child: new Column(children: <Widget>[
        Card(
          color: set.backGroundColor,
          child: ListTile(
            leading: CircleAvatar(
              //backgroundImage: NetworkImage(entry.userImageUrl),
              child: Text(room[0]),
            ),
            title: Text(
              room,
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
