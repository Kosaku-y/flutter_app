import 'dart:async';
import 'package:flutter_app2/Entity/EventDetail.dart';
import 'package:flutter_app2/Entity/EventSearch.dart';
import 'package:flutter_app2/Repository/EventRepository.dart';
import 'package:flutter_app2/Widget/EventSerchResultPage.dart';

class EventSearchBloc {
  //イベント作成ページから要素を受け取るStream
  final StreamController<EventDetail> _eventCreateController = StreamController();

  //イベント検索ページから要素を受け取るStream
  final StreamController _eventSearchController = StreamController<EventSearch>();
  Sink get eventSearchSink => _eventSearchController.sink;
  //イベント検索ページに要素を流すStream
  final StreamController _searchResultController = StreamController<List<EventDetail>>();
  Stream<List<EventDetail>> get searchResultStream => _searchResultController.stream;

  final EventRepository repository = EventRepository();

  EventSearchBloc({EventSearch eventSearch}) {
    _eventSearchController.stream.listen((eventSearch) async {
      List<EventDetail> eventList = await repository.searchEvent(eventSearch);
      _searchResultController.sink.add(eventList);
    });
    _eventCreateController.stream.listen((onData) async {});
  }

  void dispose() {
    _eventCreateController.close();
    _eventSearchController.close();
    _searchResultController.close();
  }
}
