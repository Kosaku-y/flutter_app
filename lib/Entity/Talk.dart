import 'package:firebase_database/firebase_database.dart';

/*----------------------------------------------

トークエンティティクラス

----------------------------------------------*/
class Talk {
  String key;
  DateTime _dateTime;
  String _message;
  String _toUserId;
  String _fromUserId;

  Talk(this._toUserId, this._fromUserId, this._message) : _dateTime = DateTime.now();

  Talk.fromSnapShot(DataSnapshot snapshot)
      : key = snapshot.key,
        _dateTime = new DateTime.fromMillisecondsSinceEpoch(snapshot.value["date"]),
        _message = snapshot.value["message"],
        _toUserId = snapshot.value["toUserId"],
        _fromUserId = snapshot.value["fromUserId"];

  toJson() {
    return {
      "date": _dateTime.millisecondsSinceEpoch,
      "message": _message,
      "toUserId": _toUserId,
      "fromUserId": _fromUserId,
    };
  }

  DateTime get dateTime => _dateTime;
  String get message => _message;
  String get toUserId => _toUserId;
  String get fromUserId => _fromUserId;
}
