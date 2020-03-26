import 'package:flutter_app2/Entity/Score.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
  SharedPreferences _prefs;
  Map<String, List<Score>> scoreMap;

  LocalDataRepository() {
    scoreMap = {};
  }

  //更新
  Future<void> reFleshScoreMap() async {
    _prefs = await SharedPreferences.getInstance();
    var resource = _prefs.getString(scoreKey);
    if (resource == null) {
      scoreMap = {};
      return;
    }
    Map<String, dynamic> tmpMap = json.decode(resource);
    // string to List<User>
    tmpMap.forEach((key, value) {
      scoreMap[key] = [];
      value.forEach((i) {
        scoreMap[key].add(Score.fromJson(i));
      });
    });
    print("get:$scoreMap");
  }

  //Map取得
  Future<Map<DateTime, List<Score>>> getScoreMap() async {
    await reFleshScoreMap();
    if (scoreMap.isEmpty) {
      return {};
    }
    Map<DateTime, List<Score>> returnMap = {};
    scoreMap.forEach((key, value) {
      returnMap[DateTime.parse(key)] = value;
    });
    print("get$scoreMap");
    return returnMap;
  }

  //新規追加
  Future<void> addScore(Score score) async {
    await reFleshScoreMap();
    if (scoreMap == null) {
      scoreMap[score.date] = [score];
    } else {
      if (scoreMap.containsKey(score.date)) {
        scoreMap[score.date].add(score);
      } else {
        scoreMap[score.date] = [score];
      }
    }
    print("保存$scoreMap");
    await _prefs.setString(scoreKey, json.encode(scoreMap));
  }

  //sharedPreferenceにはStringのみしか入らないためkeyを変換
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

  Future<void> resetScore() async {
    _prefs = await SharedPreferences.getInstance();
    scoreMap = {};
    await _prefs.setString(scoreKey, null);
  }
}
