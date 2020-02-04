//ログイン状態Enum
class TempUser {
  /*
  * ログイン状態は以下の3通り
  * 1.未登録　　　　　：signedUp    -> 認証後、登録ページへ
  * 2.ログアウト状態　：notSignedIn -> 認証へ
  * 3.ログイン状態　　：signIn      -> マイページへ
  */
  AuthStatus status = AuthStatus.notSignedIn;

  String userID;
  String get getUserID => this.userID;

  TempUser({AuthStatus status, String userId})
      : this.userID = userId,
        this.status = status;
}

enum AuthStatus { notSignedIn, signedUp, signedIn }
