import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'EventSearch.dart';
import 'Recritment.dart';
import 'NewHome.dart';
import 'package:flutter_app2/Entity/Entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Login.dart';
import 'Chat.dart';
import 'SettingPage.dart';
import 'Widget/Login_page.dart';

//ホーム画面のrun
void main() {
  PageParts parts = PageParts();
  return runApp(
    new MaterialApp(
      title: "Home",
      home: new LoginForm(),
      theme: parts.defaultTheme,
    ),
  );
}

/*----------------------------------------------

ホーム(BottomNavigationBar)クラス

----------------------------------------------*/

class Home extends StatefulWidget {
  @override
  User user;
  String message; //前の画面からの遷移の場合はSnackBarで処理結果を表示する
  Home(this.user, this.message);

  State<StatefulWidget> createState() {
    return new HomeState(this.user);
  }
}

class HomeState extends State<Home> {
  PageController _pageController;
  int currentIndex = 0;
  User user;
  HomeState(this.user);

  PageParts set = PageParts();

  List<Widget> tabs;
  Map<Widget, GlobalKey<NavigatorState>> navigatorKeys;

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

//  @override
//  void dispose() {
//    super.dispose();
//    _pageController.dispose();
//  }

  @override
  void initState() {
    super.initState();
    tabs = [
      NewHome(user), //EventManage(key: PageStorageKey('EventManage'),),
      EventManagePage(),
      RoomPage(user),
      SettingPage(user), //SampleTabItem("messeage", Colors.black),
    ];

    navigatorKeys = {
      NewHome(user): GlobalKey<NavigatorState>(),
      EventManagePage(): GlobalKey<NavigatorState>(),
      RoomPage(user): GlobalKey<NavigatorState>(),
      SettingPage(user): GlobalKey<NavigatorState>(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await navigatorKeys[currentIndex].currentState.maybePop(),
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: set.baseColor,
          title: new Text("Matching App"),
        ),
        body: tabs[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: set.baseColor,
          fixedColor: set.fontColor,
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.white,
          currentIndex: currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(const IconData(59574, fontFamily: 'MaterialIcons')),
              title: new Text('Search'),
            ),
            BottomNavigationBarItem(icon: new Icon(Icons.message), title: new Text("Message")),
            BottomNavigationBarItem(icon: new Icon(Icons.settings), title: new Text('Setting')),
          ],
        ),
      ),
    );
  }
}

/*----------------------------------------------

ホーム(メインページ)クラス

----------------------------------------------*/
class Main extends StatefulWidget {
  const Main() : super();

  // アロー関数を用いて、Stateを呼ぶ
  @override
  MainState createState() => new MainState();
}

class MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Container(
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[new Text('メイン', style: new TextStyle(color: Colors.white, fontSize: 36.0, fontWeight: FontWeight.bold))],
          ),
        ),
      ),
    );
  }
}

class SampleTabItem extends StatelessWidget {
  final String title;
  final Color color;

  SampleTabItem(this.title, this.color) : super();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[new Text(this.title, style: new TextStyle(color: Colors.white, fontSize: 36.0, fontWeight: FontWeight.bold))],
          ),
        ),
      ),
    );
  }
}
