import 'dart:async';
import 'package:flutter_app2/Entity/EventDetail.dart';
import 'package:flutter_app2/Entity/EventSearch.dart';
import 'package:flutter_app2/Repository/EventRepository.dart';
import 'package:rxdart/rxdart.dart';

/*----------------------------------------------

イベント検索Blocクラス

----------------------------------------------*/
class EventSearchBloc {
  //イベント検索ページから要素を受け取るStream
  final StreamController _eventSearchController = StreamController<EventSearch>();
  Sink get eventSearchSink => _eventSearchController.sink;
  //イベント検索ページに要素を流すStream
  final _searchResultController = BehaviorSubject<List<EventDetail>>.seeded(null);
  Stream<List<EventDetail>> get searchResultStream => _searchResultController.stream;

  final EventRepository repository = EventRepository();

  EventSearchBloc() {
    _eventSearchController.stream.listen((event) async {
      List<EventDetail> eventList = await repository.searchEvent(event);
      _searchResultController.sink.add(eventList);
    });
  }

  void dispose() {
    _eventSearchController.close();
    _searchResultController.close();
  }
}
