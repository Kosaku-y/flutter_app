import 'package:flutter_app2/Bloc/LoginBloc.dart';
import 'package:flutter_app2/Entity/LoginStatus.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Util/ScreenParts.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../../main.dart';
import 'AccountRegisterScreen.dart';

/*----------------------------------------------
ログインScreenクラス
----------------------------------------------*/

class LoginScreen extends StatefulWidget {
  const LoginScreen();

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

/* * *
*　　currentUser.sink.add
*   (user)->
*     firebase.sink.add(userID)->
*     (userID) -> ログイン(ページ遷移)
*
*     (userID) -> 新規登録(ページ遷移)
*   (null)->none
*
*   Googleボタン押下(googleLogin.sink.add)->
*     →(user)->
*     firebase.sink.add(userID)->
*     (userId) -> ログイン(ページ遷移)
*     (userId) -> 新規登録(ページ遷移)
*     →null 失敗
*
* */
class LoginScreenState extends State<LoginScreen> {
  final ScreenParts _parts = ScreenParts();
  final LoginBloc loginBloc = LoginBloc();
  bool _showIndicator = false;

  ///@Todo 一部StreamをSplashに移行、snapshotの分岐
  @override
  void initState() {
    super.initState();
    loginBloc.currentTempUserStream.listen((result) async {
      // サインイン完了でマイページへ
      if (result.status != null) {
        if (result.status == Status.signIn) {
          print("自動ログイン完了");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              settings: RouteSettings(name: "/Main"),
              builder: (context) => MainScreen(user: result.user, message: "ログインしました"),
            ),
          );
          // 初回登録フォームへ
        } else if (result.status == Status.signUp) {
          print("ユーザー情報が見つかりませんでした");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              settings: const RouteSettings(name: "/AccountSetting"),
              builder: (BuildContext context) => AccountRegisterScreen(user: result.user),
            ),
          );
        }
      }
      print("user not signIn");
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Padding(
      padding: const EdgeInsets.all(80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SignInButton(Buttons.Google, text: "Signin with Google", onPressed: () => googleSignIn()),
          SignInButton(Buttons.Twitter, text: "Signin with Twitter", onPressed: () => null),
          SignInButton(Buttons.Apple, text: "Signin with Apple", onPressed: () => null),
        ],
      ),
    );
    return Scaffold(
      appBar: _parts.appBar(title: "ログイン"),
      backgroundColor: _parts.backGroundColor,
      body: _parts.modalProgress(child: body, inAsyncCall: _showIndicator),
    );
  }

  void googleSignIn() {
    _showIndicator = true;
    loginBloc.callGoogleLogin();
  }

  @override
  void dispose() {
    super.dispose();
    loginBloc?.dispose();
  }
}
