import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/*----------------------------------------------
プロフィールエンティティクラス
----------------------------------------------*/

class User {
  String mail = ""; //primarykey
  String name = "";
  String age = "";
  String sex = "";
  String rank = "";
  String lineId = "";
  String score = "";
  Map event;

  Map<int, String> rankMap = {5: "青", 10: "黄", 20: "緑", 40: "紫", 80: "赤", 160: "銅", 320: "銀", 480: "金"};

  Map<String, Color> colorMap = {
    "青": Colors.blue,
    "黄": Colors.yellow,
    "緑": Colors.green,
    "紫": Colors.purple,
    "赤": Colors.red,
    "銅": Color(0xffb87333),
    "銀": Color(0xffa0a0a0),
    "金": Color(0xffffd700),
  };

  User();

  User.fromMap(Map map)
      : name = map["name"],
        age = map["age"],
        sex = map["sex"],
        rank = map["rank"],
        mail = map["mail"],
        lineId = map["lineId"],
        score = map["score"];

  toJson() {
    print("\n-----------send Data-----------\n"
        "name:$name\n"
        "age:$age\n"
        "sex:$sex\n"
        "rank:$rank\n"
        "mail:$mail\n"
        "lineId:$lineId\n"
        "score:$score\n"
        "-------------------------------\n");
    return {
      "name": name,
      "age": age,
      "sex": sex,
      "rank": rank,
      "mail": mail,
      "lineId": lineId,
      "score": score,
    };
  }
}

/*----------------------------------------------
scoreエンティティ
----------------------------------------------*/
class Score {
  String date; //primaryKey
  String first;
  String second;
  String third;
  String fourth;
  String balance;
  String total;
}

/*----------------------------------------------
部品クラス
----------------------------------------------*/
class PageParts {
  //案1
  var baseColor = Color(0xff160840);
  var backGroundColor = Color(0xff00152d);
  var fontColor = Color(0xff00A968);
  var pointColor = Colors.white;

  ThemeData defaultTheme = ThemeData(
    backgroundColor: Color(0xff00152d),
    scaffoldBackgroundColor: Color(0xff00152d),
    bottomAppBarColor: Color(0xff160840),
    selectedRowColor: Color(0xff00A968),
    dividerColor: Colors.white,
  );

  ThemeData light = new ThemeData.light();

  ThemeData dark = new ThemeData.dark();

  Widget indicator() {
    return SpinKitWave(
      color: pointColor,
      size: 50.0,
    );
  }

  Widget backButton({Function() onTap}) {
    return RaisedButton.icon(
      label: Text("戻る"),
      icon: Icon(
        Icons.arrow_back_ios,
        color: fontColor,
      ),
      onPressed: onTap != null
          ? () => onTap()
          : () {
              print('Not set');
            },
    );
  }
}

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

/*----------------------------------------------

都道府県エンティティクラス

----------------------------------------------*/
class Pref {
  int prefCode;
  String prefName;
  static Map<String, String> pref = {
    "北海道": "1",
    "青森県": "2",
    "岩手県": "3",
    "宮城県": "4",
    "秋田県": "5",
    "山形県": "6",
    "福島県": "7",
    "茨城県": "8",
    "栃木県": "9",
    "群馬県": "10",
    "埼玉県": "11",
    "千葉県": "12",
    "東京都": "13",
    "神奈川県": "14",
    "新潟県": "15",
    "富山県": "16",
    "石川県": "17",
    "福井県": "18",
    "山梨県": "19",
    "長野県": "20",
    "岐阜県": "21",
    "静岡県": "22",
    "愛知県": "23",
    "三重県": "24",
    "滋賀県": "25",
    "京都府": "26",
    "大阪府": "27",
    "兵庫県": "28",
    "奈良県": "29",
    "和歌山県": "30",
    "鳥取県": "31",
    "島根県": "32",
    "岡山県": "33",
    "広島県": "34",
    "山口県": "35",
    "徳島県": "36",
    "香川県": "37",
    "愛媛県": "38",
    "高知県": "39",
    "福岡県": "40",
    "佐賀県": "41",
    "長崎県": "42",
    "熊本県": "43",
    "大分県": "44",
    "宮崎県": "45",
    "鹿児島県": "46",
    "沖縄県": "47"
  };
  Map<String, int> lineMap = new Map();
  Pref(this.prefCode, this.prefName);
}

/*----------------------------------------------

路線エンティティクラス

----------------------------------------------*/
class Line {
  int lineCode;
  String lineName;
  Station station;
  static Map<String, int> stationMap;
  Line();

  Map<String, dynamic> toJson() => {'line_name': lineName, 'line_cd': lineCode};
}

/*----------------------------------------------

駅エンティティクラス

----------------------------------------------*/
class Station {
  int stationCode;
  String stationName;

  Station({this.stationCode, this.stationName});

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(stationCode: json['station_cd'] as int, stationName: json['station_name'] as String);
  }
  Map<String, dynamic> toJson() => {'station_name': stationName, 'station_cd': stationCode};
}

/*----------------------------------------------

駅エンティティクラス

----------------------------------------------*/
class ChatEntity {
  String key;
  DateTime dateTime;
  String message;
  String fromUserId;

  ChatEntity(this.dateTime, this.message);

  ChatEntity.fromSnapShot(DataSnapshot snapshot)
      : key = snapshot.key,
        dateTime = new DateTime.fromMillisecondsSinceEpoch(snapshot.value["date"]),
        message = snapshot.value["message"],
        fromUserId = snapshot.value["fromUserId"];

  toJson() {
    return {
      "date": dateTime.millisecondsSinceEpoch,
      "message": message,
      "fromUserId": fromUserId,
    };
  }
}
