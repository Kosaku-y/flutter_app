//ログイン状態Enum
enum AuthStatus {
  /*
  * ログイン状態は以下の3通り
  * 1.未登録　　　　　：signedUp    -> 認証後、登録ページへ
  * 2.ログアウト状態　：notSignedIn -> 認証へ
  * 3.ログイン状態　　：signIn      -> マイページへ
  */
  notSignedIn,
  signedIn,
  signedUp
}
