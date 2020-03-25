import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app2/Entity/Talk.dart';

/*----------------------------------------------

トーク用レポジトリクラス

----------------------------------------------*/
class TalkRepository {
  String roomId;

  // fireBaseから取得をしたデータのストリームを外部に公開するための Stream
  final StreamController<List<Talk>> _eventRealTimeStream = StreamController();
  Stream<List<Talk>> get eventStream => _eventRealTimeStream.stream;

  final _messagesReference = FirebaseDatabase.instance.reference().child("Messages");
  List<Talk> talkList = [];
  TalkRepository(this.roomId) {
    try {
      _messagesReference.child("${this.roomId}").onChildAdded.listen((e) {
        e.snapshot.value.forEach((key, value) {
          talkList.add(Talk.fromSnapShot(value));
        });
        _eventRealTimeStream.add(talkList);
      });
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
    }
  }

  void sendMessage(String roomId, Talk talk) async {
    try {
      var json = talk.toJson();
      await FirebaseDatabase.instance.reference().child("Messages/$roomId").push().set(json);
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
    }
  }

  //ルームが存在するか検索
  Future<String> searchRoom(String userId) async {
    try {
      await _messagesReference
          .orderByChild('roomId')
          .startAt(userId)
          .endAt(userId)
          .once()
          .then((DataSnapshot result) {
        if (result.value != null) return result.value["roomId"];
      });
      return getNewRoomId();
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
    }
  }

  Future<String> getNewRoomId() async {
    final talkRoomManager = FirebaseDatabase.instance.reference().child("TalkRoomManager");
    int newId; //採番
    String newRoomId;
    try {
      await talkRoomManager.once().then((DataSnapshot snapshot) {
        newId = snapshot.value["roomId"];
      });
      newRoomId = "R" + newId.toString();
      talkRoomManager.set({"roomId": "${newId + 1}"});
      return newRoomId;
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
    }
  }
}
