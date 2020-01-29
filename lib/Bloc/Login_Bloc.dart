import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_app2/Repository/Login_Repository.dart';
import 'package:flutter_app2/Entity/AuthStatus.dart';

class LoginBloc {
  final _googleLoginController = StreamController();
  final _currentStatusController = StreamController();
  final _loginState = BehaviorSubject<AuthStatus>.seeded(AuthStatus.notSignedIn);
  //初期値を設けたい場合はBehaviourSubject
  final loginRepository = LoginRepository();

  LoginBloc() {
    //Googleログインが必要な時にコールされる
    _googleLoginController.stream.listen((onData) async {
      try {
        var currentUser = await loginRepository.signInWithGoogle();
        if (currentUser != null) {
          AuthStatus currentStatus = await loginRepository.checkFireBaseLogin(currentUser);
          _loginState.add(currentStatus);
        } else {
          _loginState.add(AuthStatus.notSignedIn);
        }
      } catch (_) {}
    });
    //現在のステータス確認,毎回コールされる
    _currentStatusController.stream.listen((status) async {
      try {
        var currentUser = await loginRepository.isSignedIn();
        if (currentUser != null) {
          AuthStatus currentStatus = await loginRepository.checkFireBaseLogin(currentUser);
          _loginState.add(currentStatus);
        } else {
          _loginState.add(AuthStatus.notSignedIn);
        }
      } catch (_) {}
    });
  }

  Sink get googleLoginSink => _googleLoginController.sink;
  Sink get currentStatusSink => _currentStatusController.sink;

  ValueObservable<AuthStatus> get loginStateStream => _loginState.stream;
  Stream<AuthStatus> get currentStatusStream => _currentStatusController.stream;

  void dispose() {
    _googleLoginController.close();
    _currentStatusController.close();
  }
}
