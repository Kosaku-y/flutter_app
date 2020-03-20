/*----------------------------------------------
イベントのエンティティクラス
  eventId         イベントID
  userId          ユーザーID
  recruitMember   募集人数
  pref            都道府県
  line            路線
  station         最寄駅
  startingTime    開始時間
  endingTime      終了時間
  comment         コメント
----------------------------------------------*/
class EventDetail {
  String eventId;
  String recruitMember;
  String pref;
  String line;
  String station;
  String startingTime;
  String endingTime;
  String comment;
  String userId;
  String userName;

  EventDetail(this.recruitMember, this.line, this.station, this.startingTime, this.endingTime,
      this.comment, this.userId, this.userName);

  EventDetail.fromMap(Map map)
      : eventId = map["eventId"],
        recruitMember = map["recruitMember"],
        pref = map["prefName"],
        line = map["lineName"],
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
