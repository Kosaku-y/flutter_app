import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app2/Entity/Talk.dart';
import 'package:flutter_app2/Entity/PageParts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:intl/intl.dart';

/*----------------------------------------------

　チャットページクラス

----------------------------------------------*/
class TalkPage extends StatefulWidget {
  final User user;
  final String opponentId;

  TalkPage({Key key, this.user, this.opponentId}) : super(key: key);
  @override
  TalkPageState createState() => new TalkPageState();
}

class TalkPageState extends State<TalkPage> {
  PageParts set = PageParts();
  final _mainReference = FirebaseDatabase.instance.reference().child("User");
  final _textEditController = TextEditingController();
  var formatter = new DateFormat('yyyy/M/d/ HH:mm');

  List<Talk> talkList = new List();

  @override
  initState() {
    super.initState();
    try {
      _mainReference
          .child("${widget.user.userId}/message/${widget.opponentId}")
          .onChildAdded
          .listen(_onEntryAdded);
    } catch (e) {
      print(e);
    }
  }

  _onEntryAdded(Event e) {
    setState(() {
      talkList.add(new Talk.fromSnapShot(e.snapshot));
    });
  }

  // 画面全体のビルド
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: set.baseColor,
        title: Text(widget.opponentId,
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
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (BuildContext context, int index) {
                return _buildRow(index);
              },
              itemCount: talkList.length,
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
    Talk talk = talkList[index];
    return Container(
        margin: EdgeInsets.only(top: 8.0),
        child: talk.fromUserId == widget.user.userId
            ? _otherUserCommentRow(talk)
            : _currentUserCommentRow(talk));
  }

  Widget _currentUserCommentRow(Talk talk) {
    return Row(children: <Widget>[
      Container(child: _avatarLayout(talk)),
      SizedBox(
        width: 16.0,
      ),
      new Expanded(child: _messageLayout(talk, CrossAxisAlignment.start)),
    ]);
  }

  Widget _otherUserCommentRow(Talk talk) {
    return Row(children: <Widget>[
      new Expanded(child: _messageLayout(talk, CrossAxisAlignment.end)),
      SizedBox(
        width: 16.0,
      ),
      Container(child: _avatarLayout(talk)),
    ]);
  }

  Widget _messageLayout(Talk talk, CrossAxisAlignment alignment) {
    return Column(
      crossAxisAlignment: alignment,
      children: <Widget>[
        Text(talk.fromUserId + " ${formatter.format(talk.dateTime)}",
            style: TextStyle(fontSize: 14.0, color: Colors.grey)),
        Text(talk.message, style: TextStyle(fontSize: 10.0, color: set.pointColor)),
      ],
    );
  }

  Widget _avatarLayout(Talk talk) {
    return CircleAvatar(
      //backgroundImage: NetworkImage(entry.userImageUrl),
      child: Text(talk.fromUserId[0]),
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
          child: Icon(Icons.send, color: set.baseColor),
          onPressed: () {
            _mainReference.child("${widget.user.userId}/message/${widget.opponentId}").push().set(
                Talk(widget.opponentId, widget.user.userId, _textEditController.text).toJson());
            _mainReference.child("${widget.opponentId}/message/${widget.user.userId}").push().set(
                Talk(widget.opponentId, widget.user.userId, _textEditController.text).toJson());
            print("send message :${_textEditController.text}");
            _textEditController.clear();
            // キーボードを閉じる
            FocusScope.of(context).requestFocus(new FocusNode());
          },
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
