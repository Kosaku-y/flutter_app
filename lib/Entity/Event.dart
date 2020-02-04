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
class EventEntity {
  String eventId;
  String recruitMember;
  String station;
  String startingTime;
  String endingTime;
  String remarks;
  String userId;
  String name;

  EventEntity(this.recruitMember, this.station, this.startingTime, this.endingTime, this.remarks);

  EventEntity.fromMap(Map map)
      : userId = map["userId"],
        eventId = map["eventId"],
        recruitMember = map["recruitMember"],
        station = map["station"],
//        startingTime =
//            new DateTime.fromMillisecondsSinceEpoch(map["startingTime"]),
//        endingTime = new DateTime.fromMillisecondsSinceEpoch(map["endingTime"]),
        startingTime = map["startingTime"],
        endingTime = map["endingTime"],
        remarks = map["remarks"];

  //json化,ログ出力メソッド
  toJson() {
    print("\n-----------send Data-----------\n"
        "eventId:$eventId\n"
        "userId:$userId\n"
        "member:$recruitMember\n"
        "station:$station\n"
        "start:$startingTime\n"
        "end:$endingTime\n"
        "remarks:$remarks\n"
        "-------------------------------\n");
    return {
      "eventId": eventId,
      "userId": "xxxlancerk@gmail.com",
      "recruitMember": recruitMember,
      "station": station,
      "startingTime": startingTime,
      "endingTime": endingTime,
      "remarks": remarks,
    };
  }
}
