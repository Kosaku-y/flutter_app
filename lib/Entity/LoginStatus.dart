/*----------------------------------------------
認証状態enum
notSignedIn：未ログイン
signedUp：要登録
signedIn：ログイン済み
----------------------------------------------*/
import 'User.dart';

enum Status { notSignIn, signUp, signIn }

class LoginResult {
  final Status status;
  final User user;

  LoginResult.signIn(this.user) : status = Status.signIn;
  LoginResult.signUp(this.user) : status = Status.signUp;
  LoginResult.notSignIn()
      : this.user = null,
        status = Status.notSignIn;
}

enum AuthProvider { Google, Apple }
