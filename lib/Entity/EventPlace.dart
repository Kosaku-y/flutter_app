/*----------------------------------------------

都道府県Entityクラス

----------------------------------------------*/
class Pref {
  int code;
  String name;

  Map<String, int> lineMap = new Map();
  Pref(this.code, this.name);
}

/*----------------------------------------------

路線Entityクラス

----------------------------------------------*/
class Line {
  String code;
  String name;
  Station station;
  static Map<String, int> stationMap;
  Line();
}

/*----------------------------------------------

駅Entityクラス

-----------------------------------------------*/
class Station {
  String code;
  String name;
  Station({this.code, this.name});
}
