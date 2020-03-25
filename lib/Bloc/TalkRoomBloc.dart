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

  final _eventListController = BehaviorSubject<List<TalkRoom>>.seeded([]);
  Stream<List<TalkRoom>> get eventListStream => _eventListController.stream;

  TalkRoomBloc(this.user) {
    this.repository = TalkRoomRepository(user);
    repository.eventStream.listen((roomList) {
      _eventListController.add(roomList);
    });
  }

  void dispose() {
    _eventListController.close();
  }
}
