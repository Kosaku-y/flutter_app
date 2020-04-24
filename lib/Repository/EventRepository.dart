import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app2/Entity/EventDetail.dart';
import 'package:flutter_app2/Entity/EventSearch.dart';
import 'package:flutter_app2/SystemError.dart';
import 'package:http/http.dart' as http;

/*----------------------------------------------

イベント(作成・更新・削除)Repositoryクラス

----------------------------------------------*/

class EventRepository {
  final _eventReference = FirebaseDatabase.instance.reference().child("Events");
  final String _apiKey = "LE_UaP7Vyjs3wQPa"; // 駅すぱあとAPIキー(フリープラン)

  //既存イベント更新メソッド
  Future<void> changeEvent(String pref, String line, EventDetail event) async {}

  //新規イベント作成メソッド
  createEvent(String stationCode, EventDetail event) async {
    String newId; //採番用
    String newRoomId;
    final _eventManagerReference = FirebaseDatabase.instance.reference().child("EventManager");
    //新規EventId取得
    await _eventManagerReference.once().then((DataSnapshot snapshot) {
      newId = snapshot.value["eventId"];
    });

    if (newId.isEmpty) throw FirebaseError(); //データ取得エラー処理
    String prefName = await getPrefName(stationCode); //駅の所在する都道府県検索
    event.pref = prefName;
    event.eventId = newId + "E";

    //新規IDセット処理＋イベント作成
    await _eventManagerReference.set({"eventId": (int.parse(newId) + 1).toString()}).then((_) =>
        _eventReference
            .child(prefName)
            .child("${event.station}/${event.eventId}")
            .set(event.toJson()));
    return true;
  }

  //イベント修正
  modifyEvent(String stationCode, EventDetail event) async {
    String prefName = await getPrefName(stationCode);
    event.pref = prefName;
    _eventReference.child(prefName).child(event.station).child(event.eventId).set(event.toJson());
  }

  //駅の所在都道府県を取得
  getPrefName(String stationCode) async {
    var url =
        "http://api.ekispert.jp/v1/json/station/light?code=$stationCode&gcs=tokyo&key=$_apiKey";
    http.Response response = await http.get(url);
    var body = response.body;
    Map<String, dynamic> responseMap = jsonDecode(body); //レスポンス受信用Map
    String prefName = responseMap["ResultSet"]["Point"]["Prefecture"]["Name"];
    return prefName;
  }

  //期限切れイベント削除
  /*
  Future<void> _delete() async {
    try {
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
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
    }
  }
  */

  //イベント検索メソッド
  searchEvent(EventSearch e) async {
    List<EventDetail> eventList = List();
    //if (true) throw FirebaseError(); //データ取得エラー処理
    if (e.pref != null && e.line == null && e.station == null) {
      //都道府県検索
      await _eventReference.child(e.pref).once().then((DataSnapshot result) {
        if (result.value == null) return null;
        result.value.forEach((k, v) {
          v.forEach((k2, v2) {
            eventList.add(new EventDetail.fromMap(v2));
          });
        });
      });
    } else if (e.pref != null && e.line != null && e.station == null) {
      //路線検索
      return null;
    } else if (e.pref != null && e.line != null && e.station != null) {
      //駅名検索
      await _eventReference.child("${e.pref}/${e.station}").once().then((DataSnapshot result) {
        if (result.value == null) return null;
        result.value.forEach((k, v) {
          eventList.add(new EventDetail.fromMap(v));
        });
      });
    } else if (e.pref == null && e.line == null && e.station == null) {
      //全件検索
      await _eventReference.once().then((DataSnapshot result) {
        if (result.value == null) return null;
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
  }

  //路線Picker作成
  createLineMap(String prefCode) async {
    //APIコール
    var url = "http://api.ekispert.jp/v1/json/operationLine?prefectureCode=" +
        "$prefCode&offset=1&limit=100&gcs=tokyo&key=$_apiKey";
    http.Response response = await http.get(url);
    var body = response.body;
    //レスポンス受信用Map
    Map<String, dynamic> responseMap = jsonDecode(body);
    //return用Map
    Map<String, String> lineMap = Map();
    lineMap[" "] = " "; //空データ挿入
    responseMap["ResultSet"]["Line"].forEach((i) {
      lineMap[i["Name"]] = i["code"];
    });
    return lineMap;
  }

  //駅Picker作成
  createStationMap(String lineCode) async {
    //APIコール
    var url = "http://api.ekispert.jp/v1/json/station?operationLineCode="
        "$lineCode&type=train&offset=1&limit=100&direction=up&gcs=tokyo&key=$_apiKey";
    http.Response response = await http.get(url);
    var body = response.body;
    Map<String, dynamic> responseMap = jsonDecode(body); //レスポンス受信用Map
    Map<String, String> stationMap = Map(); //return用Map
    stationMap[" "] = " "; //空データ挿入
    responseMap["ResultSet"]["Point"].forEach((i) {
      stationMap[i["Station"]["Name"]] = i["Station"]["code"];
    });
    return stationMap;
  }

  //ログ出力用
  void printMap(String actionName, Map map) {
    print("\n-----------$actionName Data-----------\n"
        "eventId: ${map["eventId"].toString()}\n"
        "member : ${map["recruitMember"]}\n"
        "station: ${map["station"]}\n"
        "start  : ${DateTime.fromMillisecondsSinceEpoch(map["startingTime"]).toString()}\n"
        "end    : ${DateTime.fromMillisecondsSinceEpoch(map["endingTime"]).toString()}\n"
        "comment: ${map["comment"]}\n"
        "-------------------------------\n");
  }
}
