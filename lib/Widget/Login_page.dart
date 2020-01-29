import 'package:flutter_app2/Bloc/Login_Bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Entity/AuthStatus.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../main.dart';

class LoginForm extends StatefulWidget {
  const LoginForm();

  @override
  State<LoginForm> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    loginBloc = Provider.of<LoginBloc>(context);
    loginBloc.loginStateStream.listen((onData) {
      //サインイン完了でマイページへ
      if (onData == AuthStatus.signedIn) {
        print("自動ログイン完了");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Home(null, "ログインしました"),
          ),
        );
        //初回登録フォームへ
      } else if (onData == AuthStatus.signedUp) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = Provider.of<LoginBloc>(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: StreamBuilder<AuthStatus>(
        stream: loginBloc.currentStatusStream,
        initialData: loginBloc.loginStateStream.value,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text("エラーが発生しました" + snapshot.error.toString());
          } else {
            return SignInButton(
              Buttons.Google,
              text: "Login with Google",
              //onPressed: () =>
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
