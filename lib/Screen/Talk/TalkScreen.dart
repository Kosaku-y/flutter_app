import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app2/Bloc/TalkBloc.dart';
import 'package:flutter_app2/Entity/Talk.dart';
import 'package:flutter_app2/Entity/TalkRoom.dart';
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
  final TalkRoom room;
  final String toUserId;
  final String toUserName;

  TalkScreen({Key key, this.user, this.room, this.toUserId, this.toUserName}) : super(key: key);
  @override
  TalkScreenState createState() => new TalkScreenState();
}

class TalkScreenState extends State<TalkScreen> {
  final PageParts _parts = PageParts();
  final _textEditController = TextEditingController();
  var formatter = new DateFormat('yyyy/M/d/ HH:mm');
  String roomId;
  String opponentUserName;
  List<Talk> talkList = new List();
  TalkBloc bloc;
  TalkBloc newRoomBloc;
  TextStyle messageStyle = TextStyle(fontSize: 15.0, color: Colors.white);

  @override
  initState() {
    super.initState();
    //ユーザーIDリンクからの遷移
    if (widget.room != null) {
      roomId = widget.room.roomId;
      opponentUserName = widget.room.userName;
      bloc = new TalkBloc(roomId);
    }
    //トーク履歴からの遷移
    else {
      newRoomBloc = TalkBloc.newRoom(widget.user, widget.toUserId, widget.toUserName)
        ..callPrepareRoom();
      opponentUserName = widget.toUserName;
    }

    ///@Todo
//  ScrollController _scrollController;
//    _scrollController = ScrollController();
//    _scrollController.addListener(() {
//      final maxScrollExtent = _scrollController.position.maxScrollExtent;
//      final currentPosition = _scrollController.position.pixels;
//      if (maxScrollExtent > 0 && (maxScrollExtent - 20.0) <= currentPosition) {
//        _addContents();
//      }
//    });
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
      appBar: _parts.appBar(title: opponentUserName),
      backgroundColor: _parts.backGroundColor,
      body: widget.room != null
          ? messageArea()
          : StreamBuilder<String>(
              stream: newRoomBloc.roomIdStream,
              builder: (context, snapshot) {
                print(snapshot.data);
                if (snapshot.hasError) return Text("エラーが発生しました：" + snapshot.error.toString());
                if (snapshot.connectionState == ConnectionState.waiting) return _parts.indicator;
                if (!snapshot.hasData)
                  return Text("エラーが発生しました：" + snapshot.error.toString());
                else {
                  bloc = new TalkBloc(snapshot.data);
                  newRoomBloc.dispose();
                  return messageArea();
                }
              },
            ),
    );
  }

  Widget messageArea() {
    return StreamBuilder<List<Talk>>(
      stream: bloc.messageListStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text("エラーが発生しました：" + snapshot.error.toString());
        if (snapshot.connectionState == ConnectionState.waiting) return _parts.indicator;
        if (!snapshot.hasData)
          return Text("エラーが発生しました：" + snapshot.error.toString());
        else {
          talkList = snapshot.data;
          print(talkList);
          return Container(
            child: new Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    //controller: _scrollController,
                    reverse: false,
                    padding: const EdgeInsets.all(16.0),
                    itemBuilder: (BuildContext context, int index) => _buildRow(talkList[index]),
                    itemCount: talkList.length,
                  ),
                ),
                Divider(height: 4.0),
                Container(
                    decoration: BoxDecoration(color: Theme.of(context).cardColor),
                    child: _buildInputArea())
              ],
            ),
          );
        }
      },
    );
  }

  // 投稿されたメッセージの1行を表示するWidgetを生成
  Widget _buildRow(Talk talk) {
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      child: Builder(
        builder: (_) {
          if (talk.fromUserId == widget.user.userId)
            return _otherUserCommentRow(talk);
          else if (talk.fromUserId == "system")
            return _systemCommentRow(talk);
          else
            return _currentUserCommentRow(talk);
        },
      ),
    );
  }

  Widget _currentUserCommentRow(Talk talk) {
    return Row(children: <Widget>[
      Container(child: _avatarLayout(talk)),
      SizedBox(width: 16.0),
      new Expanded(child: _messageLayout(talk, CrossAxisAlignment.start)),
    ]);
  }

  Widget _otherUserCommentRow(Talk talk) {
    return Row(children: <Widget>[
      new Expanded(child: _messageLayout(talk, CrossAxisAlignment.end)),
      SizedBox(width: 16.0),
      Container(child: _avatarLayout(talk)),
    ]);
  }

  Widget _systemCommentRow(Talk talk) {
    return Center(child: Text(talk.message, style: messageStyle));
  }

  Widget _messageLayout(Talk talk, CrossAxisAlignment alignment) {
    return Column(
      crossAxisAlignment: alignment,
      children: <Widget>[
        Text("${formatter.format(talk.dateTime)} ${talk.fromUserName}",
            style: TextStyle(fontSize: 14.0, color: Colors.grey)),
        Text(talk.message, style: messageStyle),
      ],
    );
  }

  Widget _avatarLayout(Talk talk) {
    return InkWell(
      child: CircleAvatar(
          //backgroundImage: NetworkImage(entry.userImageUrl),
          child: Text(talk.fromUserName[0])),
      onTap: () => Navigator.of(context).push<Widget>(
        MaterialPageRoute(
          settings: const RouteSettings(name: "/Profile"),
          builder: (context) => new ProfileScreen(
            user: widget.user,
            userId: talk.fromUserId,
            userName: talk.fromUserName,
          ),
        ),
      ),
    );
  }

  // 投稿メッセージの入力部分のWidgetを生成
  Widget _buildInputArea() {
    return Row(
      children: <Widget>[
        SizedBox(width: 16.0),
        Expanded(child: TextField(controller: _textEditController)),
        CupertinoButton(
          child: Icon(Icons.send, color: _parts.baseColor),
          onPressed: () {
            var talk = Talk(widget.user.userId, widget.user.name, _textEditController.text);
            bloc.callSendMessage(talk);
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
    bloc?.dispose();
    newRoomBloc?.dispose();
    _textEditController.dispose();
  }
}
