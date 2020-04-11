import 'dart:async';
import 'package:flutter_app2/Entity/User.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_app2/Repository/LoginRepository.dart';

/*----------------------------------------------

ログインBlocクラス

----------------------------------------------*/
class LoginBloc {
  final _currentTempUserController = BehaviorSubject<User>.seeded(null);
  //loginPage側で現在のTmpUserを流す用のStream
  final _googleLoginController = StreamController();
  //loginRepositoryからGoogleログイン受け取るためのStream
  final _stateController = StreamController();

  final repository = LoginRepository();

  LoginBloc() {
    //現在のステータス確認,毎回コールされる
    _stateController.stream.listen((onData) async {
      try {
        var currentUser = await repository.isSignedIn();
        if (currentUser != null) {
          var user = await repository.checkFireBaseLogin(currentUser);
          _currentTempUserController.add(user);
          print("firebaseログイン完了:bloc");
        } else {
          print("firebaseログイン失敗:bloc");
        }
      } catch (_) {}
    });

    //Googleログインが必要な時にコールされる
    _googleLoginController.stream.listen((onData) async {
      try {
        await repository.signOut();
        var fireBaseUser = await repository.signInWithGoogle();
        if (fireBaseUser != null) {
          var user = await repository.checkFireBaseLogin(fireBaseUser);
          _currentTempUserController.add(user);
          print("googleログイン完了:bloc");
        } else {
          print("googleログイン失敗:bloc");
        }
      } catch (_) {}
    });
  }

  Sink get googleLoginSink => _googleLoginController.sink;
  Sink get stateSink => _stateController.sink;

  ValueObservable<User> get currentTempUserStream => _currentTempUserController.stream;
  Stream get googleLoginStream => _googleLoginController.stream;

  void dispose() {
    _stateController.close();
    _googleLoginController.close();
    _currentTempUserController.close();
  }
}
