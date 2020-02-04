import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:flutter_app2/Entity/AuthStatus.dart';

class LoginRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  LoginRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();
  //コンストラクタ引数の{}は名前付き任意引数で、生成時に指定できる。(しない場合はnullで生成される)
  // ??はnull判定(if null)

  //Googleサインイン部分
  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser();
  }
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

  //fireBaseサインイン部分
  Future<TempUser> checkFireBaseLogin(FirebaseUser currentUser) async {
    final _mainReference = FirebaseDatabase.instance.reference().child("User/Gmail");

    //メールアドレス正規化
    var userId = makeUserId(currentUser.email);
    var tempUser;
    await _mainReference.child(userId).once().then((DataSnapshot result) {
      if (result.value == null || result.value == "") {
        tempUser = TempUser(status: AuthStatus.signedUp, userId: userId);
      } else {
        tempUser = TempUser(status: AuthStatus.signedIn, userId: userId);
      }
    });
    return tempUser;
  }

  Future<FirebaseUser> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser;
  }

  //ログアウト
  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  String makeUserId(String key) {
    String userId = key.replaceAll(RegExp(r'@[A-Za-z]+.[A-Za-z]+'), "");
    return userId.replaceAll(".", "[dot]");
  }
}
