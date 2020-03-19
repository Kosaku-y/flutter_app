/*----------------------------------------------
scoreエンティティ
1半荘ベースで考える
----------------------------------------------*/

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
}

class ScoreAnalyze {
  double games = 0; //試合数
  double totalChip = 0; //トータルのチップ
  double totalPoint = 0.0; //総合得点
  double totalBalance = 0; //トータル収支
  double associationRate = 0.0; //連対率
  double avoidFourthRate = 0.0; //4着回避率
  List<double> rankingList = [0, 0, 0, 0]; //順位回数rankingList[0] -> 1着回数

  ScoreAnalyze.fromList(Map<String, List<Score>> map) {
    map.forEach((key, value) {
      value.forEach((element) {
        games++;
        totalChip += element.chip;
        totalPoint += element.total;
        totalBalance += element.balance;
        rankingList[element.ranking - 1]++;
      });
    });
    associationRate = (rankingList[0] + rankingList[1]) / games;
    avoidFourthRate = 1 - (rankingList[3] / games);
    print("${this.games}"
        "¥n${this.totalChip}"
        "¥n${this.totalPoint}"
        "¥n${this.totalBalance}"
        "¥n${this.associationRate}"
        "¥n${this.avoidFourthRate}"
        "¥n${this.rankingList}");
  }
}
