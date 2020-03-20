import 'package:flutter/material.dart';
import 'package:flutter_app2/PageParts.dart';
import 'dart:async';
import 'package:flutter/services.dart';

/*----------------------------------------------

プライバシーポリシーScreenクラス

----------------------------------------------*/
class PrivacyPolicyScreen extends StatelessWidget {
  final PageParts _parts = PageParts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _parts.appBar(title: "プライバシーポリシー"),
      backgroundColor: _parts.backGroundColor,
      body: FutureBuilder(
        future: _loadAsset(),
        builder: (context, snapshot) {
          // 非同期処理が完了している場合にWidgetの中身を呼び出す
          if (!snapshot.hasData) {
            return _parts.indicator();
            // 非同期処理が未完了の場合にインジケータを表示する
          } else {
            return Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
                      color: Colors.white,
                      child: Text(
                        snapshot.data,
                        style: new TextStyle(
                          fontSize: 13.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                _parts.backButton(onPressed: () => Navigator.pop(context))
              ],
            );
          }
        },
      ),
    );
  }

  Future<String> _loadAsset() async {
    return rootBundle.loadString('assets/PrivacyPolicy.txt');
  }
}
