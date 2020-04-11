import 'dart:async';
import 'package:flutter_app2/Repository/EventRepository.dart';

/*----------------------------------------------

イベント管理Blocクラス

----------------------------------------------*/
class EventManageBloc {
  //イベント作成ページからpicker作成のためのprefCodeを受け取るStream
  final StreamController _lineApiController = StreamController<String>();
  Sink get lineApiSink => _lineApiController.sink;

  //イベント作成ページへ路線Map<name,code>を返すStream
  final StreamController _lineMapController = StreamController<Map<String, String>>();
  Stream<Map<String, String>> get lineMapStream => _lineMapController.stream;

  //イベント作成ページからpicker作成のためのlineCodeを受け取るStream
  final StreamController _stationApiController = StreamController<String>();
  Sink get stationApiSink => _stationApiController.sink;

  //イベント作成ページへ駅Map<name,code>を返すStream
  final StreamController _stationMapController = StreamController<Map<String, String>>();
  Stream<Map<String, String>> get stationMapStream => _stationMapController.stream;

  final EventRepository _repository = EventRepository();

  EventManageBloc() {
    _lineApiController.stream.listen((prefCode) async {
      Map<String, String> lineMap = await _repository.createLineMap(prefCode);
      _lineMapController.add(lineMap);
    });

    _stationApiController.stream.listen((lineCode) async {
      Map<String, String> stationMap = await _repository.createStationMap(lineCode);
      _stationMapController.add(stationMap);
    });
  }

  void dispose() {
    _lineApiController.close();
    _lineMapController.close();
    _stationApiController.close();
    _stationMapController.close();
  }
}
