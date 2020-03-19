import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Entity/PageParts.dart';

class ReturnTopScreen extends StatelessWidget {
  final PageParts _parts = PageParts();
  final String message;
  ReturnTopScreen({Key key, @required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _parts.appBar(title: "完了"),
      backgroundColor: _parts.backGroundColor,
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Text("$message", style: TextStyle(color: _parts.pointColor)),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(50.0),
              child: _parts.iconButton(
                message: "検索ページに戻る",
                icon: Icons.keyboard_backspace,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
