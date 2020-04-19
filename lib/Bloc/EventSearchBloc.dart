import 'dart:async';
import 'package:flutter_app2/Entity/EventDetail.dart';
import 'package:flutter_app2/Entity/EventSearch.dart';
import 'package:flutter_app2/Repository/EventRepository.dart';

/*----------------------------------------------

イベント検索Blocクラス

----------------------------------------------*/
class EventSearchBloc {
  //イベント検索ページに要素を流すStream
  final _searchResultController = StreamController<List<EventDetail>>();
  Stream<List<EventDetail>> get searchResultStream => _searchResultController.stream;

  EventSearchBloc();

  fetchResult(EventSearch search) async {
    final EventRepository repository = EventRepository();
    try {
      List<EventDetail> result = await repository.searchEvent(search);
      _searchResultController.sink.add(result);
    } catch (e) {
      _searchResultController.sink.addError(e);
    }
  }

  void dispose() {
    _searchResultController.close();
  }
}
