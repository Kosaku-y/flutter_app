import 'package:flutter/material.dart';
import 'package:flutter_app2/Entity/MahjongHand.dart';
import 'package:flutter_app2/Util/ScreenParts.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';

/*----------------------------------------------

麻雀役一覧Screenクラス(Stateless)

----------------------------------------------*/
class MahjongHandScreen extends StatelessWidget {
  final ScreenParts _parts = ScreenParts();

  //画面全体のビルド
  @override
  Widget build(BuildContext context) {
    List<MahjongHand> handList;
    int i = 0;
    int _currentYaku = 0;
    return Scaffold(
      appBar: _parts.appBar(title: "役一覧"),
      backgroundColor: _parts.backGroundColor,
      body: FutureBuilder(
        future: _loadAsset(),
        builder: (context, snapshot) {
          // 非同期処理が完了している場合にWidgetの中身を呼び出す
          if (!snapshot.hasData) {
            return _parts.indicator;
            // 非同期処理が未完了の場合にインジケータを表示する
          } else {
            handList = snapshot.data;
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
              child: new Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        if (handList[index - i].yaku != _currentYaku) {
                          _currentYaku = handList[index - i].yaku;
                          i++;
                          return Card(
                              color: _parts.endGradient,
                              child: ListTile(
                                  title: Text("$_currentYaku飜",
                                      style:
                                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold))));
                        }
                        return _buildRow(handList[index - i]);
                      },
                      itemCount: handList.length + 5,
                    ),
                  ),
                  Divider(height: 8.0),
                  _parts.backButton(context)
                ],
              ),
            );
          }
        },
      ),
    );
  }

  //リスト要素生成
  Widget _buildRow(MahjongHand element) {
    //リストの要素一つづつにonTapを付加して、詳細ページに飛ばす
    return InkWell(
      onTap: () {
//        Navigator.push(
//            this.context,
//            MaterialPageRoute(
//              // パラメータを渡す
//                builder: (context) => new DetailPage(handList
//                [index])));
      },
      child: new Card(
        elevation: 10,
        color: _parts.backGroundColor,
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            border: Border.all(color: _parts.fontColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
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
                        "${element.name}(${element.kana})",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0, color: _parts.pointColor),
                      ),
                    ),
                    Container(
                      // 3.1.2行目
                      child: Text(
                        element.description,
                        style: TextStyle(fontSize: 12.0, color: _parts.fontColor),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Future<List<MahjongHand>> _loadAsset() async {
    String body = await rootBundle.loadString('assets/MahjongHandfromWiki.json');
    Map<String, dynamic> map = jsonDecode(body);
    List<MahjongHand> list = [];
    map["hands"].forEach((value) {
      list.add(MahjongHand.fromMap(value));
    });
    return list;
  }
}
