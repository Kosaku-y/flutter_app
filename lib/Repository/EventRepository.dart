import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app2/Entity/EventDetail.dart';

/*----------------------------------------------

イベント用レポジトリクラス

----------------------------------------------*/
class EventRepository {
  var eventReference = FirebaseDatabase.instance.reference().child("Events");
  var eventManagerReference = FirebaseDatabase.instance.reference().child("EventManager");
  var userReference = FirebaseDatabase.instance.reference().child("gmail");
  int eventId;

  //既存イベント変更メソッド
  Future<void> changeEvent(String pref, String line, EventDetail event) async {}

  //新規イベント追加メソッド
  Future<void> createEvent(String pref, String line, EventDetail event) async {
    try {
      await eventManagerReference.once().then((DataSnapshot snapshot) {
        //print(snapshot.value["eventId"].toString());
        eventId = int.parse(snapshot.value["eventId"]);
        String newEventId = (eventId + 1).toString();
        eventManagerReference.set({"eventId": "$newEventId"});
        event.eventId = newEventId;
        eventReference
            .child(pref)
            .child(event.station)
            .child(eventId.toString())
            .set(event.toJson());
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<EventDetail>> searchEvent(String pref, String line, String station) async {
    List<EventDetail> eventList = List();
    try {
      if (pref != null && line == null && station == null) {
        //都道府県検索
        eventReference.child(pref).once().then((DataSnapshot result) {
          result.value.forEach((k, v) {
            v.forEach((k2, v2) {
              eventList.add(new EventDetail.fromMap(v2));
            });
          });
        });
      } else if (pref != null && line != null && station != null) {
        //駅名検索
        eventReference.child("$pref/$station").once().then((DataSnapshot result) {
          result.value.forEach((k, v) {
            eventList.add(new EventDetail.fromMap(v));
          });
        });
      } else if (pref == null && line == null && station == null) {
        //全件検索
        eventReference.once().then((DataSnapshot result) {
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
}
