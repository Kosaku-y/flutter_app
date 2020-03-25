import 'package:firebase_database/firebase_database.dart';

/*----------------------------------------------

トークルームEntityクラス

----------------------------------------------*/
class TalkRoom {
  String _roomId;
  String _userId;
  String _userName;
  int _noRead = 0;

  TalkRoom.fromSnapShot(DataSnapshot snapshot)
      : _roomId = snapshot.value["roomId"],
        _userId = snapshot.value["userId"],
        _userName = snapshot.value["userName"],
        _noRead = snapshot.value["fromUserName"];

  toJson() {
    return {
      "roomId": _roomId,
      "userId": _userId,
      "userName": _userName,
      "noRead": _noRead,
    };
  }

  int get noRead => _noRead;

  String get userName => _userName;

  String get roomId => _roomId;

  String get userId => _userId;
}
