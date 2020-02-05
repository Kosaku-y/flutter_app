import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Entity/PageParts.dart';
import 'main.dart';
import 'package:flutter_app2/Widget/AccountSettingPage.dart';
import 'Entity/User.dart';

class LoginPage extends StatefulWidget {
  @override
  String mode;
  LoginPage(this.mode);
  _LoginPageState createState() => new _LoginPageState();
}

//ログイン状態Enum
enum AuthStatus {
  /*
  * ログイン状態は以下の3通り
  * 1.未登録　　　　　：signedUp
  * 2.ログアウト状態　：notSignedIn
  * 3.ログイン状態　　：signIn
  */
  notSignedIn,
  signedIn,
  signedUp
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _mainReference = FirebaseDatabase.instance.reference().child("User/Gmail");

  final formkey = new GlobalKey<FormState>();
  FirebaseUser fUser;
  AuthStatus status = AuthStatus.notSignedIn;
  bool isLoginChecked = false;
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _tokenSecretController = TextEditingController();
  String _message = '';

  String _email;
  String _password;
  PageParts set = PageParts();
  User user = User();
  String username = 'Your Name';

  //現在ログイン状態かどうか
  /*
  * 情報なし(notSignedIn) => ログイン画面に遷移
  * 情報あり => 初回かどうかfirebase検索
  *    初回 => 登録ページに遷移
  *    2回目以降 => Homeに遷移
  */
  //現在のステータス確認
  @override
  void initState() {
    if (widget.mode == "Login") {
      //まず前回のキャッシュが残っているかチェック
      checkFireBaseLogin();
    } else {}
  }

  void checkFireBaseLogin() async {
    FirebaseUser currentUser = await _auth.currentUser();
    setState(() {
      if (currentUser != null) {
        checkLogin(currentUser.email.replaceAll(RegExp(r'@[A-Za-z]+.[A-Za-z]+'), ""));
      }
    });
  }

  void checkLogin(String key) async {
    await _mainReference.child(key).once().then((DataSnapshot result) {
      if (result.value == null) {
        status = AuthStatus.signedUp;
      } else {
        if (result.value["name"] == "") {
          status = AuthStatus.signedUp;
        } else {
          status = AuthStatus.signedIn;
        }
      }

      switch (status) {
        case AuthStatus.signedUp:
          user = User();
          user.userId = key;
          //ページ遷移
//          Navigator.of(context).push(
//            MaterialPageRoute(
//              builder: (BuildContext context) => AccountPage(user, "regist"),
//            ),
//          );

          break;
        case AuthStatus.signedIn:
          user = User.fromMap(result.value);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => BottomNavigationPage(user: user, message: "ログインしました"),
            ),
          );

          break;
        case AuthStatus.notSignedIn:
          break;
      }
    });
  }

  Future setAppUser(String mail) async {}

  Future<FirebaseUser> _googleSignin() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser fireUser = (await _auth.signInWithCredential(credential)).user;

    setState(() {
      username = fireUser.displayName;
    });
    return fireUser;
  }

  // Example code of how to sign in with Twitter.
  Future<FirebaseUser> _signInWithTwitter() async {
    final AuthCredential credential = TwitterAuthProvider.getCredential(
        authToken: _tokenController.text, authTokenSecret: _tokenSecretController.text);
    final FirebaseUser fireUser = (await _auth.signInWithCredential(credential)).user;
//    assert(user.email != null);
//    assert(user.displayName != null);
//    assert(!user.isAnonymous);
//    assert(await user.getIdToken() != null);
    setState(() {
      username = fireUser.displayName;
    });
    return fireUser;
//    assert(user.uid == currentUser.uid);
//    setState(() {
//      if (user != null) {
//        _message = 'Successfully signed in with Twitter. ' + user.uid;
//      } else {
//        _message = 'Failed to sign in with Twitter. ';
//      }
//    });
  }

  Future<void> _handleSignOut() async {
    await _auth.signOut();
    setState(() {
      username = 'ログアウトしました';
      status = AuthStatus.notSignedIn;
    });
    print("user sign out now");
  }

  @override
  Widget build(BuildContext context) {
    switch (status) {
//      case AuthStatus.signedIn:
//        return Home(user);
//      //case AuthStatus.notSignedIn:
      default:
        return Scaffold(
          appBar: new AppBar(
            title: new Text("ログイン", style: TextStyle(color: set.pointColor)),
            backgroundColor: set.baseColor,
          ),
          backgroundColor: set.backGroundColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '$username',
                  style: TextStyle(color: set.fontColor, fontSize: 20.0),
                ),
//                FutureBuilder(
//                  future: _handleSignIn(),
//                  builder:  (context, snapshot) {
//                    if (snapshot.hasData) {
//                      return
//                    };
//                  },
//                ),
                SignInButton(
                  Buttons.Twitter,
                  text: "Login with Twitter",
                  onPressed: () => _signInWithTwitter(),
                ),

                StreamBuilder(
                    stream: _auth.onAuthStateChanged,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SignInButton(
                          Buttons.Google,
                          text: "sign out",
                          onPressed: () => _handleSignOut(),
                        );
                      } else {
                        return SignInButton(
                          Buttons.Google,
                          text: "Login with Google",
                          onPressed: () => _googleSignin()
                              .then((FirebaseUser fireUser) => setState(() {
                                    username = fireUser.displayName;
                                    String key = fireUser.email
                                        .replaceAll(RegExp(r'@[A-Za-z]+.[A-Za-z]+'), "");
                                    String dotChange = key.replaceAll(".", "[dot]");
                                    checkLogin(dotChange);
                                  }))
                              .catchError((e) => print(e)),
                        );
                      }
                    }),
              ],
            ),
          ),
        );
//      case AuthStatus.signedUp:
//        return
    }
  }
//  Future<bool> mailCheck(String email) async {
//    return email.endsWith('@gmail.com');
//  }
//
//  Future<FirebaseUser> _handleSignIn() async {
//    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
//    final GoogleSignInAuthentication googleAuth =
//        await googleUser.authentication;
//
//    final AuthCredential credential = GoogleAuthProvider.getCredential(
//      accessToken: googleAuth.accessToken,
//      idToken: googleAuth.idToken,
//    );
//
//    final FirebaseUser user =
//        (await _auth.signInWithCredential(credential)).user;
//    print("signed in " + user.displayName);
//    return user;
//  }
//
//  Future<String> createUserWithEmailAndPassword(
//      String email, String password) async {
//    if (mailCheck(email) == false) {
//      return null;
//    }
//    FirebaseUser user = await _handleSignIn.createUserWithEmailAndPassword(
//        email: email, password: password);
//    return user.uid;
//  }
//
//  Future<String> deleteUserWithEmailAndPassword(
//      String email, String password) async {
//    if (mailCheck(email) == false) {
//      return null;
//    }
//    FirebaseUser user = await _firebaseAutn.currentUser();
//    if (user == null) {
//      return null;
//    }
//    String latestuser = user.uid;
//    if (user != null) {
//      await user.delete();
//      return latestuser;
//    }
//    return null;
//  }
//
//  bool validateAndSave() {
//    final form = formkey.currentState;
//    if (form.validate()) {
//      form.save();
//      return true;
//    } else {
//      return false;
//    }
//  }
//
//  void submit() async {
//    if (validateAndSave()) {
//      try {
//        String userId = await sginInWithEmailAndPassword(_email, _password);
//        if (userId == null) {
//          print('input mail address is not gmail. please input gmail address');
//        }
//        print('Sigind in: $userId');
//      } catch (e) {
//        print(e);
//      }
//    }
//  }
//
//  void regester() async {
//    if (validateAndSave()) {
//      try {
//        String userId = await createUserWithEmailAndPassword(_email, _password);
//        print('Regestered in: $userId');
//      } catch (e) {
//        print(e);
//      }
//    }
//  }
//
//  void regester1() async {
//    if (validateAndSave()) {
//      try {
//        String userId = await createUserWithEmailAndPassword(_email, _password);
//        print('Regestered in: $userId');
//        Navigator.push(context,
//            MaterialPageRoute(builder: (context) => creationComplete()));
//      } catch (e) {
//        print(e);
//      }
//    }
//  }
//
//  void deleteAccount() async {
//    if (validateAndSave()) {
//      try {
//        String userId = await deleteUserWithEmailAndPassword(_email, _password);
//        if (userId != null) {
//          print('Delete an Account in: $userId');
//          Navigator.push(context,
//              MaterialPageRoute(builder: (context) => deleteComplete()));
//        } else {
//          print('Delete an Account failed');
//        }
//      } catch (e) {
//        print(e);
//      }
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text("FirebaseAuth"),
//      ),
//      body: new Container(
//        padding: EdgeInsets.all(20.0),
//        child: new Form(
//          key: formkey,
//          child: new Column(
//            crossAxisAlignment: CrossAxisAlignment.stretch,
//            children: buildInputs() + buildSubmitButtons(),
//          ),
//        ),
//      ),
//    );
//  }
//
//  List<Widget> buildInputs() {
//    return [
//      new TextFormField(
//        decoration: new InputDecoration(labelText: 'Email'),
//        validator: (value) => value.isEmpty ? 'メールアドレスを入力してください' : null,
//        onSaved: (value) => _email = value,
//      ),
//      new TextFormField(
//        decoration: new InputDecoration(labelText: 'PassWord'),
//        validator: (value) => value.isEmpty ? 'パスワードを入力してください' : null,
//        obscureText: true,
//        onSaved: (value) => _password = value,
//      ),
//    ];
//  }
//
//  List<Widget> buildSubmitButtons() {
//    return [
//      new RaisedButton(
//        splashColor: Colors.blueGrey,
//        child: new Text('Login', style: new TextStyle(fontSize: 20.0)),
//        onPressed: submit,
//      ),
//      new RaisedButton(
//        splashColor: Colors.blueGrey,
//        child:
//            new Text('Create an Account', style: new TextStyle(fontSize: 20.0)),
//        onPressed: regester1,
//      ),
//      new RaisedButton(
//        splashColor: Colors.red,
//        child:
//            new Text('Delete an Account', style: new TextStyle(fontSize: 20.0)),
//        onPressed: deleteAccount,
//      ),
//    ];
//  }
//}
//
//class creationComplete extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("CREATE USER SUCCESS"),
//      ),
//      body: Center(
//        child: RaisedButton(
//          onPressed: () {
//            Navigator.pop(context);
//          },
//          child: Text('Go back login'),
//        ),
//      ),
//    );
//  }
//}
//
//class deleteComplete extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("DELETE USER SUCCESS"),
//      ),
//      body: Center(
//        child: RaisedButton(
//          onPressed: () {
//            Navigator.pop(context);
//          },
//          child: Text('Go back login'),
//        ),
//      ),
//    );
//  }
}
