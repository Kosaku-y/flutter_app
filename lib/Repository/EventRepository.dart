import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app2/Entity/EventDetail.dart';

/*----------------------------------------------

イベント用レポジトリクラス

----------------------------------------------*/
class EventRepository {
  final _eventReference = FirebaseDatabase.instance.reference().child("Events");
  final _eventManagerReference = FirebaseDatabase.instance.reference().child("EventManager");
  final _userReference = FirebaseDatabase.instance.reference().child("gmail");
  int eventId;

  //既存イベント変更メソッド
  Future<void> changeEvent(String pref, String line, EventDetail event) async {}

  //新規イベント追加メソッド
  Future<void> createEvent(String pref, String line, EventDetail event) async {
    try {
      await _eventManagerReference.once().then((DataSnapshot snapshot) {
        //print(snapshot.value["eventId"].toString());
        eventId = int.parse(snapshot.value["eventId"]);
        String newEventId = (eventId + 1).toString();
        _eventManagerReference.set({"eventId": "$newEventId"});
        event.eventId = newEventId;
        _eventReference
            .child(pref)
            .child(event.station)
            .child(eventId.toString())
            .set(event.toJson());
      });
    } catch (e) {
      print(e);
    }
  }

  //期限切れイベント削除用メソッド
  void _delete() {
    DateTime now = DateTime.now();
    _eventReference.once().then((DataSnapshot snapshot) {
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
  Future<List<EventDetail>> searchEvent(String pref, String line, String station) async {
    List<EventDetail> eventList = List();
    try {
      if (pref != null && line == null && station == null) {
        //都道府県検索
        _eventReference.child(pref).once().then((DataSnapshot result) {
          result.value.forEach((k, v) {
            v.forEach((k2, v2) {
              eventList.add(new EventDetail.fromMap(v2));
            });
          });
        });
      } else if (pref != null && line != null && station != null) {
        //駅名検索
        _eventReference.child("$pref/$station").once().then((DataSnapshot result) {
          result.value.forEach((k, v) {
            eventList.add(new EventDetail.fromMap(v));
          });
        });
      } else if (pref == null && line == null && station == null) {
        //全件検索
        _eventReference.once().then((DataSnapshot result) {
          result.value.forEach((k, v) {
            v.forEach((k1, v1) {
              v1.forEach((k2, v2) {
                eventList.add(new EventDetail.fromMap(v2));
              });
            });
          });
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void addUsersEvent(String eventId) {}
  //ログ出力用メソッド
  void printMap(String actionName, Map map) {
    print("\n-----------$actionName Data-----------\n"
            "eventId:" +
        map["eventId"].toString() +
        "\n"
            "member:" +
        map["recruitMember"] +
        "\n"
            "station:" +
        map["station"] +
        "\n"
            "start:" +
        DateTime.fromMillisecondsSinceEpoch(map["startingTime"]).toString() +
        "\n"
            "end:" +
        DateTime.fromMillisecondsSinceEpoch(map["endingTime"]).toString() +
        "\n"
            "comment:" +
        map["comment"] +
        "\n"
            "-------------------------------\n");
  }
}
