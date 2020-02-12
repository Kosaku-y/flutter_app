import 'package:flutter_app2/Bloc/Login_Bloc.dart';
import 'package:flutter_app2/Entity/PageParts.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Entity/AuthStatus.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'package:flutter_app2/Widget/AccountSettingPage.dart';
import '../main.dart';

/*----------------------------------------------
ログインページ
----------------------------------------------*/

class LoginPage extends StatefulWidget {
  const LoginPage();

  @override
  State<LoginPage> createState() => LoginPageState();
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
*
* */
class LoginPageState extends State<LoginPage> {
  PageParts set = PageParts();
  LoginBloc loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();
    loginBloc.stateSink.add(null);
    loginBloc.currentTempUserStream.listen((user) async {
      //サインイン完了でマイページへ
      if (user != null) {
        if (user.status == AuthStatus.signedIn) {
          print("自動ログイン完了");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              settings: RouteSettings(name: "/NewHome"),
              builder: (context) => MainPage(user: user, message: "ログインしました"),
            ),
          );
          //初回登録フォームへ
        } else if (user.status == AuthStatus.signedUp) {
          print("ユーザー情報が見つかりませんでした");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => AccountSettingPage(user: user, status: "regist"),
            ),
          );
        }
      }
      print("user not signIn");
    });
  }
  /*
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loginBloc.fireBaseLoginSink.add();
    loginBloc.loginStateStream.listen((onData) {
      //サインイン完了でマイページへ
      if (onData == AuthStatus.signedIn) {
        print("自動ログイン完了");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LaunchPage(user: user, message: "ログインしました"),
          ),
        );
        //初回登録フォームへ
      } else if (onData == AuthStatus.signedUp) {}
    });
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("ログイン", style: TextStyle(color: set.pointColor)),
          backgroundColor: set.baseColor,
        ),
        backgroundColor: set.backGroundColor,
        body: Padding(
          padding: const EdgeInsets.all(80),
          child: StreamBuilder<User>(
              stream: loginBloc.currentTempUserStream,
              builder: (context, snapshot) {
                print("loginBloc.currentStatusStream");
                if (snapshot.hasData) {
                  return Center(
                    child: const CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text("エラーが発生しました" + snapshot.error.toString());
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SignInButton(
                        Buttons.Google,
                        text: "Login with Google",
                        onPressed: () => loginBloc.googleLoginSink.add(null),
                      ),
                      SignInButton(
                        Buttons.Twitter,
                        text: "Login with Twitter",
                        onPressed: () => null,
                      ),
                      SignInButton(
                        Buttons.Apple,
                        text: "Login with Apple",
                        onPressed: () => null,
                      ),
                    ],
                  );
                }
              }),
        ));
  }

  @override
  void dispose() {
    loginBloc.dispose();
    super.dispose();
  }
}
