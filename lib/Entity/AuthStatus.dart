////ログイン状態Enum
//class TempUser {
//  /*
//  * ログイン状態は以下の3通り
//  * 1.未登録　　　　　：signedUp    -> 認証後、登録ページへ
//  * 2.ログアウト状態　：notSignedIn -> 認証へ
//  * 3.ログイン状態　　：signIn      -> マイページへ
//  */
//
//  AuthStatus _status = AuthStatus.notSignedIn;
//  AuthStatus get status => _status;
//  set status(AuthStatus value) => _status = value;
//
//  String _userID;
//  String get getUserID => this._userID;
//
//  TempUser({AuthStatus status, String userId})
//      : this._userID = userId,
//        this._status = status;
//}
//
enum AuthStatus { notSignedIn, signedUp, signedIn }
