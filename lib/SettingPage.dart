import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app2/Entity/Entity.dart';
import 'Login.dart';

class SettingPage extends StatelessWidget {
  PageParts set = PageParts();
  User user;
  SettingPage(this.user);
  // 画面全体のビルド
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: set.backGroundColor,
      body: Container(
        child: ListView(children: <Widget>[
          ListTile(
              title: Text(
                "Logout",
                style: TextStyle(color: set.pointColor),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => LoginPage("Logout"),
                  ),
                );
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
