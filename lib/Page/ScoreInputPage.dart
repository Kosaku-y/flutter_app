import 'package:flutter/material.dart';
import 'package:flutter_app2/Entity/PageParts.dart';

/*----------------------------------------------

スコア入力ページクラス

----------------------------------------------*/

class ScoreInputPage extends StatefulWidget {
  ScoreInputPage({Key key}) : super(key: key);

  State<StatefulWidget> createState() {
    return new ScoreInputPageState();
  }
}

class ScoreInputPageState extends State<ScoreInputPage> {
  PageParts set = new PageParts();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 2.0,
          backgroundColor: set.baseColor,
          title: Text('スコア入力', style: TextStyle(color: set.pointColor))),
      backgroundColor: set.backGroundColor,
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: <Widget>[],
        ),
      ),
    );
  }
}
