import 'package:flutter/material.dart';

/*----------------------------------------------

共通データScreenクラス(Stateless)

----------------------------------------------*/

class CommonData {
  Map<int, String> rankMap = {
    5: "Blue",
    10: "Yellow",
    20: "Green",
    40: "Purple",
    80: "Red",
    160: "Bronze",
    320: "Silver",
    480: "Gold"
  };

  Map<String, Color> colorMap = {
    "Blue": Colors.blue,
    "Yellow": Colors.yellow,
    "Green": Colors.green,
    "Purple": Colors.purple,
    "Red": Colors.red,
    "Bronze": Color(0xffb87333),
    "Silver": Color(0xffa0a0a0),
    "Gold": Color(0xffffd700),
  };
}
