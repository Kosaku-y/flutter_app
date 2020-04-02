import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app2/Bloc/EventSearchBloc.dart';
import 'package:flutter_app2/Entity/EventDetail.dart';
import 'package:flutter_app2/Entity/EventSearch.dart';
import 'package:flutter_app2/PageParts.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:flutter_app2/Repository/EventRepository.dart';
import 'package:intl/intl.dart';
import 'EventDetailScreen.dart';
import '../Talk/TalkScreen.dart';

/*----------------------------------------------

イベント検索　結果表示Screenクラス

----------------------------------------------*/
class EventSearchResultScreen extends StatelessWidget {
  final User user;
  final EventSearch eventSearch;
  EventSearchResultScreen({Key key, this.user, this.eventSearch}) : super(key: key);
  final PageParts _parts = new PageParts();

  final formatter = new DateFormat('yyyy年 M月d日(E) HH時mm分'); // 日時を指定したフォーマットで指定するためのフォーマッター
  final EventRepository eventRepository = new EventRepository();
  List<EventDetail> eventList = new List();

  @override
  Widget build(BuildContext context) {
    EventSearchBloc bloc = EventSearchBloc();
    bloc.eventSearchSink.add(eventSearch);
    return Scaffold(
      appBar: _parts.appBar(title: "検索結果"),
      backgroundColor: _parts.backGroundColor,
      body: StreamBuilder<List<EventDetail>>(
        stream: bloc.searchResultStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text("エラーが発生しました");
          if (!snapshot.hasData)
            return Center(
              child: _parts.indicator(),
            );
          if (snapshot.data == null || snapshot.data.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                      child: Center(
                    child: Text("指定の条件では見つかりませんでした。", style: TextStyle(color: _parts.pointColor)),
                  )),
                  _parts.backButton(onPressed: () => Navigator.pop(context)),
                ],
              ),
            );
          }
          eventList = snapshot.data;
          return Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Text(eventList.length.toString() + '件見つかりました。',
                    style: TextStyle(
                        color: _parts.fontColor, backgroundColor: _parts.backGroundColor)),
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
                _parts.backButton(onPressed: () => Navigator.pop(context)),
              ],
            ),
          );
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
            settings: RouteSettings(name: "/EventDetail/code=${eventList[index].eventId}"),
            builder: (context) => EventDetailScreen(user: user, event: eventList[index]),
          ),
        );
      },
      child: new SizedBox(
        child: new Card(
          elevation: 10,
          color: _parts.backGroundColor,
          child: new Container(
            decoration: BoxDecoration(
              border: Border.all(color: _parts.fontColor),
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
                            color: _parts.pointColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                        child: Text(
                          eventList[index].userName,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: _parts.fontColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                        child: Text(
                          "募集人数 :" + eventList[index].recruitMember,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: _parts.fontColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _actionWidget(context, eventList[index]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionWidget(BuildContext context, EventDetail event) {
    if (event.userId == user.userId) {
      return Container(
        child: Row(
          children: <Widget>[
            InkWell(
              onTap: () {
                print("notset");
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.check,
                  color: _parts.pointColor,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                print("notset");
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.delete,
                  color: _parts.pointColor,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: InkWell(
          onTap: () {
            Navigator.of(context).push<Widget>(MaterialPageRoute(
                settings: const RouteSettings(name: "/Talk"),
                builder: (context) => new TalkScreen(
                    user: user, toUserId: event.userId, toUserName: event.userName)));
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.mail,
              color: _parts.pointColor,
            ),
          ),
        ),
      );
    }
  }
}
