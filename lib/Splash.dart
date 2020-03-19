import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Entity/AuthStatus.dart';
import 'Entity/User.dart';
import 'Screen/LoginScreen.dart';
import 'main.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {
  int mode = 1;
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
            settings: const RouteSettings(name: "/login"),
            builder: (context) => LoginScreen(),
          ),
        );
        return;
      case 1:
        User user = User.tmpUser(AuthStatus.signedUp, "test");
        user.name = "テストユーザ";
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            settings: RouteSettings(name: "/Main"),
            builder: (context) => MainPage(user: user, message: "ログインしました"),
          ),
        );
        return;
    }
  }
}
