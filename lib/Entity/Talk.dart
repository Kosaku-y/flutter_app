import 'package:firebase_database/firebase_database.dart';

/*----------------------------------------------

トークエンティティクラス

----------------------------------------------*/
class Talk {
  String key;
  DateTime dateTime;
  String message;
  String toUserId;
  String fromUserId;

  Talk(this.dateTime, this.message);

  Talk.fromSnapShot(DataSnapshot snapshot)
      : key = snapshot.key,
        dateTime = new DateTime.fromMillisecondsSinceEpoch(snapshot.value["date"]),
        message = snapshot.value["message"],
        fromUserId = snapshot.value["fromUserId"];

  toJson() {
    return {
      "date": dateTime.millisecondsSinceEpoch,
      "message": message,
      "fromUserId": fromUserId,
    };
  }
}
