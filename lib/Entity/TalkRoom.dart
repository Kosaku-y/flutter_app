import 'package:firebase_database/firebase_database.dart';

/*----------------------------------------------

トークルームEntityクラス

----------------------------------------------*/
class TalkRoom {
  String _roomId;
  Map<String, String> _members;
  String _userName;
  int _noRead = 0;

  TalkRoom.fromSnapShot(DataSnapshot snapshot)
      : _roomId = snapshot.value["roomId"],
        _userName = snapshot.value["userName"],
        _noRead = snapshot.value["fromUserName"] {
    snapshot.value["member"].forEach((key, value) {
      _members[key] = value;
    });
  }

  toJson() {
    return {
      "roomId": _roomId,
      "userId": _members,
      "userName": _userName,
      "noRead": _noRead,
    };
  }

  int get noRead => _noRead;

  String get userName => _userName;

  String get roomId => _roomId;

  Map<String, String> get members => _members;
}
