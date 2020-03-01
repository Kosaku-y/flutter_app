import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Entity/PageParts.dart';

class ReturnTopPage extends StatelessWidget {
  final PageParts set = PageParts();
  final String message;
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Text("$message", style: TextStyle(color: set.pointColor)),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(50.0),
              child: set.iconButton(
                message: "検索ページに戻る",
                icon: Icons.keyboard_backspace,
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
