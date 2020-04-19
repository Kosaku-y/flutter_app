import 'package:firebase_database/firebase_database.dart';

/*----------------------------------------------

トークルームEntityクラス

----------------------------------------------*/

class TalkRoom {
  String _roomId; //ルームID
  String _userId; //ユーザーID
  Map<String, String> _members; //メンバー(ユーザーID,ユーザー名)
  String _roomName; //ルーム名
  int _unreadCount = 0; //未読件数

  TalkRoom.fromSnapShot(DataSnapshot snapshot) {
    _roomId = snapshot.key;
    _userId = snapshot.value["userId"];
    _unreadCount = snapshot.value["unreadCount"];
    _roomName = snapshot.value["userName"];
  }

  toJson() {
    return {
      "roomId": _roomId,
      "userId": _members,
      "roomName": _roomName,
      "unreadCount": _unreadCount,
    };
  }

  int get unreadCount => _unreadCount;
  String get userName => _roomName;
  String get roomId => _roomId;
  String get userId => _userId;
  Map<String, String> get members => _members;
}
