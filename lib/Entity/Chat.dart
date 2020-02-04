import 'package:firebase_database/firebase_database.dart';

/*----------------------------------------------

チャットエンティティクラス

----------------------------------------------*/
class ChatEntity {
  String key;
  DateTime dateTime;
  String message;
  String fromUserId;

  ChatEntity(this.dateTime, this.message);

  ChatEntity.fromSnapShot(DataSnapshot snapshot)
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
