import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Entity.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => new _Home();
}

class _Home extends State<Home> {
  PageController _pageController;
  int currentIndex = 0;
  int _page = 0;
  String tab_home = 'HOME';
  String tab_search = 'Search';
  String tab_recruitment = 'Recruitment';

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onTabTapped(int index) {
    currentIndex = index;
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 1), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    if (this.mounted) {
      setState(() {
        this._page = page;
      });
    }
  }

  // 画面全体のビルド
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('雀士マッチングアプリ'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => AccountPage("regist",user),
                ),
              );
            },
          ),
        ],
        backgroundColor: Colors.green,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: [
          // 各々が作った画面をここに書く
          TabItem(tab_home),
          TabItem(tab_search),
          TabItem(tab_recruitment),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(tab_home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text(tab_search),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            title: Text(tab_recruitment),
          ),
        ],
        type: BottomNavigationBarType
            .fixed, // 4つ以上BottomNavigationBarを使うときには必要らしい
      ),
    );
  }
}

class TabItem extends StatelessWidget {
  final title;

  const TabItem(this.title) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: TabItemChild(),
      ),
    );
  }
}

class TabItemChild extends StatefulWidget {
  @override
  _TabItemChild createState() => new _TabItemChild();
}

class _TabItemChild extends State<TabItemChild> {
  final _mainReference = FirebaseDatabase.instance.reference().child("User");
  String message;
  User user;
  int cnt = 0;
  List aa = ['gmail : ', 'user name : ', 'age : '];

  @override
  initState() {
    super.initState();
//    _mainReference.onChildAdded.listen(_onEntryAdded);
  }

  void registUser(){

  }

//  _onEntryAdded(Event e) {
//    if (this.mounted) {
//      setState(() {
//        if (e.snapshot.key == 'gmail_address') {
//          entries.add(e.snapshot.key + ' : ' + e.snapshot.value + "@gmail.com");
//        } else if (e.snapshot.key == 'sex') {
//          if (e.snapshot.value == '1') {
//            entries.add(e.snapshot.key + ' : ' + 'man');
//          } else if (e.snapshot.value == '2') {
//            entries.add(e.snapshot.key + ' : ' + 'woman');
//          } else {
//            entries.add(e.snapshot.key + ' : ' + 'else');
//          }
//        } else {
//          entries.add(e.snapshot.key + ' : ' + e.snapshot.value);
//        }
//      });
//    }
  @override
  Widget build(BuildContext context) {
    //_mainReference.onChildAdded.listen(_onEntryAdded);
    return Scaffold(
        body:
    );
  }


}
