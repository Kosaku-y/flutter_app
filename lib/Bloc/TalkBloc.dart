import 'dart:async';
import 'package:flutter_app2/Entity/Talk.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:flutter_app2/Repository/TalkRepository.dart';
import 'package:rxdart/rxdart.dart';

/*----------------------------------------------

トークBlocクラス

----------------------------------------------*/
class TalkBloc {
  String roomId;
  TalkRepository repository;

  //メッセージ受信用Stream(from repository)
  final _messageListController = StreamController<List<Talk>>.broadcast();
  Stream<List<Talk>> get messageListStream => _messageListController.stream;
  //List<String> messageList = new List();

  //roomIdを流すStream
  final _roomIdController = BehaviorSubject<String>.seeded(null);
  Stream<String> get roomIdStream => _roomIdController.stream;

  //リンクからの遷移
  TalkBloc.newRoom(User user, String toUserId, String toUserName) {
    this.repository = TalkRepository.forNewRoom(user, toUserId, toUserName);
  }

  //履歴からの遷移
  TalkBloc(this.roomId) {
    this.repository = TalkRepository(roomId);
    //メッセージリアルタイム更新
    try {
      repository.realtimeMessageStream.listen((message) {
        _messageListController.add(message);
      });
    } catch (e) {
      _messageListController.addError(e);
    }
  }

  callSendMessage(Talk talk) {
    //@Todo error処理
    try {
      repository.sendMessage(this.roomId, talk);
    } catch (e) {}
  }

  callPrepareRoom() async {
    try {
      String roomId = await repository.prepareRoomId();
      if (roomId != null) _roomIdController.sink.add(roomId);
    } catch (e) {
      _roomIdController.sink.addError(e);
    }
  }

  void dispose() {
    _messageListController?.close();
    _roomIdController?.close();
  }
}
