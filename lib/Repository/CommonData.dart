import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonData {
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

  /*csv読み込み*/
  stationLoadAsset() async {
    final myData = await rootBundle.loadString("asset/csv/station.csv");
    List<List<dynamic>> csvTable = CsvToListConverter().convert(myData);

    print(csvTable);
  }
}
