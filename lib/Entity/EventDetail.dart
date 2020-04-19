/*----------------------------------------------

イベントのEntityクラス

----------------------------------------------*/
class EventDetail {
  String eventId; //イベントID
  String recruitMember; //募集人数
  String pref; //都道府県
  String line; //路線名
  String station; //駅名
  String startingTime; //開始時間
  String endingTime; //終了時間
  String comment; //コメント
  String userId; //ユーザーID
  String userName; //ユーザー名

  EventDetail(this.recruitMember, this.line, this.station, this.startingTime, this.endingTime,
      this.comment, this.userId, this.userName);

  EventDetail.fromMap(Map map)
      : eventId = map["eventId"],
        recruitMember = map["recruitMember"],
        pref = map["pref"],
        line = map["line"],
        station = map["station"],
        startingTime = map["startingTime"],
        endingTime = map["endingTime"],
        comment = map["comment"],
        userId = map["userId"],
        userName = map["userName"];

  //json化,ログ出力メソッド
  toJson() {
    print("\n-----------send Data-----------\n"
        "eventId:$eventId\n"
        "member:$recruitMember\n"
        "prefecture:$pref\n"
        "line:$line\n"
        "station:$station\n"
        "start:$startingTime\n"
        "end:$endingTime\n"
        "comment:$comment\n"
        "userId:$userId\n"
        "userName:$userName\n"
        "-------------------------------\n");
    return {
      "eventId": eventId,
      "recruitMember": recruitMember,
      "pref": pref,
      "line": line,
      "station": station,
      "startingTime": startingTime,
      "endingTime": endingTime,
      "comment": comment,
      "userId": userId,
      "userName": userName
    };
  }
}
