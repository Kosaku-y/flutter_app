import 'dart:async';
import 'package:flutter_app2/Entity/EventDetail.dart';
import 'package:flutter_app2/Repository/EventRepository.dart';

/*----------------------------------------------

イベント管理Blocクラス

----------------------------------------------*/
class EventManageBloc {
  //イベント作成ページへ路線Map<name,code>を返すStream
  final StreamController _lineMapController = StreamController<Map<String, String>>();
  Stream<Map<String, String>> get lineMapStream => _lineMapController.stream;

  //イベント作成ページへ駅Map<name,code>を返すStream
  final StreamController _stationMapController = StreamController<Map<String, String>>();
  Stream<Map<String, String>> get stationMapStream => _stationMapController.stream;

  //新規EventDetail作成結果を流すStream
  final StreamController _newEventController = StreamController<bool>();
  Stream<bool> get newEventStream => _newEventController.stream;

  final EventRepository _repository = EventRepository();

  EventManageBloc();

  //県名から路線のMapを取得
  callLineApi(String prefCode) async {
    try {
      Map<String, String> lineMap = await _repository.createLineMap(prefCode);
      _lineMapController.add(lineMap);
    } catch (e) {
      _lineMapController.addError(e);
    }
  }

  //路線コードから駅のMapを取得
  callStationApi(String lineCode) async {
    try {
      Map<String, String> stationMap = await _repository.createStationMap(lineCode);
      _stationMapController.add(stationMap);
    } catch (e) {
      _stationMapController.addError(e);
    }
  }

  //イベント作成
  callCreateEvent(String stationCode, EventDetail event) async {
    try {
      _newEventController.add(_repository.createEvent(stationCode, event));
    } catch (e) {
      _newEventController.addError(e);
    }
  }

  void dispose() {
    _lineMapController.close();
    _stationMapController.close();
    _newEventController.close();
  }
}
