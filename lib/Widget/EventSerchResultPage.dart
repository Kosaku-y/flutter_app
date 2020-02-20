import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app2/Entity/EventDetail.dart';
import 'package:flutter_app2/Entity/EventSearch.dart';
import 'package:flutter_app2/Entity/PageParts.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:flutter_app2/Repository/EventRepository.dart';
import 'package:intl/intl.dart';

import 'package:flutter_app2/Widget/EventSearchResultDetailPage.dart';

import 'TalkPage.dart';

/*----------------------------------------------

イベント検索　結果表示クラス

----------------------------------------------*/
class EventSearchResultPage extends StatefulWidget {
  EventSearch eventSearch;
  User user;
  EventSearchResultPage({Key key, this.user, this.eventSearch}) : super(key: key);

  @override
  EventSearchResultPageState createState() => new EventSearchResultPageState();
}

/*----------------------------------------------

イベント検索　結果表示ページ出力（リスト表示）クラス

----------------------------------------------*/
class EventSearchResultPageState extends State<EventSearchResultPage> {
  PageParts set = new PageParts();
  final _mainReference = FirebaseDatabase.instance.reference().child("Events");

  //EventSearchResultPageState(this.pref, this.line, this.station);

  var formatter = new DateFormat('yyyy年 M月d日(E) HH時mm分'); // 日時を指定したフォーマットで指定するためのフォーマッター
  //EventRepository eventRepository = new EventRepository();
  List<EventDetail> eventList = new List();

  @override
  //初期コールメソッド
  void initState() {
    super.initState();
    _createList();
  }

  _createList() {
    print("${widget.eventSearch.pref},${widget.eventSearch.line},${widget.eventSearch.station}");
    //都道府県検索
    if (widget.eventSearch.pref != null &&
        widget.eventSearch.line == null &&
        widget.eventSearch.station == null) {
      _mainReference.child(widget.eventSearch.pref).once().then((DataSnapshot result) {
        result.value.forEach((k, v) {
          v.forEach((k2, v2) {
            setState(() {
              eventList.add(new EventDetail.fromMap(v2));
            });
          });
        });
      });
      //駅名検索
    } else if (widget.eventSearch.pref != null &&
        widget.eventSearch.line != null &&
        widget.eventSearch.station != null) {
      //駅名検索
      _mainReference
          .child("${widget.eventSearch.pref}/${widget.eventSearch.station}")
          .once()
          .then((DataSnapshot result) {
        result.value.forEach((k, v) {
          setState(() {
            eventList.add(new EventDetail.fromMap(v));
          });
        });
      });
    } else if (widget.eventSearch.pref == null &&
        widget.eventSearch.line == null &&
        widget.eventSearch.station == null) {
      _mainReference.once().then((DataSnapshot result) {
        result.value.forEach((k, v) {
          v.forEach((k1, v1) {
            v1.forEach((k2, v2) {
              setState(() {
                eventList.add(new EventDetail.fromMap(v2));
              });
            });
          });
        });
      });
    }
  }

  //画面全体のビルド
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: set.baseColor,
        title: Text('検索結果',
            style: TextStyle(
              color: set.pointColor,
            )),
      ),
      backgroundColor: set.backGroundColor,
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: new Column(
            children: <Widget>[
              Text(eventList.length.toString() + '件見つかりました。',
                  style: TextStyle(color: set.fontColor, backgroundColor: set.backGroundColor)),
              Expanded(
                child: ListView.builder(
                  //padding: const EdgeInsets.all(16.0),
                  itemBuilder: (BuildContext context, int index) {
                    return _buildRow(index);
                  },
                  itemCount: eventList.length,
                ),
              ),
              Divider(
                height: 8.0,
              ),
              RaisedButton.icon(
                label: Text("戻る"),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: set.fontColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
//              Container(
//                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
//                  child: _buildInputArea()
//              )
            ],
          )),
    );
  }

  //リスト要素生成
  Widget _buildRow(int index) {
    //リストの要素一つづつにonTapを付加して、詳細ページに飛ばす
    return InkWell(
      onTap: () {
//        Navigator.push(
//          this.context,
//          MaterialPageRoute(
//            // パラメータを渡す
//            builder: (context) => new EventSearchResultDetailPage(entries[index]),
//          ),
//        );
        Navigator.of(context).push<Widget>(
          MaterialPageRoute(
            settings: const RouteSettings(name: "/EventSearchResultDetail/"),
            builder: (context) =>
                EventSearchResultDetailPage(user: widget.user, event: eventList[index]),
          ),
        );
      },
      child: new SizedBox(
        child: new Card(
          elevation: 10,
          color: set.backGroundColor,
          child: new Container(
            decoration: BoxDecoration(
              border: Border.all(color: set.fontColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              // 1行目
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                        child: Text(
                          eventList[index].station + "駅",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: set.pointColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                        child: Text(
                          eventList[index].userId,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: set.fontColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                        child: Text(
                          "EventID :" + eventList[index].eventId.toString(),
                          style: TextStyle(
                            fontSize: 16.0,
                            color: set.fontColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push<Widget>(MaterialPageRoute(
                          settings: const RouteSettings(name: "/Talk"),
                          builder: (context) => new TalkPage(
                              user: widget.user, opponentId: eventList[index].userId)));
                    },
                    child: Icon(
                      Icons.mail,
                      color: set.pointColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
