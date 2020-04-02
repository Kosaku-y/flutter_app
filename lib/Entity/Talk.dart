import 'package:firebase_database/firebase_database.dart';

/*----------------------------------------------

トークEntityクラス

----------------------------------------------*/
class Talk {
  String key;
  DateTime _dateTime;
  String _message;
  String _fromUserId;
  String _fromUserName;

  Talk(this._fromUserId, this._fromUserName, this._message) : _dateTime = DateTime.now();

  Talk.fromSnapShot(DataSnapshot snapshot)
      : key = snapshot.key,
        _dateTime = new DateTime.fromMillisecondsSinceEpoch(snapshot.value["date"]),
        _message = snapshot.value["message"],
        _fromUserId = snapshot.value["fromUserId"],
        _fromUserName = snapshot.value["fromUserName"];

  toJson() {
    return {
      "date": _dateTime.millisecondsSinceEpoch,
      "message": _message,
      "fromUserId": _fromUserId,
      "fromUserName": _fromUserName,
    };
  }

  DateTime get dateTime => _dateTime;
  String get message => _message;
  String get fromUserId => _fromUserId;
  String get fromUserName => _fromUserName;
}
