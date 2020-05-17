import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:flutter_twitter_login/flutter_twitter_login.dart';
//import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter_app2/Entity/LoginStatus.dart';

/*----------------------------------------------

ログインRepositoryクラス

----------------------------------------------*/
class LoginRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  LoginRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();
  // コンストラクタ引数の{}は名前付き任意引数で、生成時に指定できる。(しない場合はnullで生成される)
  // ??はnull判定(if null)

  //Googleサインイン
  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser();
  }

  //fireBaseサインイン部分
  checkFireBaseLogin(FirebaseUser currentUser) async {
    final _mainReference = FirebaseDatabase.instance.reference().child("User");
    //メールアドレス正規化
    var userId = currentUser.uid;
    var userAddress = currentUser.email;
    LoginResult status;
    await _mainReference.child(userId).once().then((DataSnapshot result) async {
      if (result.value == null) {
        status = LoginResult.signUp(User.signUp(userId, userAddress));
      } else {
        status = LoginResult.signIn(User.signIn(userId, userAddress, result.value));
      }
    });
    return status;
  }

  //現在ログイン済みかどうか判定
  isSignedIn() async {
    try {
      final currentUser = await _firebaseAuth.currentUser();
      return currentUser;
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
    }
  }

  //ログアウト
  Future<void> signOut() async {
    try {
      return Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
    }
  }

//  String makeUserId(String key) {
//    String userId = key.replaceAll(RegExp(r'@[A-Za-z]+.[A-Za-z]+'), "");
//    return userId.replaceAll(".", "[dot]");
//  }
/* ------Twitterサインイン機能------
  final TwitterLogin twitterLogin = TwitterLogin(
    consumerKey: consumerKey,
    consumerSecret: secretkey,
  );
  Future<FirebaseUser> signInWithTwitter() async {
    // twitter認証の許可画面が出現
    final TwitterLoginResult result = await twitterLogin.authorize();
    //Firebaseのユーザー情報にアクセス & 情報の登録 & 取得
    final AuthCredential credential = TwitterAuthProvider.getCredential(
      authToken: result.session.token,
      authTokenSecret: result.session.secret,
    );
    //Firebaseのuser id取得
    final FirebaseUser user = (await _firebaseAuth.signInWithCredential(credential)).user;
    return _firebaseAuth.currentUser();
  }*/

/*------Appleサインイン機能------
  Future signInWithApple() async {
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:
        print("success");
        print(result.credential.user);
        // ログイン成功

        break;

      case AuthorizationStatus.error:
        print("Sign in failed: ${result.error.localizedDescription}");

        throw Exception(result.error.localizedDescription);
        break;

      case AuthorizationStatus.cancelled:
        print('User cancelled');
        break;
    }
  }
  * */
}
