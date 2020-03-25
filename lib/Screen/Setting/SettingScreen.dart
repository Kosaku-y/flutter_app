import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app2/PageParts.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:flutter_app2/Repository/LoginRepository.dart';

import '../ProfileScreen.dart';
import 'PrivacyPolicyScreen.dart';
import 'TermsOfServiceScreen.dart';

/*----------------------------------------------

設定Screenクラス

----------------------------------------------*/
class SettingScreen extends StatelessWidget {
  final LoginRepository repository = LoginRepository();
  final PageParts _parts = PageParts();
  final User user;
  SettingScreen({Key key, this.user});
  // 画面全体のビルド
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _parts.appBar(title: "設定"),
      backgroundColor: _parts.backGroundColor,
      body: Container(
        child: ListView(children: <Widget>[
          _listElement(
            title: "プロフィールを見る",
            onTap: () {
              Navigator.of(context).push<Widget>(
                MaterialPageRoute(
                  settings: const RouteSettings(name: "/Profile"),
                  builder: (context) => new ProfileScreen(user: user),
                ),
              );
            },
          ),
          _listElement(
            title: "ログアウト",
            onTap: () {
              showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return new AlertDialog(
                    content: const Text('ログアウトしてよろしいですか？'),
                    actions: <Widget>[
                      new FlatButton(
                        child: const Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      new FlatButton(
                        child: const Text('Yes'),
                        onPressed: () async {
                          await repository.signOut();
                          Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          _listElement(
            title: "プライバシーポリシー",
            onTap: () {
              Navigator.of(context).push<Widget>(
                MaterialPageRoute(
                  settings: const RouteSettings(name: "/PrivacyPolicy"),
                  builder: (context) => new PrivacyPolicyScreen(),
                ),
              );
            },
          ),
          _listElement(
            title: "利用規約",
            onTap: () {
              Navigator.of(context).push<Widget>(
                MaterialPageRoute(
                  settings: const RouteSettings(name: "/TermsOfService"),
                  builder: (context) => new TermsOfServiceScreen(),
                ),
              );
            },
          ),
        ]),
      ),
    );
  }

  Widget _listElement({String title, Function() onTap}) {
    return Column(
      children: <Widget>[
        ListTile(
            title: Text(
              title,
              style: TextStyle(color: _parts.pointColor),
            ),
            trailing: Icon(Icons.arrow_forward, color: _parts.pointColor),
            onTap: onTap),
        Divider(
          color: _parts.fontColor,
          height: 4.0,
        ),
      ],
    );
  }
}
