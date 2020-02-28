import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app2/Bloc/EventSearchBloc.dart';
import 'package:flutter_app2/Entity/EventDetail.dart';
import 'package:flutter_app2/Entity/EventSearch.dart';
import 'package:flutter_app2/Entity/PageParts.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:flutter_app2/Repository/EventRepository.dart';
import 'package:intl/intl.dart';

import 'package:flutter_app2/Widget/EventSearchResultDetailPage.dart';

import 'TalkPage.dart';

/*----------------------------------------------

イベント検索　結果表示ページ出力（リスト表示）クラス

----------------------------------------------*/
class EventSearchResultPage extends StatelessWidget {
  User user;
  EventSearch eventSearch;
  EventSearchResultPage({Key key, this.user, this.eventSearch}) : super(key: key);
  PageParts set = new PageParts();

  var formatter = new DateFormat('yyyy年 M月d日(E) HH時mm分'); // 日時を指定したフォーマットで指定するためのフォーマッター
  EventRepository eventRepository = new EventRepository();
  List<EventDetail> eventList = new List();
  //画面全体のビルド
  @override
  Widget build(BuildContext context) {
    EventSearchBloc bloc = EventSearchBloc();
    bloc.eventSearchSink.add(eventSearch);
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
      body: StreamBuilder<List<EventDetail>>(
        stream: bloc.searchResultStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("エラーが発生しました");
          } else if (!snapshot.hasData) {
            return Center(
              child: set.indicator(),
            );
          } else {
            if (snapshot.data == null || snapshot.data.isEmpty) {
              return Center(
                child: Text(
                  "指定の条件では見つかりませんでした。",
                  style: TextStyle(color: set.pointColor),
                ),
              );
            } else {
              eventList = snapshot.data;
              return Container(
                padding: const EdgeInsets.all(20.0),
                child: new Column(
                  children: <Widget>[
                    Text(eventList.length.toString() + '件見つかりました。',
                        style:
                            TextStyle(color: set.fontColor, backgroundColor: set.backGroundColor)),
                    Expanded(
                      child: ListView.builder(
                        //padding: const EdgeInsets.all(16.0),
                        itemBuilder: (BuildContext context, int index) {
                          return _buildRow(context, index);
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
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }

  //リスト要素生成
  Widget _buildRow(BuildContext context, int index) {
    //リストの要素一つづつにonTapを付加して、詳細ページに飛ばす
    return InkWell(
      onTap: () {
        Navigator.of(context).push<Widget>(
          MaterialPageRoute(
            settings:
                RouteSettings(name: "/EventSearchResultDetail/code=${eventList[index].eventId}"),
            builder: (context) => EventSearchResultDetailPage(user: user, event: eventList[index]),
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
                          builder: (context) =>
                              new TalkPage(user: user, opponentId: eventList[index].userId)));
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
