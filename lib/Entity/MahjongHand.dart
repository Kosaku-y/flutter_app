/*----------------------------------------------

麻雀役Entityクラス

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
