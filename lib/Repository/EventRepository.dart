import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app2/Entity/EventDetail.dart';
import 'package:flutter_app2/Entity/EventSearch.dart';
import 'package:http/http.dart' as http;

/*----------------------------------------------

イベント用レポジトリクラス

----------------------------------------------*/
class EventRepository {
  final _eventReference = FirebaseDatabase.instance.reference().child("Events");
  final _eventManagerReference = FirebaseDatabase.instance.reference().child("EventManager");
  final _userReference = FirebaseDatabase.instance.reference();
  int eventId;

  //既存イベント変更メソッド
  Future<void> changeEvent(String pref, String line, EventDetail event) async {}

  //新規イベント追加メソッド
  Future<void> createEvent(String pref, String line, EventDetail event) async {
    try {
      await _eventManagerReference.once().then((DataSnapshot snapshot) {
        eventId = int.parse(snapshot.value["eventId"]);
        String newEventId = (eventId + 1).toString().padLeft(7, "0"); // => 001;
        event.eventId = "E" + newEventId;
        _eventManagerReference.set({"eventId": "${eventId + 1}"});
        _eventReference.child(pref).child(event.station).child(event.eventId).set(event.toJson());
      });
    } catch (e) {
      print(e);
    }
  }

  //期限切れイベント削除用メソッド
  Future<void> _delete() async {
    DateTime now = DateTime.now();
    await _eventReference.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((k, v) {
        v.forEach((k1, v1) {
          v1.forEach((k2, v2) {
            if (DateTime.fromMillisecondsSinceEpoch(v2["endingTime"]).isBefore(now)) {
              _eventReference.child(k).child(k1).child(k2).remove();
              printMap("remove", v2);
            }
          });
        });
      });
    });
  }

  //イベント検索メソッド
  Future<List<EventDetail>> searchEvent(EventSearch e) async {
    List<EventDetail> eventList = List();
    try {
      if (e.pref != "" && e.line == "" && e.station == "") {
        //都道府県検索
        await _eventReference.child(e.pref).once().then((DataSnapshot result) {
          result.value.forEach((k, v) {
            v.forEach((k2, v2) {
              eventList.add(new EventDetail.fromMap(v2));
            });
          });
        });
      } else if (e.pref != "" && e.line != "" && e.station != "") {
        //駅名検索
        await _eventReference.child("${e.pref}/${e.station}").once().then((DataSnapshot result) {
          result.value.forEach((k, v) {
            eventList.add(new EventDetail.fromMap(v));
          });
        });
      } else if (e.pref == "" && e.line == "" && e.station == "") {
        //全件検索
        await _eventReference.once().then((DataSnapshot result) {
          result.value.forEach((k, v) {
            v.forEach((k1, v1) {
              v1.forEach((k2, v2) {
                eventList.add(new EventDetail.fromMap(v2));
              });
            });
          });
        });
      }
      return eventList;
    } catch (error) {
      print(error);
    }
  }

  //路線Picker作成
  Future<Map<String, String>> createLineMap(String prefCode) async {
    //APIコール
    var url = "http://api.ekispert.jp/v1/json/operationLine?prefectureCode=" +
        "$prefCode&offset=1&limit=100&gcs=tokyo&key=LE_UaP7Vyjs3wQPa";
    http.Response response = await http.get(url);
    var body = response.body;
    //レスポンス受信用Map
    Map<String, dynamic> responseMap = jsonDecode(body);
    //return用Map
    Map<String, String> lineMap = Map();
    lineMap["--選択して下さい--"] = " "; //空データ挿入
    responseMap["ResultSet"]["Line"].forEach((i) {
      lineMap[i["Name"]] = i["code"];
    });
    return lineMap;
  }

  //駅Picker作成
  Future<Map<String, String>> createStationMap(String lineCode) async {
    //APIコール
    var url = "http://api.ekispert.jp/v1/json/station?operationLineCode=" +
        "$lineCode&type=train&offset=1&limit=100&direction=up&gcs=tokyo&key=LE_UaP7Vyjs3wQPa";
    http.Response response = await http.get(url);
    var body = response.body;
    Map<String, dynamic> responseMap = jsonDecode(body); //レスポンス受信用Map
    Map<String, String> stationMap = Map(); //return用Map
    stationMap["--選択して下さい--"] = " "; //空データ挿入
    responseMap["ResultSet"]["Point"].forEach((i) {
      stationMap[i["Station"]["Name"]] = i["Station"]["code"];
    });
    return stationMap;
  }

  void addUsersEvent(String eventId) {}
  //ログ出力用メソッド
  void printMap(String actionName, Map map) {
    print("\n-----------$actionName Data-----------\n"
            "eventId: ${map["eventId"].toString()}\n" +
        "member : ${map["recruitMember"]}\n" +
        "station: ${map["station"]}\n" +
        "start  : ${DateTime.fromMillisecondsSinceEpoch(map["startingTime"]).toString()}\n" +
        "end    : ${DateTime.fromMillisecondsSinceEpoch(map["endingTime"]).toString()}\n" +
        "comment: ${map["comment"]}\n" +
        "\n-------------------------------\n");
  }
}
