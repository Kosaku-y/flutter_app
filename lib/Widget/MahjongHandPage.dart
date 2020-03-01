import 'package:flutter/material.dart';
import 'package:flutter_app2/Entity/PageParts.dart';

class MahjongHand {
  String handName;
  String hansu;
  String explain;
  MahjongHand(this.handName, this.hansu, this.explain);
}

class MahjongHandPage extends StatelessWidget {
  final PageParts set = PageParts();
  final List<MahjongHand> entries = [
    MahjongHand("断么(タンヤオ)", "1", "中張牌（数牌の2〜8）のみを使って手牌を完成させた場合に成立する。断ヤオと略すことが多い。"),
    MahjongHand("平和(ピンフ)", "1", "面子が全て順子で、雀頭が役牌でなく、待ちが両面待ちになっている場合に成立する。"),
  ];
  MahjongHandPage();
  //画面全体のビルド
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("役一覧", style: TextStyle(color: set.pointColor)),
        backgroundColor: set.baseColor,
      ),
      backgroundColor: set.backGroundColor,
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: new Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return _buildRow(index);
                  },
                  itemCount: entries.length,
                ),
              ),
              Divider(
                height: 8.0,
              ),
              set.backButton(onPressed: () => Navigator.pop(context))
//              Container(
//                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
//                  child: _buildInputArea()
//              )
            ],
          )),
    );
  }

  //リスト要素生成
  Widget _buildRow(int index) {
    //リストの要素一つづつにonTapを付加して、詳細ページに飛ばす
    return new GestureDetector(
      onTap: () {
//        Navigator.push(
//            this.context,
//            MaterialPageRoute(
//              // パラメータを渡す
//                builder: (context) => new EventDetailPage(entries[index])));
      },
      child: new SizedBox(
        child: new Card(
          elevation: 10,
          color: set.backGroundColor,
          child: new Container(
            decoration: BoxDecoration(
              border: Border.all(color: set.fontColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Row(// 1行目
                      children: <Widget>[
                    Expanded(
                      // 2.1列目
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            // 3.1.1行目
                            margin: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              entries[index].handName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: set.fontColor),
                            ),
                          ),
                          Container(
                            // 3.1.2行目
                            child: Text(
                              entries[index].explain,
                              style: TextStyle(fontSize: 12.0, color: set.fontColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      entries[index].hansu + "飜",
                      style: TextStyle(fontSize: 26.0, color: set.pointColor),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
