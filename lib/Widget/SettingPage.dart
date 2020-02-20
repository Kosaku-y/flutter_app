import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app2/Entity/PageParts.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:flutter_app2/Repository/LoginRepository.dart';

import 'package:flutter_app2/Widget/ProfilePage.dart';
import 'LoginPage.dart';

class SettingPage extends StatelessWidget {
  LoginRepository repository = LoginRepository();
  PageParts set = PageParts();
  User user;
  SettingPage({Key key, this.user});
  // 画面全体のビルド
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: set.baseColor,
        title: Text('設定＆ログアウト',
            style: TextStyle(
              color: set.pointColor,
            )),
      ),
      backgroundColor: set.backGroundColor,
      body: Container(
        child: ListView(children: <Widget>[
          ListTile(
              title: Text(
                "プロフィールを見る",
                style: TextStyle(color: set.pointColor),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.of(context).push<Widget>(
                  MaterialPageRoute(
                    settings: const RouteSettings(name: "/Profile"),
                    builder: (context) => new ProfilePage(user: user),
                  ),
                );
              }),
          Divider(
            color: set.fontColor,
            height: 4.0,
          ),
          ListTile(
              title: Text(
                "ログアウト",
                style: TextStyle(color: set.pointColor),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () async {
                await repository.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
                    ModalRoute.withName('/NewHome'));
//                Navigator.of(context).pushReplacement(
//                  MaterialPageRoute(
//                    settings: const RouteSettings(name: "/Login"),
//                    builder: (context) => LoginPage(),
//                  ),
//                );
              }),
          Divider(
            color: set.fontColor,
            height: 4.0,
          ),
        ]),
      ),
    );
  }
}