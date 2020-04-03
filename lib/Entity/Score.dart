/*----------------------------------------------

スコアEntityクラス

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

/*----------------------------------------------

スコア分析Entityクラス

----------------------------------------------*/
class ScoreAnalyze {
  double games = 0; //試合数
  double totalChip = 0; //トータルのチップ
  double totalPoint = 0.0; //総合得点
  double totalBalance = 0; //トータル収支
  double associationRate = 0.0; //連対率
  double avoidFourthRate = 0.0; //4着回避率
  List<double> rankingList = [0, 0, 0, 0]; //順位回数rankingList[0] -> 1着回数

  ScoreAnalyze.fromMap(Map<DateTime, List<Score>> map) {
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
  }

  void printScore() {
    print("\n試合数　　　：${this.games}"
        "\n合計チップ　：${this.totalChip}枚"
        "\n合計ポイント：${this.totalPoint}pt"
        "\n合計収支　　：${this.totalBalance}円"
        "\n連対率　　　：${this.associationRate}%"
        "\n４着回避率　：${this.avoidFourthRate}");
  }
}
