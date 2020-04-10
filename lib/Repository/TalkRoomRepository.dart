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
  final StreamController<List<TalkRoom>> _eventRealTimeStream = StreamController.broadcast();
  Stream<List<TalkRoom>> get eventStream => _eventRealTimeStream.stream;

  final _userReference = FirebaseDatabase.instance.reference().child("User");
  List<TalkRoom> talkRoomList = [];
  TalkRoomRepository(this.user) {
    try {
      _userReference.child("${user.userId}/room").onChildAdded.listen((e) {
        if (e.snapshot != null) {
          talkRoomList.add(TalkRoom.fromSnapShot(e.snapshot));
          _eventRealTimeStream.add(talkRoomList);
        } else {
          _eventRealTimeStream.add([]);
        }
      });
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
    }
  }
}
