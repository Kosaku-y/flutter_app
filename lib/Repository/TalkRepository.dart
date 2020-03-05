import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app2/Entity/User.dart';

/*----------------------------------------------

トーク用レポジトリクラス

----------------------------------------------*/
class TalkRepository {
  User user;

  // fireBaseから取得をしたデータのストリームを外部に公開するための Stream
  final StreamController<String> _eventRealTimeStream = StreamController();
  Stream<String> get eventStream => _eventRealTimeStream.stream;

  final _userReference = FirebaseDatabase.instance.reference().child("User");

  TalkRepository(this.user) {
    try {
      _userReference.child("${user.userId}/message/").onChildAdded.listen((e) {
        _eventRealTimeStream.add(e.snapshot.key);
      });
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
    }
  }
}
