/*----------------------------------------------
scoreエンティティ
1半荘ベースで考える
----------------------------------------------*/
import 'package:flutter_app2/Entity/PageParts.dart';

class Score {
  String date; //日付,primaryKey
  int ranking; //順位
  int chip; //チップ
  int total; //最終得点
  int rate; //レート
  int balance; //収入

  Score(this.date, this.ranking, this.chip, this.total, this.rate, this.balance);
  Score.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        ranking = json['ranking'],
        chip = json['chip'],
        total = json['total'],
        rate = json['rate'],
        balance = json['balance'];

  Map<String, dynamic> toJson() => {
        'date': date,
        'ranking': ranking,
        'chip': chip,
        'total': total,
        'rate': rate,
        'balance': balance
      };

  //連対率
  //4着回避率

}
