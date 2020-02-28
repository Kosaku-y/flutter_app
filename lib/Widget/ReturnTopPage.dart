import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Entity/PageParts.dart';

class ReturnTopPage extends StatelessWidget {
  PageParts set = PageParts();
  String message;
  ReturnTopPage({Key key, @required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: set.baseColor,
        title: Text('完了',
            style: TextStyle(
              color: set.pointColor,
            )),
      ),
      backgroundColor: set.backGroundColor,
      body: Container(
        child: Column(
          children: <Widget>[
            Center(
              child: Text("$message", style: TextStyle(color: set.pointColor)),
            ),
            RaisedButton.icon(
                label: Text("検索ページへ戻る"),
                icon: Icon(
                  Icons.search,
                  color: set.fontColor,
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, "/EventSearch", (_) => false);
                }),
          ],
        ),
      ),
    );
  }
}
