import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Entity/AuthStatus.dart';
import 'Entity/User.dart';
import 'Screen/Login/AccountRegisterScreen.dart';
import 'Screen/Login/LoginScreen.dart';
import 'main.dart';

/*----------------------------------------------

SplashScreenクラス

----------------------------------------------*/
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final int mode = 0;
  /*
  * 実機 0
  * ログインスルー 1
  * */
  @override
  void initState() {
    super.initState();

    new Future.delayed(const Duration(seconds: 2)).then((value) => handleTimeout());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        // TODO: スプラッシュアニメーション
        child: const CircularProgressIndicator(),
      ),
    );
  }

  void handleTimeout() {
    // ログイン画面へ
    switch (mode) {
      case 0:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            settings: const RouteSettings(name: "/Login"),
            builder: (context) => LoginScreen(),
          ),
        );
        return;
      case 1:
        User user = User.fromMap("test", {
          "userId": "test",
          "name": "テストユーザ",
          "age": "25",
          "sex": "男性",
          "rank": "5",
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            settings: RouteSettings(name: "/Main"),
            builder: (context) => MainScreen(user: user, message: "ログインしました"),
          ),
        );
        return;
      case 2:
        User user = User.tmpUser(AuthStatus.signedUp, "test");
        user.name = "テストユーザ";
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            settings: const RouteSettings(name: "/AccountRegister"),
            builder: (BuildContext context) => AccountRegisterScreen(user: user),
          ),
        );
    }
  }
}
