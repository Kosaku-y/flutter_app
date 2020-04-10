/*----------------------------------------------

トークルームEntityクラス

----------------------------------------------*/
import 'package:firebase_database/firebase_database.dart';

class TalkRoom {
  String _roomId;
  String _userId;
  Map<String, String> _members;
  String _roomName;
  int _noRead = 0;

  TalkRoom.fromSnapShot(DataSnapshot snapshot) {
    _roomId = snapshot.key;
    _userId = snapshot.value["userId"];
    _noRead = snapshot.value["nonRead"];
    _roomName = snapshot.value["userName"];
  }

  toJson() {
    return {
      "roomId": _roomId,
      "userId": _members,
      "roomName": _roomName,
      "noRead": _noRead,
    };
  }

  int get noRead => _noRead;

  String get userName => _roomName;

  String get roomId => _roomId;

  String get userId => _userId;

  Map<String, String> get members => _members;
}
