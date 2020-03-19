import 'package:flutter_app2/Entity/PageParts.dart';
import 'package:flutter_app2/Entity/Score.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/date_symbol_data_local.dart';

/*----------------------------------------------

ローカルデータリポジトリクラス

----------------------------------------------*/
/*
* Map<String dateKey,List<Score>>
-scoreKey:{
-”2019/11/07”:{
            [{'ranking':1,
            'chip':23,
            'total':201,
            'rate':5,
            'balance':12400}]}
-”2019/11/09”:{
            {{'ranking':1,
            'chip':23,
            total':201,
            'rate':5,
            'balance':12400},
            {'ranking':1,
            'chip':23,
            total':201,
            'rate':5,
            'balance':12400}}
* */
class LocalDataRepository {
  final String scoreKey = "scoreKey";
  PageParts set = PageParts();
  SharedPreferences prefs;

  var formatter;

  LocalDataRepository() {
    Intl.defaultLocale = 'ja_JP';
    initializeDateFormatting('ja_JP');
    formatter = DateFormat(DateFormat.YEAR_MONTH_WEEKDAY_DAY);
  }

//  Future<Map<DateTime, dynamic>> getScore() async {
//    prefs = await SharedPreferences.getInstance();
//    var resource = prefs.getString(scoreKey);
//    if (resource == null) return null;
//    Map<String, dynamic> tmpMap = json.decode(resource);
//    // string to List<User>
//    var scoreMap = Map<DateTime, List<Score>>();
//    tmpMap.forEach((key, value) {
//      scoreMap[formatter.parse(key)] = List<Score>();
//      value.forEach((i) {
//        scoreMap[formatter.parse(key)].add(Score.fromJson(i));
//      });
//    });
//    print("get$scoreMap");
//    return scoreMap;
//  }
  Future<Map<String, List<Score>>> getScore() async {
    prefs = await SharedPreferences.getInstance();
    var resource = prefs.getString(scoreKey);
    var scoreMap = Map<String, List<Score>>();
    if (resource == null) return scoreMap;
    Map<String, dynamic> tmpMap = json.decode(resource);
    // string to List<User>
    tmpMap.forEach((key, value) {
      scoreMap[key] = [];
      value.forEach((i) {
        scoreMap[key].add(Score.fromJson(i));
      });
    });
    print("get$scoreMap");
    return scoreMap;
  }

  Future<void> addScore(Score score) async {
    Map<String, dynamic> map = await getScore();
    Map<String, dynamic> submitMap = Map<String, dynamic>();

    if (map == null) {
      submitMap[score.date] = [score];
    } else {
      submitMap = map;
      if (submitMap.containsKey(score.date)) {
        submitMap[score.date].add(score);
      } else {
        submitMap[score.date] = [score];
      }
    }
    print("保存$submitMap");
    await prefs.setString(scoreKey, json.encode(submitMap));
  }
//  Future<void> addScore(Score score) async {
//    Map<DateTime, dynamic> map = await getScore();
//    Map<String, dynamic> submitMap = Map<String, dynamic>();
//
//    if (map == null) {
//      submitMap[score.date] = [score];
//    } else {
//      submitMap = convertMap(map);
//      if (submitMap.containsKey(score.date)) {
//        submitMap[score.date].add(score);
//      } else {
//        submitMap[score.date] = [score];
//      }
//    }
//    //prefs.setString(scoreKey, null);
//    print("保存$submitMap");
//    await prefs.setString(scoreKey, json.encode(submitMap));
//  }

  Map<String, dynamic> convertMap(Map<DateTime, dynamic> scoreMap) {
    Map<String, List<Score>> returnMap = Map();
    scoreMap.forEach((key, value) {
      returnMap[key.toIso8601String()] = value;
    });
    return returnMap;
  }

  Future<void> saveScore(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, json.encode(value));
  }

  Future<void> resetScore(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, null);
  }
}
