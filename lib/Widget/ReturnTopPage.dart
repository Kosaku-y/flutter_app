import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Entity/PageParts.dart';

class ReturnTopPage extends StatelessWidget {
  PageParts set = PageParts();
  String message;
  ReturnTopPage({Key key, @required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            onPressed: () => Navigator.of(context).popUntil(ModalRoute.withName("/EventSearch")),
          ),
        ],
      ),
    );
  }
}
