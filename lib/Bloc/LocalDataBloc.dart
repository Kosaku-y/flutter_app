import 'dart:async';
import 'package:flutter_app2/Entity/Score.dart';
import 'package:flutter_app2/Repository/LocalDataRepository.dart';
import 'package:rxdart/rxdart.dart';

/*----------------------------------------------

ローカルデータBlocクラス

----------------------------------------------*/
class LocalDataBloc {
  //ページからcallサインを受け取るStream
  final StreamController _callSignController = StreamController();
  Sink get callMapSink => _callSignController.sink;
  //ページMap<DateTime,dynamic>を返すStream
  final _scoreMapController = BehaviorSubject<Map<String, List<Score>>>();
  Stream<Map<String, List<Score>>> get scoreMapStream => _scoreMapController.stream;

  final LocalDataRepository repository = LocalDataRepository();

  LocalDataBloc() {
    _callSignController.stream.listen((event) async {
      var map = await repository.getScore();
      _scoreMapController.add(map);
    });
  }

  void dispose() {
    _callSignController.close();
    _scoreMapController.close();
  }
}
