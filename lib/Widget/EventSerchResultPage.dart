import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app2/Entity/EventDetail.dart';
import 'package:flutter_app2/Entity/PageParts.dart';
import 'package:flutter_app2/Repository/EventRepository.dart';
import 'package:intl/intl.dart';

import 'package:flutter_app2/Widget/EventDetailPage.dart';

/*----------------------------------------------

イベント検索　結果表示クラス

----------------------------------------------*/
class EventSearchResultPage extends StatefulWidget {
  String pref;
  String line;
  String station;

  EventSearchResultPage({Key key, this.pref, this.line, this.station}) : super(key: key);

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
  EventRepository eventRepository = new EventRepository();
  List<EventDetail> entries = new List();

  @override
  //初期コールメソッド
  void initState() {
    super.initState();
    _createList();
  }

  _createList() {
    print("${widget.pref},${widget.line},${widget.station}");
    //都道府県検索
    if (widget.pref != null && widget.line == null && widget.station == null) {
      _mainReference.child(widget.pref).once().then((DataSnapshot result) {
        result.value.forEach((k, v) {
          v.forEach((k2, v2) {
            setState(() {
              entries.add(new EventDetail.fromMap(v2));
            });
          });
        });
      });
      //駅名検索
    } else if (widget.pref != null && widget.line != null && widget.station != null) {
      //駅名検索
      _mainReference.child("${widget.pref}/${widget.station}").once().then((DataSnapshot result) {
        result.value.forEach((k, v) {
          setState(() {
            entries.add(new EventDetail.fromMap(v));
          });
        });
      });
    } else if (widget.pref == null && widget.line == null && widget.station == null) {
      _mainReference.once().then((DataSnapshot result) {
        result.value.forEach((k, v) {
          v.forEach((k1, v1) {
            v1.forEach((k2, v2) {
              setState(() {
                entries.add(new EventDetail.fromMap(v2));
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
              Text(entries.length.toString() + '件見つかりました。',
                  style: TextStyle(color: set.fontColor, backgroundColor: set.backGroundColor)),
              Expanded(
                child: ListView.builder(
                  //padding: const EdgeInsets.all(16.0),
                  itemBuilder: (BuildContext context, int index) {
                    return _buildRow(index);
                  },
                  itemCount: entries.length,
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
    return new GestureDetector(
      onTap: () {
        Navigator.of(context).push<Widget>(
            MaterialPageRoute(builder: (context) => new EventDetailPage(entries[index])));
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Text(
                    entries[index].station + "駅",
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
                    entries[index].userId,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: set.fontColor,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                  child: Text(
                    "EventID :" + entries[index].eventId.toString(),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: set.fontColor,
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
