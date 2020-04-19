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

  //メッセージ送信用Stream
  final _sendMessageController = StreamController<Talk>();
  Sink<Talk> get sendMessageSink => _sendMessageController.sink;

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
    repository.realtimeMessageStream.listen((message) {
      _messageListController.add(message);
    });

    //メッセージ送信
    _sendMessageController.stream.listen((talk) async {
      print("repository:sended");
      repository.sendMessage(this.roomId, talk);
    });
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
    _sendMessageController?.close();
    _messageListController?.close();
    _roomIdController?.close();
  }
}
