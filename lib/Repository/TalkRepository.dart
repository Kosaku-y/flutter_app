import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app2/Entity/Talk.dart';
import 'package:flutter_app2/Entity/User.dart';

/*----------------------------------------------

トーク用Repositoryクラス

----------------------------------------------*/
class TalkRepository {
  User user;
  //既存用
  String roomId;

  //新規用
  String toUserId, toUserName;

  // fireBaseから取得をしたデータのストリームを外部に公開するための Stream
  final StreamController<List<Talk>> _eventRealTimeStream = StreamController();
  Stream<List<Talk>> get eventStream => _eventRealTimeStream.stream;

  final _messagesReference = FirebaseDatabase.instance.reference().child("Message");
  final _userReference = FirebaseDatabase.instance.reference().child("User");
  final _roomReference = FirebaseDatabase.instance.reference().child("Room");
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

  //メッセージ送信
  void sendMessage(String roomId, Talk talk) async {
    try {
      var json = talk.toJson();
      await _messagesReference.child("Message/$roomId").push().set(json);
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
    }
  }

  //新規room用コンストラクタ
  TalkRepository.forNewRoom(this.user, this.toUserId, this.toUserName);

  //新規room作成
  getNewRoomId() async {
    String newRoomId = await makeNewRoomId(); //roomID生成
    try {
      //ユーザー情報に追加
      _userReference.child(user.userId).child("room").set({
        newRoomId: {"userName": toUserName, "userID": toUserId, "nonRead": 1}
      }).then((value) {
        _userReference.child(toUserId).child("room").set({
          newRoomId: {"userName": user.name, "userID": user.userId, "nonRead": 1}
        });
        //ルーム開設
        _roomReference.set({
          newRoomId: {
            "member": {toUserId: toUserName, user.userId: user.name},
            "timestamp": ServerValue.timestamp
          }
        });
      });
      ;
      return newRoomId;
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
    }
  }

  /*
  * ルームIDが存在するかどうか検索
  * ->ない場合はgetNewRoomId
  * */
  prepareRoomId() async {
    final userReference = FirebaseDatabase.instance.reference().child("User");
    try {
      await userReference
          .orderByChild('room')
          .startAt(toUserId)
          .endAt(toUserId)
          .once()
          .then((DataSnapshot result) {
        if (result.value != null) return result.value["roomId"];
        return getNewRoomId();
      });
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
    }
  }

  //roomIdの採番
  makeNewRoomId() async {
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
