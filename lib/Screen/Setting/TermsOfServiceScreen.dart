import 'package:flutter/material.dart';
import 'package:flutter_app2/Util/ScreenParts.dart';
import 'dart:async';
import 'package:flutter/services.dart';

/*----------------------------------------------

利用規約Screenクラス

----------------------------------------------*/
class TermsOfServiceScreen extends StatelessWidget {
  final ScreenParts _parts = ScreenParts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _parts.appBar(title: "利用規約"),
      backgroundColor: _parts.backGroundColor,
      body: FutureBuilder(
        future: _loadAsset(),
        builder: (context, snapshot) {
          // 非同期処理が完了している場合にWidgetの中身を呼び出す
          if (!snapshot.hasData) {
            return _parts.indicator;
            // 非同期処理が未完了の場合にインジケータを表示する
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
                        color: Colors.white,
                        child: Text(snapshot.data,
                            style: new TextStyle(fontSize: 13.0, color: Colors.black)),
                      ),
                    ),
                  ),
                  _parts.backButton(context)
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<String> _loadAsset() async {
    return rootBundle.loadString('assets/TermsOfService.txt');
  }
}
