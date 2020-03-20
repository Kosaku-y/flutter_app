import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app2/Entity/Talk.dart';
import 'package:flutter_app2/PageParts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:intl/intl.dart';

import '../ProfileScreen.dart';

/*----------------------------------------------

　チャットページクラス

----------------------------------------------*/
class TalkScreen extends StatefulWidget {
  final User user;
  final String opponentId;
  final String opponentName;

  TalkScreen({Key key, this.user, this.opponentId, this.opponentName}) : super(key: key);
  @override
  TalkScreenState createState() => new TalkScreenState();
}

class TalkScreenState extends State<TalkScreen> {
  final PageParts _parts = PageParts();
  final _mainReference = FirebaseDatabase.instance.reference().child("User");
  final _textEditController = TextEditingController();
//  ScrollController _scrollController;
  var formatter = new DateFormat('yyyy/M/d/ HH:mm');

  List<Talk> talkList = new List();

  @override
  initState() {
    super.initState();

    ///todo
//    _scrollController = ScrollController();
//    _scrollController.addListener(() {
//      final maxScrollExtent = _scrollController.position.maxScrollExtent;
//      final currentPosition = _scrollController.position.pixels;
//      if (maxScrollExtent > 0 && (maxScrollExtent - 20.0) <= currentPosition) {
//        _addContents();
//      }
//    });
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

//  bool _isLoading = false;

//  _addContents() {
//    if (_isLoading) {
//      return;
//    }
//    _isLoading = true;
//    Future.delayed(Duration(seconds: 1), () {
//      setState(() {
//        Contents.forEach((content) => talkList.add(content));
//      });
//      _isLoading = false;
//    });
//  }

  // 画面全体のビルド
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _parts.appBar(title: widget.opponentName),
      backgroundColor: _parts.backGroundColor,
      body: Container(
          child: new Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              //controller: _scrollController,
              reverse: true,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (BuildContext context, int index) {
                return _buildRow(talkList.length - 1 - index);
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
        Text(talk.message, style: TextStyle(fontSize: 10.0, color: _parts.pointColor)),
      ],
    );
  }

  Widget _avatarLayout(Talk talk) {
    return InkWell(
      child: CircleAvatar(
        //backgroundImage: NetworkImage(entry.userImageUrl),
        child: Text(talk.fromUserId[0]),
      ),
      onTap: () => Navigator.of(context).push<Widget>(
        MaterialPageRoute(
          settings: const RouteSettings(name: "/Profile"),
          builder: (context) => new ProfileScreen(user: widget.user, userId: talk.fromUserId),
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
          child: Icon(Icons.send, color: _parts.baseColor),
          onPressed: () {
            var json = Talk(widget.opponentId, widget.opponentName, widget.user.userId,
                    widget.user.name, _textEditController.text)
                .toJson();
            _mainReference
                .child("${widget.user.userId}/message/${widget.opponentId}")
                .push()
                .set(json);
            _mainReference
                .child("${widget.opponentId}/message/${widget.user.userId}")
                .push()
                .set(json);
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
