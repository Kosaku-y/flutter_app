import 'dart:async';
import 'package:flutter_app2/Entity/User.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_app2/Repository/LoginRepository.dart';

/*----------------------------------------------

ログインBlocクラス

----------------------------------------------*/
class LoginBloc {
  // Googleログインの結果を流すStream
  final _googleLoginController = StreamController();

  // 現在の状態を流すStream
  final _currentTempUserController = BehaviorSubject<User>.seeded(null);
  get currentTempUserStream => _currentTempUserController.stream;

  final LoginRepository _repository = LoginRepository();

  LoginBloc();

  // Googleログイン手続き
  callGoogleLogin() async {
    try {
      await _repository.signOut();
      var fireBaseUser = await _repository.signInWithGoogle();
      if (fireBaseUser != null) {
        var user = await _repository.checkFireBaseLogin(fireBaseUser);
        _currentTempUserController.add(user);
        print("googleログイン完了:bloc");
      } else {
        print("googleログイン失敗:bloc");
      }
    } catch (e) {
      _currentTempUserController.addError(e);
    }
  }

  // 現在のステータス
  callCurrentStatus() async {
    try {
      var currentUser = await _repository.isSignedIn();
      if (currentUser != null) {
        var user = await _repository.checkFireBaseLogin(currentUser);
        _currentTempUserController.add(user);
        print("firebaseログイン完了:bloc");
      } else {
        print("firebaseログイン失敗:bloc");
      }
    } catch (e) {
      _currentTempUserController.addError(e);
    }
  }

  void dispose() {
    _googleLoginController.close();
    _currentTempUserController.close();
  }
}
