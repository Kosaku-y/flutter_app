/*
* テスト段階でrealtime databaseでchat機能を実装する
*
* @auther KosakuYamauchi
* */
import 'package:flutter/material.dart';
import 'Entity.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class ChatPage extends StatefulWidget {
  User fromUser;
  User toUser;

  ChatPage(this.fromUser);
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
    _mainReference.child("${widget.fromUser.mail}").onChildAdded.listen(_onEntryAdded);
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
    return Card(child: ListTile(title: Text(entries[index].message)));
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
            _mainReference.child("${widget.fromUser.mail}/message").set(ChatEntity(DateTime.now(), _textEditController.text).toJson());
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
