import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app2/Splash.dart';
import 'Entity/PageParts.dart';
import 'Entity/User.dart';
import 'Page/EventSearchPage.dart';
import 'Page/NewHomePage.dart';
import 'Page/SettingPage.dart';
import 'Page/TalkRoomPage.dart';

//ホーム画面のrun
void main() {
  //PageParts parts = PageParts();
  return runApp(
    new MaterialApp(
      title: "Home",
      home: new Splash(),
      //theme: parts.defaultTheme,
    ),
  );
}

/*----------------------------------------------

ホーム(MainPage)クラス

----------------------------------------------*/

class MainPage extends StatefulWidget {
  User user;
  String message; //前の画面からの遷移の場合はSnackBarで処理結果を表示する
  MainPage({Key key, @required this.user, @required this.message}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TabItem _currentTab = TabItem.NewHome;
  List<Widget> tabs;
  PageParts set = PageParts();
  Map<TabItem, GlobalKey<NavigatorState>> _navigatorKeys = {
    TabItem.NewHome: GlobalKey<NavigatorState>(),
    TabItem.EventManage: GlobalKey<NavigatorState>(),
    TabItem.RoomPage: GlobalKey<NavigatorState>(),
    TabItem.Setting: GlobalKey<NavigatorState>(),
  };

  void onSelect(TabItem tabItem) {
    //現在選択されているタブが選択された場合,最初までpop
    if (_currentTab == tabItem) {
      _navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentTab = tabItem;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    tabs = [
      Home(user: widget.user),
      EventManagePage(user: widget.user),
      TalkRoomPage(widget.user),
      SettingPage(user: widget.user),
    ];
  }

  Future<bool> onWillPop() async {
    final isFirstRoute = !await _navigatorKeys[_currentTab].currentState.maybePop();
    if (isFirstRoute) {
      if (_currentTab != TabItem.NewHome) {
        onSelect(TabItem.NewHome);
      }
      return false;
    }
    return isFirstRoute;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            _buildTabItem(
              TabItem.NewHome,
              '/NewHome',
            ),
            _buildTabItem(
              TabItem.EventManage,
              '/EventManage',
            ),
            _buildTabItem(
              TabItem.RoomPage,
              '/RoomPage',
            ),
            _buildTabItem(
              TabItem.Setting,
              '/Setting',
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigation(
          currentTab: _currentTab,
          onSelect: onSelect,
        ),
      ),
    );
  }

  Widget _buildTabItem(TabItem tabItem, String root) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TickerMode(
        enabled: _currentTab == tabItem,
        child: TabNavigator(
          navigationKey: _navigatorKeys[tabItem],
          tabItem: tabItem,
          routerName: root,
          user: widget.user,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
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
        '/NewHome': (context) => new Home(user: user),
        '/EventManage': (context) => new EventManagePage(user: user),
        '/RoomPage': (context) => new TalkRoomPage(user),
        '/Setting': (context) => new SettingPage(user: user)
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

BottomNavigationBarのWidgetクラス

----------------------------------------------*/

const tabTitle = <TabItem, String>{
  TabItem.NewHome: 'ホーム',
  TabItem.EventManage: 'イベント',
  TabItem.RoomPage: 'トーク',
  TabItem.Setting: '設定',
};
const tabIcon = <TabItem, IconData>{
  TabItem.NewHome: Icons.home,
  TabItem.EventManage: IconData(59574, fontFamily: 'MaterialIcons'),
  TabItem.RoomPage: Icons.message,
  TabItem.Setting: Icons.settings,
};

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    Key key,
    this.currentTab,
    this.onSelect,
  }) : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelect;

  @override
  Widget build(BuildContext context) {
    PageParts set = PageParts();
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        bottomItem(
          context,
          tabItem: TabItem.NewHome,
        ),
        bottomItem(
          context,
          tabItem: TabItem.EventManage,
        ),
        bottomItem(
          context,
          tabItem: TabItem.RoomPage,
        ),
        bottomItem(
          context,
          tabItem: TabItem.Setting,
        )
      ],
      type: BottomNavigationBarType.fixed,
      backgroundColor: set.baseColor,
//      fixedColor: set.fontColor,
//      unselectedItemColor: Colors.white,
      onTap: (index) {
        onSelect(TabItem.values[index]);
      },
    );
  }

  BottomNavigationBarItem bottomItem(
    BuildContext context, {
    TabItem tabItem,
  }) {
    PageParts set = PageParts();
    final color = currentTab == tabItem ? set.fontColor : Colors.white;
    return BottomNavigationBarItem(
      icon: Icon(
        tabIcon[tabItem],
        color: color,
      ),
      title: Text(
        tabTitle[tabItem],
        style: TextStyle(
          color: color,
        ),
      ),
    );
  }
}
