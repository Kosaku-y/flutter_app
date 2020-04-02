import 'dart:async';
import 'package:flutter_app2/Entity/TalkRoom.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:flutter_app2/Repository/TalkRoomRepository.dart';
import 'package:rxdart/rxdart.dart';

/*----------------------------------------------

トークルームBlocクラス

----------------------------------------------*/
class TalkRoomBloc {
  User user;
  TalkRoomRepository repository;

  //トークルーム画面にリストを流すStream
  final _talkRoomListController = BehaviorSubject<List<TalkRoom>>.seeded([]);
  Stream<List<TalkRoom>> get talkRoomListStream => _talkRoomListController.stream;

  //トーク画面に対して新しいroomIdを取得するStream
  TalkRoomBloc(this.user) {
    this.repository = TalkRoomRepository(user);
    repository.eventStream.listen((roomList) {
      _talkRoomListController.add(roomList);
    });
  }

  void dispose() {
    _talkRoomListController.close();
  }
}
