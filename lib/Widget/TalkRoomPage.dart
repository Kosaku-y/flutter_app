/*
* テスト段階でrealtime databaseでchat機能を実装する
*
* @auther KosakuYamauchi
* */
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app2/Entity/PageParts.dart';
import 'package:flutter_app2/Entity/User.dart';

import 'TalkPage.dart';

class TalkRoomPage extends StatefulWidget {
  User fromUser;
  TalkRoomPage({Key key, @required this.fromUser}) : super(key: key);

  @override
  TalkRoomPageState createState() => new TalkRoomPageState();
}

/*----------------------------------------------
　ルームページクラス
----------------------------------------------*/
class TalkRoomPageState extends State<TalkRoomPage> {
  PageParts set = PageParts();
  final _mainReference = FirebaseDatabase.instance.reference().child("User/Gmail");
  List<String> rooms = new List();

  @override
  initState() {
    super.initState();
    _mainReference.child("${widget.fromUser.userId}/message").onChildAdded.listen(_onEntryAdded);
  }

  _onEntryAdded(Event e) {
    setState(() {
      rooms.add(e.snapshot.key);
    });
  }

  // 画面全体のビルド
  @override
  Widget build(BuildContext context) {
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
      body: Container(
          child: new Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return _buildRow(index);
              },
              itemCount: rooms.length,
            ),
          ),
        ],
      )),
    );
  }

  // 投稿されたメッセージの1行を表示するWidgetを生成
  Widget _buildRow(int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
            this.context,
            MaterialPageRoute(
                // パラメータを渡す
                builder: (context) =>
                    new ChatPage(fromUserId: widget.fromUser.userId, toUserId: rooms[index])));
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
