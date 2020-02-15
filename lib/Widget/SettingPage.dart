import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app2/Entity/PageParts.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:flutter_app2/Repository/LoginRepository.dart';

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
                "Logout",
                style: TextStyle(color: set.pointColor),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () async {
                await repository.signOut();
//                Navigator.of(context).pushReplacement(
//                  MaterialPageRoute(
//                    builder: (BuildContext context) => LoginPage(),
//                  ),
//                );
                Navigator.pushAndRemoveUntil(context,
                    new MaterialPageRoute(builder: (context) => new LoginPage()), (route) => false);
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
