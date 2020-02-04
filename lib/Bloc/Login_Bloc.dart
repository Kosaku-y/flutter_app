import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_app2/Repository/Login_Repository.dart';
import 'package:flutter_app2/Entity/AuthStatus.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginBloc {
  //final _currentTempUserController = PublishSubject<TempUser>();
  final _currentTempUserController = BehaviorSubject<TempUser>.seeded(null);

  //loginPage側で現在のTmpUserを流す用のStream

  final _googleLoginController = StreamController();
  //loginRepositoryからGoogleログイン受け取るためのStream
  final _stateController = StreamController();
  //loginRepositoryからfireBase上のログイン結果を受け取るためのStream

  final loginRepository = LoginRepository();

  LoginBloc() {
    //現在のステータス確認,毎回コールされる
    _stateController.stream.listen((onData) async {
      try {
        var currentUser = await loginRepository.isSignedIn();
        if (currentUser != null) {
          var tempUser = await loginRepository.checkFireBaseLogin(currentUser);
          _currentTempUserController.add(tempUser);
          print("firebaseログイン完了:bloc");
        } else {
          print("firebaseログイン失敗:bloc");
        }
      } catch (_) {}
    });

    //Googleログインが必要な時にコールされる
    _googleLoginController.stream.listen((onData) async {
      try {
        var fireBaseUser = await loginRepository.signInWithGoogle();
        if (fireBaseUser != null) {
          TempUser tempUser = await loginRepository.checkFireBaseLogin(fireBaseUser);
          _currentTempUserController.add(tempUser);
          print("ログイン完了:bloc");
        } else {
          print("googleログイン失敗:bloc");
        }
      } catch (_) {}
    });
  }

  Sink get googleLoginSink => _googleLoginController.sink;
  Sink get stateSink => _stateController.sink;

  ValueObservable<TempUser> get currentTempUserStream => _currentTempUserController.stream;
  Stream get googleLoginStream => _googleLoginController.stream;

  void dispose() {
    _stateController.close();
    _googleLoginController.close();
    _currentTempUserController.close();
  }
}
