class ApiCallError extends StateError {
  ApiCallError() : super("API通信時のエラーが発生しました。");
}

class FirebaseError extends StateError {
  FirebaseError() : super("データ更新・取得エラーが発生しました。");
}
