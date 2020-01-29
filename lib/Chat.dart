/*
* テスト段階でrealtime databaseでchat機能を実装する
*
* @auther KosakuYamauchi
* */
import 'package:flutter/material.dart';
import 'package:flutter_app2/Entity/Entity.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class RoomPage extends StatefulWidget {
  User fromUser;
  RoomPage(this.fromUser);

  @override
  _RoomPage createState() => new _RoomPage();
}

/*----------------------------------------------
　ルームページクラス
----------------------------------------------*/
class _RoomPage extends State<RoomPage> {
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
                builder: (context) => new ChatPage(widget.fromUser.userId, rooms[index])));
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

/*----------------------------------------------
　チャットページクラス
----------------------------------------------*/
class ChatPage extends StatefulWidget {
  String fromUserId;
  String toUserId;

  ChatPage(this.fromUserId, this.toUserId);
  @override
  _ChatPage createState() => new _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  PageParts set = PageParts();
  final _mainReference = FirebaseDatabase.instance.reference().child("User/Gmail");
  final _textEditController = TextEditingController();

  List<ChatEntity> entries = new List();

  @override
  initState() {
    super.initState();
    _mainReference.child("${widget.fromUserId}/message/${widget.toUserId}").onChildAdded.listen(_onEntryAdded);
  }

  _onEntryAdded(Event e) {
    setState(() {
      entries.add(new ChatEntity.fromSnapShot(e.snapshot));
    });
  }

  // 画面全体のビルド
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: set.backGroundColor,
      body: Container(
          child: new Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (BuildContext context, int index) {
                return _buildRow(index);
              },
              itemCount: entries.length,
            ),
          ),
          Divider(
            height: 4.0,
          ),
          Container(decoration: BoxDecoration(color: Theme.of(context).cardColor), child: _buildInputArea())
        ],
      )),
    );
  }

  // 投稿されたメッセージの1行を表示するWidgetを生成
  Widget _buildRow(int index) {
    return Card(
      color: set.backGroundColor,
      child: ListTile(
        title: Text(
          entries[index].message,
          style: TextStyle(
            color: set.pointColor,
          ),
        ),
      ),
    );
  }

  // 投稿メッセージの入力部分のWidgetを生成
  Widget _buildInputArea() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 16.0,
        ),
        Expanded(
          child: TextField(
            controller: _textEditController,
          ),
        ),
        CupertinoButton(
          child: Text("Send"),
          onPressed: () {
            _mainReference.child("${widget.fromUserId}/message/${widget.toUserId}").push().set(ChatEntity(DateTime.now(), _textEditController.text).toJson());
            print("send message :${_textEditController.text}");
            _mainReference.child("${widget.toUserId}/message/${widget.fromUserId}").push().set(ChatEntity(DateTime.now(), _textEditController.text).toJson());
            print("send message :${_textEditController.text}");
            _textEditController.clear();
            // キーボードを閉じる
            FocusScope.of(context).requestFocus(new FocusNode());
          },
        )
      ],
    );
  }
}
