import 'package:flutter_app2/Entity/Score.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/*----------------------------------------------

ローカルデータリポジトリクラス

----------------------------------------------*/
/*
* Map<String dateKey,List<Score>>
*
* */
class LocalDataRepository {
  final String scoreKey = "scoreKey";
  LocalDataRepository();

  Future<Map<String, List<Score>>> getScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tmpMap = json.decode(prefs.getString(scoreKey));
    var scoreMap = Map();
    tmpMap.forEach((k, v) {
      v.forEach((score) {
        scoreMap[k].add(Score.fromJson(score));
      });
    });
    return scoreMap;
  }

  Future<void> saveScore(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }
}
