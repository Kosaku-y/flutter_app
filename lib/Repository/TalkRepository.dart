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
  final StreamController<List<Talk>> _realTimeMessageController = StreamController();
  Stream<List<Talk>> get realtimeMessageStream => _realTimeMessageController.stream;

  final _messagesReference = FirebaseDatabase.instance.reference().child("Message");
  final _userReference = FirebaseDatabase.instance.reference().child("User");
  final _roomReference = FirebaseDatabase.instance.reference().child("Room");
  List<Talk> talkList = [];

  TalkRepository(this.roomId) {
    try {
      _messagesReference.child("${this.roomId}").onChildAdded.listen((e) {
        talkList.add(Talk.fromSnapShot(e.snapshot));
        _realTimeMessageController.add(talkList);
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
      await _messagesReference.child(roomId).push().set(json);
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
    }
  }

  //メッセージ送信
  void sendSystemMessage(String roomId, String message) async {
    try {
      var talk = Talk("system", "system", message);
      var json = talk.toJson();
      await _messagesReference.child(roomId).push().set(json);
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
    }
  }

  //新規room用コンストラクタ
  TalkRepository.forNewRoom(this.user, this.toUserId, this.toUserName);

  /*
  * ルームIDが存在するかどうか検索
  * ->ない場合はgetNewRoomId
  * */
  prepareRoomId() async {
    final userReference = FirebaseDatabase.instance.reference().child("User/${user.userId}/room");
    String newRoomId;
    try {
      await userReference
          .orderByChild('userId')
          .limitToFirst(1)
          .equalTo(toUserId)
          .once()
          .then((DataSnapshot result) {
        if (result.value != null) {
          result.value.forEach((k, v) {
            newRoomId = k;
          });
        }
      });
      if (newRoomId != null) return newRoomId;
      newRoomId = await getNewRoomId();
      return newRoomId;
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
    }
  }

  //新規room作成
  getNewRoomId() async {
    String newRoomId = await makeNewRoomId(); //roomID生成
    try {
      //ユーザー情報に追加(送信者)
      _userReference.child(user.userId).child("room/$newRoomId").set({
        "userName": toUserName,
        "userId": toUserId,
        "nonRead": 1,
        "timestamp": ServerValue.timestamp
      }).then((_) {
        //ユーザー情報に追加(受信者)
        _userReference.child(toUserId).child("room/$newRoomId").set({
          "userName": user.name,
          "userId": user.userId,
          "nonRead": 1,
          "timestamp": ServerValue.timestamp
        }).then((_) {
          //ルーム開設
          _roomReference.child(newRoomId).set({
            "member": {toUserId: toUserName, user.userId: user.name},
            "timestamp": ServerValue.timestamp
          });
          sendSystemMessage(newRoomId, "ルームが作成されました");
        });
      });
      return newRoomId;
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
      newId++;
      await talkRoomManager.set({"roomId": newId});
      return newRoomId;
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
    }
  }
}
