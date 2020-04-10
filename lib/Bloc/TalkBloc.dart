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

  //roomIDのget通知を受け取るstream
  final _prepareRoomController = StreamController<String>();
  Sink<String> get prepareRoom => _prepareRoomController.sink;

  //リンクからの遷移
  TalkBloc.newRoom(User user, String toUserId, String toUserName) {
    this.repository = TalkRepository.forNewRoom(user, toUserId, toUserName);
    String roomId;
    _prepareRoomController.stream.listen((event) async {
      roomId = await repository.prepareRoomId();
      if (roomId != null) _roomIdController.sink.add(roomId);
    });
  }

  //履歴からの遷移
  TalkBloc(this.roomId) {
    this.repository = TalkRepository(roomId);

    repository.realtimeMessageStream.listen((message) {
      //messageList.add(Talk.fromSnapShot(message.data));
      _messageListController.add(message);
    });
    //メッセージ送信
    _sendMessageController.stream.listen((talk) async {
      print("repository:sended");
      repository.sendMessage(this.roomId, talk);
    });
  }

  void dispose() {
    _sendMessageController?.close();
    _messageListController?.close();
    _roomIdController?.close();
    _prepareRoomController?.close();
  }
}
