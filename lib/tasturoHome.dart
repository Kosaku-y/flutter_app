import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Majong Matching App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}


class Home extends StatefulWidget {
  @override
  _Home createState() => new _Home();
}

class _Home extends State<Home> {

  PageController _pageController;
  int currentIndex       = 0;
  int _page              = 0;
  String tab_home        = 'HOME';
  String tab_search      = 'Search';
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
    _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 1),
        curve: Curves.ease
    );
  }

  void onPageChanged(int page) {
    if(this.mounted){
      setState((){
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
                  builder: (context) => AccountPage(),
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
        type: BottomNavigationBarType.fixed, // 4つ以上BottomNavigationBarを使うときには必要らしい
      ),
    );
  }
}

class TabItem extends StatelessWidget {
  final title;

  const TabItem(this.title): super();

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
  final _mainReference = FirebaseDatabase.instance.reference().child("gmail");
  String message;
  List entries = new List();
  int cnt = 0;
  List aa = ['gmail : ', 'user name : ', 'age : '];

  @override
  initState() {
    super.initState();
    _mainReference.onChildAdded.listen(_onEntryAdded);
  }

  _onEntryAdded(Event e) {
    if(this.mounted){
      setState(() {
        if(e.snapshot.key == 'gmail_address') {
          entries.add(e.snapshot.key + ' : ' + e.snapshot.value + "@gmail.com");
        } else if(e.snapshot.key == 'sex') {
          if(e.snapshot.value == '1') {
            entries.add(e.snapshot.key + ' : ' + 'man');
          } else if(e.snapshot.value == '2'){
            entries.add(e.snapshot.key + ' : ' + 'woman');
          } else {
            entries.add(e.snapshot.key + ' : ' + 'else');
          }
        } else {
          entries.add(e.snapshot.key + ' : ' + e.snapshot.value);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context){
    //_mainReference.onChildAdded.listen(_onEntryAdded);
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return _buildRow(index);
      },
      itemCount: entries.length,
    );
  }

  Widget _buildRow(int index) {
    return Card(
      child: ListTile(
        title: Text(entries[index]),
      ),
    );
  }
}

class AccountPage extends StatefulWidget {
  @override
  _AccountPage createState() => new _AccountPage();
}

class _AccountPage extends State<AccountPage> {

  final title = 'Account';

  String _type = '1';
  String _sex = '0';
  int count = 0;

  final userNameInputController = TextEditingController();
  final userAgeInputController = TextEditingController();
  final userLineIdInputController = TextEditingController();
  final userGmailInputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _handleRadio(String e) =>
      setState(()
      //ラジオボタンを操作するときに使う
      {
        _type = e;
        _sex = e;
      });

  void submit() {
    var user_name = userNameInputController.text;
    var user_age = userAgeInputController.text;
    var user_lineid = userLineIdInputController.text;
    var user_gmail = userGmailInputController.text.replaceAll(
        RegExp(r'@[A-Za-z]+.[A-Za-z]+'), ''); // .をfirst keyに使えないから@以下を消している

    FirebaseDatabase.instance.reference().child("User").child("gmail").set(
        {
          'gmail_address': user_gmail,
          'user_name': user_name,
          'age': user_age,
          'sex': _sex,
          'line_id': user_lineid,
        }
    );

    /*
        FirebaseDatabase.instance.reference().child(user_gmail).set(
                {
                    "age": user_age,
                    "sex": user_age,
                    "evaluation": "4",
                    "lineid": user_lineid,
                    "messages" : {
                        "foo" : {
                            "3419-3419-01" : "hello",
                            "213-32139-01" : "goodbye"
                        }
                    }
                }
        );
        */

    //userNameInputController.clear(); // 送信した後テキストフォームの文字をクリア
    print('finish register.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        backgroundColor: Colors.green,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          child: Column(
            children: [
              TextFormField(
                controller: userGmailInputController,
                decoration: InputDecoration(
                  labelText: 'Enter your gmail address',
                ),
                validator: (value) {
                  return value.isEmpty
                      ? 'You must enter your gmail address.'
                      : null;
                },
              ),
              TextFormField(
                controller: userNameInputController,
                decoration: InputDecoration(
                  labelText: 'Enter your username',
                ),
                validator: (value) {
                  return value.isEmpty
                      ? 'You must enter your gmail address.'
                      : null;
                },
              ),
              TextFormField(
                controller: userAgeInputController,
                decoration: InputDecoration(
                  labelText: 'Enter your age',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: RadioListTile(
                      activeColor: Colors.blue,
                      controlAffinity: ListTileControlAffinity.trailing,
                      title: Text('male'),
                      value: '1',
                      groupValue: _type,
                      onChanged: _handleRadio,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      activeColor: Colors.blue,
                      controlAffinity: ListTileControlAffinity.trailing,
                      title: Text('female'),
                      value: '2',
                      groupValue: _type,
                      onChanged: _handleRadio,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      activeColor: Colors.blue,
                      controlAffinity: ListTileControlAffinity.trailing,
                      title: Text('else'),
                      value: '3',
                      groupValue: _type,
                      onChanged: _handleRadio,
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: userLineIdInputController,
                decoration: InputDecoration(
                  labelText: 'Enter line ID',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: IconButton(
                        icon: Icon(Icons.keyboard_return),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => Home(),
                            ),
                          );
                        }
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          this._formKey.currentState.save();
                          //Scaffold.of(context)
                          //    .showSnackBar(SnackBar(content: Text('Processing Data')));
                          submit();
                          //Navigator.of(context).pop(true);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => Home(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}