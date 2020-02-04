import 'package:flutter/material.dart';
import 'AuthStatus.dart';

class User extends TempUser {
  String _userId = "";

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  } //primarykey

  String _name = "";
  String _age = "";
  String _sex = "";
  String _rank = "";
  String _lineId = "";
  String _score = "";
  Map _event;

  Map<int, String> rankMap = {
    5: "青",
    10: "黄",
    20: "緑",
    40: "紫",
    80: "赤",
    160: "銅",
    320: "銀",
    480: "金"
  };

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

  User.newUser(TempUser tempUser) : _userId = tempUser.userID;

  User.fromMap(Map map)
      : _name = map["name"],
        _age = map["age"],
        _sex = map["sex"],
        _rank = map["rank"],
        _userId = map["mail"],
        _lineId = map["lineId"],
        _score = map["score"];

  toJson() {
    print("\n-----------send Data-----------\n"
        "name:$name\n"
        "age:$age\n"
        "sex:$sex\n"
        "rank:$rank\n"
        "mail:$userId\n"
        "lineId:$lineId\n"
        "score:$score\n"
        "-------------------------------\n");
    return {
      "name": name,
      "age": age,
      "sex": sex,
      "rank": rank,
      "mail": userId,
      "lineId": lineId,
      "score": score,
    };
  }

  String get name => _name;
  set name(String value) {
    _name = value;
  }

  Map get event => _event;
  set event(Map value) {
    _event = value;
  }

  String get score => _score;
  set score(String value) {
    _score = value;
  }

  String get lineId => _lineId;
  set lineId(String value) {
    _lineId = value;
  }

  String get rank => _rank;
  set rank(String value) {
    _rank = value;
  }

  String get sex => _sex;
  set sex(String value) {
    _sex = value;
  }

  String get age => _age;
  set age(String value) {
    _age = value;
  }
}
