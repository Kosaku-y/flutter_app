import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app2/Entity/Talk.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:rxdart/rxdart.dart';

/*----------------------------------------------

トーク用Repositoryクラス

----------------------------------------------*/
class TalkRepository {
  User user;

  String roomId; // 既存用
  String toUserId, toUserName; // 新規用

  // fireBaseから取得をしたデータを流すStream
  final _realTimeMessageController = BehaviorSubject<List<Talk>>();
  BehaviorSubject<List<Talk>> get realtimeMessageStream => _realTimeMessageController;

  final _messagesReference = FirebaseDatabase.instance.reference().child("Message");
  final _userReference = FirebaseDatabase.instance.reference().child("User");
  final _roomReference = FirebaseDatabase.instance.reference().child("Room");
  List<Talk> talkList = [];

  //新規room用コンストラクタ
  TalkRepository.forNewRoom(this.user, this.toUserId, this.toUserName);

  TalkRepository(this.roomId) {
    _messagesReference.child(this.roomId).onChildAdded.listen((e) {
      print("receive(repository):${e.snapshot.value["message"]}");
      talkList.add(Talk.fromSnapShot(e.snapshot));
      _realTimeMessageController.add(talkList);
    });
  }

  //メッセージ送信
  sendMessage(String roomId, Talk talk) async {
    var json = talk.toJson();
    await _messagesReference.child(roomId).push().set(json);
    return true;
  }

  //システムメッセージ送信
  void sendSystemMessage(String roomId, String message) async {
    var talk = Talk("system", "system", message);
    var json = talk.toJson();
    await _messagesReference.child(roomId).push().set(json);
  }

  /*
  * ルームIDが存在するかどうか検索
  * ->ない場合はgetNewRoomId
  * */
  prepareRoomId() async {
    final userRoomReference = _userReference.child("${user.userId}/room");
    String newRoomId;
    await userRoomReference
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
  }

  //新規room作成
  getNewRoomId() async {
    String newRoomId = await makeNewRoomId(); //roomID生成
    //ユーザー情報に追加(送信者)
    await _userReference.child(user.userId).child("room/$newRoomId").set({
      "userName": toUserName,
      "userId": toUserId,
      "nonRead": 1,
      "timestamp": ServerValue.timestamp
    }).then((_) async {
      //ユーザー情報に追加(受信者)
      await _userReference.child(toUserId).child("room/$newRoomId").set({
        "userName": user.name,
        "userId": user.userId,
        "nonRead": 1,
        "timestamp": ServerValue.timestamp
      }).then((_) async {
        //ルーム開設
        await _roomReference.child(newRoomId).set({
          "member": {toUserId: toUserName, user.userId: user.name},
          "timestamp": ServerValue.timestamp
        });
        sendSystemMessage(newRoomId, "ルームが作成されました");
      });
    });
    return newRoomId;
  }

  //roomIdの採番
  makeNewRoomId() async {
    final talkRoomManager = FirebaseDatabase.instance.reference().child("TalkRoomManager");
    int newId; //採番
    String newRoomId;
    await talkRoomManager.once().then((DataSnapshot snapshot) {
      newId = snapshot.value["roomId"];
    });
    newRoomId = "R" + newId.toString();
    newId++;
    await talkRoomManager.set({"roomId": newId});
    return newRoomId;
  }
}
