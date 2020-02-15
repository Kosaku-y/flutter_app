import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app2/Entity/Talk.dart';
import 'package:flutter_app2/Entity/PageParts.dart';
import 'package:flutter/cupertino.dart';

/*----------------------------------------------
　チャットページクラス
----------------------------------------------*/
class ChatPage extends StatefulWidget {
  String fromUserId;
  String toUserId;

  ChatPage({Key key, this.fromUserId, this.toUserId}) : super(key: key);
  @override
  TalkPageState createState() => new TalkPageState();
}

class TalkPageState extends State<ChatPage> {
  PageParts set = PageParts();
  final _mainReference = FirebaseDatabase.instance.reference().child("User/Gmail");
  final _textEditController = TextEditingController();

  List<Talk> entries = new List();

  @override
  initState() {
    super.initState();
    try {
      _mainReference
          .child("${widget.fromUserId}/message/${widget.toUserId}")
          .onChildAdded
          .listen(_onEntryAdded);
    } catch (e) {
      print(e);
    }
  }

  _onEntryAdded(Event e) {
    setState(() {
      entries.add(new Talk.fromSnapShot(e.snapshot));
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
          Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildInputArea())
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
            _mainReference
                .child("${widget.fromUserId}/message/${widget.toUserId}")
                .push()
                .set(Talk(DateTime.now(), _textEditController.text).toJson());
            print("send message :${_textEditController.text}");
            _mainReference
                .child("${widget.toUserId}/message/${widget.fromUserId}")
                .push()
                .set(Talk(DateTime.now(), _textEditController.text).toJson());
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
