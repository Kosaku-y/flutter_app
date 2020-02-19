/*----------------------------------------------
イベントのエンティティクラス
  eventId         イベントID
  userId          ユーザーID
  recruitMember   募集人数
  station         最寄駅
  startingTime    開始時間
  endingTime      終了時間
  remarks         備考
----------------------------------------------*/
class EventDetail {
  String eventId;
  String recruitMember;
  String station;
  String startingTime;
  String endingTime;
  String comment;
  String userId;
  String name;

  EventDetail(this.recruitMember, this.station, this.startingTime, this.endingTime, this.comment);

  EventDetail.fromMap(Map map)
      : userId = map["userId"],
        eventId = map["eventId"],
        recruitMember = map["recruitMember"],
        station = map["station"],
//        startingTime =
//            new DateTime.fromMillisecondsSinceEpoch(map["startingTime"]),
//        endingTime = new DateTime.fromMillisecondsSinceEpoch(map["endingTime"]),
        startingTime = map["startingTime"],
        endingTime = map["endingTime"],
        comment = map["comment"];

  //json化,ログ出力メソッド
  toJson() {
    print("\n-----------send Data-----------\n"
        "eventId:$eventId\n"
        "userId:$userId\n"
        "member:$recruitMember\n"
        "station:$station\n"
        "start:$startingTime\n"
        "end:$endingTime\n"
        "comment:$comment\n"
        "-------------------------------\n");
    return {
      "eventId": eventId,
      "userId": "xxxlancerk@gmail.com",
      "recruitMember": recruitMember,
      "station": station,
      "startingTime": startingTime,
      "endingTime": endingTime,
      "comment": comment,
    };
  }
}
