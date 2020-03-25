import 'dart:async';
import 'package:flutter_app2/Entity/Talk.dart';
import 'package:flutter_app2/Repository/TalkRepository.dart';
import 'package:rxdart/rxdart.dart';

/*----------------------------------------------

トークBlocクラス

----------------------------------------------*/
class TalkBloc {
  String roomId;
  TalkRepository repository;

  final _messageListController = BehaviorSubject<List<Talk>>.seeded([]);
  Stream<List<Talk>> get eventListStream => _messageListController.stream;
  //List<String> messageList = new List();

  final _sendMessageController = StreamController<Talk>();
  Sink<Talk> get sendMessageSink => _sendMessageController.sink;

  final _roomIdController = StreamController<String>();
  Stream<String> get roomIdStream => _roomIdController.stream;

  TalkBloc(this.roomId) {
    this.repository = TalkRepository(roomId);
    repository.eventStream.listen((message) {
      //messageList.add(Talk.fromSnapShot(message.data));
      _messageListController.add(message);
    });

    _sendMessageController.stream.listen((talk) async {
      repository.sendMessage(this.roomId, talk);
    });

//    _roomIdController.stream.listen((talk) async {
//      repository.
//    });
  }

  void dispose() {
    _sendMessageController.close();
    _messageListController.close();
    _roomIdController.close();
  }
}
