import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app2/PageParts.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:flutter_app2/Repository/LoginRepository.dart';

/*----------------------------------------------

お知らせScreenクラス

----------------------------------------------*/

class NoticeScreen extends StatelessWidget {
  final LoginRepository repository = LoginRepository();
  final PageParts _parts = PageParts();
  final User user;
  NoticeScreen({Key key, this.user});

  // 画面全体のビルド
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _parts.appBar(title: "お知らせ"),
      backgroundColor: _parts.backGroundColor,
      body: Container(
        child: ListView(
          children: <Widget>[
            _listElement(title: "ver1.0がリリースされました"),
          ],
        ),
      ),
    );
  }

  Widget _listElement({String title, Function() onTap}) {
    return Column(
      children: <Widget>[
        ListTile(
            title: Text(title, style: TextStyle(color: _parts.pointColor)),
            //trailing: Icon(Icons.arrow_forward, color: _parts.pointColor),
            onTap: onTap),
        Divider(color: _parts.pointColor, height: 4.0),
      ],
    );
  }
}
