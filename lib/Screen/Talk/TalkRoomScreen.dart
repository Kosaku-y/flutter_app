import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app2/Bloc/TalkRoomBloc.dart';
import 'package:flutter_app2/Entity/TalkRoom.dart';
import 'package:flutter_app2/PageParts.dart';
import 'package:flutter_app2/Entity/User.dart';

import 'TalkScreen.dart';

/*----------------------------------------------

トークルームクラス

----------------------------------------------*/
class TalkRoomScreen extends StatelessWidget {
  final User user;
  final PageParts _parts = PageParts();

  TalkRoomScreen(this.user);

  @override
  Widget build(BuildContext context) {
    List<TalkRoom> roomList;
    TalkRoomBloc bloc = new TalkRoomBloc(user);
    return Scaffold(
        appBar: _parts.appBar(title: "トークルーム"),
        backgroundColor: _parts.backGroundColor,
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
          child: StreamBuilder<List<TalkRoom>>(
              stream: bloc.talkRoomListStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text(
                      "トークルームはありません",
                      style: TextStyle(
                        color: _parts.pointColor,
                        fontSize: 20,
                      ),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Text("エラーが発生しました：" + snapshot.error.toString());
                }
                roomList = snapshot.data;
                if (snapshot.data.length == 0) {
                  return Center(
                    child: Text("トークルームはありません",
                        style: TextStyle(
                          color: _parts.pointColor,
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
                            return _buildRow(context, roomList[index]);
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
  Widget _buildRow(BuildContext context, TalkRoom room) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            settings: RouteSettings(name: "/Talk/${room.roomId}"),
            builder: (context) => new TalkScreen(user: user, room: room),
          ),
        );
      },
      child: new Column(children: <Widget>[
        Container(
          color: _parts.backGroundColor,
          child: ListTile(
            leading: CircleAvatar(
              //backgroundImage: NetworkImage(entry.userImageUrl),
              child: Text(room.userName[0]),
            ),
            title: Text(
              room.userName,
              style: TextStyle(
                fontSize: 20.0,
                color: _parts.pointColor,
              ),
            ),
          ),
        ),
        Divider(color: _parts.pointColor),
      ]),
    );
  }
}
