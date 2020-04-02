import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app2/Entity/TalkRoom.dart';
import 'package:flutter_app2/Entity/User.dart';

/*----------------------------------------------

トークルーム用Repositoryクラス

----------------------------------------------*/
class TalkRoomRepository {
  User user;
  // fireBaseから取得をしたデータのストリームを外部に公開するための Stream
  final StreamController<List<TalkRoom>> _eventRealTimeStream = StreamController();
  Stream<List<TalkRoom>> get eventStream => _eventRealTimeStream.stream;

  final _userReference = FirebaseDatabase.instance.reference().child("User");

  TalkRoomRepository(this.user) {
    try {
      _userReference.child("${user.userId}/room/").onChildAdded.listen((e) {
        if (e.snapshot != null) {
          _eventRealTimeStream.add(getRoomList(e.snapshot));
        } else {
          _eventRealTimeStream.add([]);
        }
      });
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
    }
  }

  //トークルーム一覧を取得
  List<TalkRoom> getRoomList(DataSnapshot snapshot) {
    List<TalkRoom> roomList = [];
    snapshot.value.forEach((k, v) {
      roomList.add(TalkRoom.fromSnapShot(v));
    });
    return roomList;
  }
}
