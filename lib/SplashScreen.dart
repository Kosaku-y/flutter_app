import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Util/ScreenParts.dart';
import 'CheckStatusScreen.dart';

/*----------------------------------------------

SplashScreenクラス

----------------------------------------------*/
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ScreenParts parts = ScreenParts();
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2)).then((value) => handleTimeout());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: parts.baseColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: スプラッシュアニメーション
            SizedBox(height: 200, width: 200, child: FlutterLogo()),
            Text("APP Title", style: TextStyle(color: Colors.white, fontSize: 30)),
          ],
        ),
      ),
    );
  }

  void handleTimeout() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        settings: const RouteSettings(name: "/CheckStatus"),
        builder: (context) => CheckStatusScreen(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
