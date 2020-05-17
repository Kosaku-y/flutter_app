import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Util/ScreenParts.dart';
import 'Bloc/LoginBloc.dart';
import 'Entity/LoginStatus.dart';
import 'Entity/User.dart';
import 'Screen/Login/AccountRegisterScreen.dart';
import 'Screen/Login/LoginScreen.dart';
import 'main.dart';

/*----------------------------------------------

CheckStatusScreenクラス

----------------------------------------------*/
class CheckStatusScreen extends StatefulWidget {
  @override
  _CheckStatusScreen createState() => new _CheckStatusScreen();
}

class _CheckStatusScreen extends State<CheckStatusScreen> {
  final ScreenParts parts = ScreenParts();
  final LoginBloc loginBloc = LoginBloc();
  static const int release = 0;
  static const int debug = 1;
  static const int debug_register = 2;
  final int mode = release;
  /*
  * release 0
  * テストユーザ (providerログインなし) 1
  * アカウント設定 (providerログインなし) 2
  * */
  @override
  void initState() {
    super.initState();
    loginBloc.callCurrentStatus();
    // _loading = true;
  }

  @override
  Widget build(BuildContext context) {
    // ログイン画面へ
    switch (mode) {
      case release:
        print("release mode launching...");
        return StreamBuilder<LoginResult>(
          stream: loginBloc.currentTempUserStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text("エラーが発生しました" + snapshot.error.toString());
            if (!snapshot.hasData)
              return Center(child: parts.indicator);
            else {
              if (snapshot.data.status == Status.signIn) {
                print("status : SignIn");
                return MainScreen(user: snapshot.data.user, message: "ログインしました");
              }
              if (snapshot.data.status == Status.signUp) {
                print("status : SignUp");
                return AccountRegisterScreen(user: snapshot.data.user);
              } else
                print("status : notSignIn");
              return LoginScreen();
            }
          },
        );

      case debug:
        print("debug mode launching...");

        User user = User.signIn("test", "test@test.co.jp", {
          "userId": "test",
          "name": "テストユーザ",
          "age": "25",
          "sex": "男性",
          "rank": "1",
        });
        return MainScreen(user: user, message: "ログインしました");
      case debug_register:
        print("debug(register) mode launching...");
        User user = User.signUp("test", "test@test.co.jp");
        user.setName = "テストユーザ";
        return AccountRegisterScreen(user: user);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
