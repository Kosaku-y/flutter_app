/*----------------------------------------------

麻雀役Entityクラス

  name 役名
  kana カナ
  yaku 飜数
  description
  restriction
----------------------------------------------*/

class MahjongHand {
  String name;
  String kana;
  int yaku;
  String description;
  String restriction;

  MahjongHand.fromMap(Map map)
      : name = map["name"],
        kana = map["kana"],
        yaku = map["yaku"],
        description = map["description"],
        restriction = map["restriction"];
}
