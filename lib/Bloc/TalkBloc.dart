import 'dart:async';
import 'package:flutter_app2/Entity/User.dart';
import 'package:flutter_app2/Repository/TalkRepository.dart';
import 'package:rxdart/rxdart.dart';

/*----------------------------------------------

トークBlocクラス

----------------------------------------------*/
class TalkBloc {
  User user;
  TalkRepository repository;

  final _eventListController = BehaviorSubject<List<String>>.seeded([]);
  Stream<List<String>> get eventListStream => _eventListController.stream;
  List<String> rooms = new List();

  TalkBloc(this.user) {
    this.repository = TalkRepository(user);
    repository.eventStream.listen((room) {
      rooms.add(room);
      _eventListController.add(rooms);
    });
  }

  void dispose() {
    _eventListController.close();
  }
}
