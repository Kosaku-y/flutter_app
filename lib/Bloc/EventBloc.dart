import 'dart:async';
import 'package:flutter_app2/Entity/EventDetail.dart';
import 'package:flutter_app2/Repository/EventRepository.dart';

class EventBloc {
  //イベント作成ページから要素を受け取るStream
  final StreamController<EventDetail> _eventCreateController = StreamController();
  //イベント検索ページから要素を受け取るStream
  final StreamController _eventSearchController = StreamController();

  final StreamController<List<EventDetail>> _eventListContlloer = StreamController();

  final EventRepository repository = EventRepository();
  EventBloc() {
    _eventCreateController.stream.listen((onData) async {});

    _eventSearchController.stream.listen((onData) async {});
  }
}
