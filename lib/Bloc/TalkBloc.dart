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

  //メッセージ受信用Stream
  final _messageListController = BehaviorSubject<List<Talk>>.seeded([]);
  Stream<List<Talk>> get messageListStream => _messageListController.stream;
  //List<String> messageList = new List();

  //メッセージ送信用Stream
  final _sendMessageController = StreamController<Talk>();
  Sink<Talk> get sendMessageSink => _sendMessageController.sink;

  //roomId
  final _roomIdController = StreamController<String>();
  Stream<String> get roomIdStream => _roomIdController.stream;

  //roomIdを用意して流すStream
  final _prepareRoomController = StreamController<String>();
  Stream<String> get prepareRoomIdStream => _prepareRoomController.stream;

  TalkBloc.newRoom(User user, String toUserId, String toUserName) {
    this.repository = TalkRepository.forNewRoom(user, toUserId, toUserName);
    _prepareRoomController.stream.listen((event) {
      repository.prepareRoomId();
    });
  }

  TalkBloc(this.roomId) {
    this.repository = TalkRepository(roomId);
    repository.eventStream.listen((message) {
      //messageList.add(Talk.fromSnapShot(message.data));
      _messageListController.add(message);
    });

    _sendMessageController.stream.listen((talk) async {
      repository.sendMessage(this.roomId, talk);
    });
  }

  void dispose() {
    _sendMessageController.close();
    _messageListController.close();
    _roomIdController.close();
    _prepareRoomController.close();
  }
}
