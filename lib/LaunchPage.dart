import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'EventSearch.dart';
import 'NewHome.dart';
import 'package:flutter_app2/Entity/Entity.dart';
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

BottomNavigationBar定義 enum

----------------------------------------------*/

enum TabItem {
  NewHome,
  EventManage,
  RoomPage,
  Setting,
}
/*----------------------------------------------

ホーム(BottomNavigationBar)クラス

----------------------------------------------*/

class LaunchPage extends StatefulWidget {
  @override
  User user;
  String message; //前の画面からの遷移の場合はSnackBarで処理結果を表示する
  LaunchPage({Key key, User user}) : super(key: key);

  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  int _currentIndex = 0;
  List<Widget> tabs;
  PageParts set = PageParts();
  Map<TabItem, GlobalKey<NavigatorState>> _navigatorKeys;

  final items = <BottomNavigationBarItem>[
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
  ];

  @override
  void initState() {
    super.initState();
    tabs = [
      NewHome(widget.user), //EventManage(key: PageStorageKey('EventManage'),),
      EventManagePage(),
      RoomPage(widget.user),
      SettingPage(widget.user), //SampleTabItem("messeage", Colors.black),
    ];

    _navigatorKeys = {
      TabItem.NewHome: GlobalKey<NavigatorState>(),
      TabItem.EventManage: GlobalKey<NavigatorState>(),
      TabItem.RoomPage: GlobalKey<NavigatorState>(),
      TabItem.Setting: GlobalKey<NavigatorState>(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('demo'),
      ),
      body: Stack(
        children: <Widget>[
          IndexedStack(
            index: _currentIndex,
            children: tabs,
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigator(context),
    );
  }

  Widget _buildBottomNavigator(BuildContext context) {
    return BottomNavigationBar(
      items: items,
      backgroundColor: set.baseColor,
      fixedColor: set.fontColor,
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.white,
      currentIndex: _currentIndex,
      onTap: (index) {
        if (_currentIndex != index) {
          setState(() {
            _currentIndex = index;
          });
        }
      },
    );
  }
}

class TabNavigator extends StatelessWidget {
  const TabNavigator(
      {Key key,
      @required this.tabItem,
      @required this.routerName,
      @required this.navigationKey,
      @required this.user})
      : super(key: key);

  final User user;
  final TabItem tabItem;
  final String routerName;
  final GlobalKey<NavigatorState> navigationKey;

  Map<String, Widget Function(BuildContext)> _routerBuilder(BuildContext context) => {
        '/NewHome': (context) => new NewHome(user),
        '/EventManage': (context) => new EventManagePage(),
        '/Room': (context) => new RoomPage(user),
        '/Setting': (context) => new SettingPage(user)
      };

  @override
  Widget build(BuildContext context) {
    final routerBuilder = _routerBuilder(context);

    return Navigator(
      key: navigationKey,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        return MaterialPageRoute<Widget>(
          builder: (context) {
            return routerBuilder[routerName](context);
          },
        );
      },
    );
  }
}
