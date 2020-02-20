import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app2/Entity/PageParts.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:flutter_cupertino_data_picker/flutter_cupertino_data_picker.dart';

import '../main.dart';

class AccountSettingPage extends StatefulWidget {
  User user;
  String status;

  AccountSettingPage({Key key, @required this.user, @required this.status}) : super(key: key);

  @override
  _AccountSettingPageState createState() => new _AccountSettingPageState();
}

class _AccountSettingPageState extends State<AccountSettingPage> {
  final title = 'Account';
  PageParts set = PageParts();
  var mainReference = FirebaseDatabase.instance.reference().child("User");

  TextEditingController _nameInputController = new TextEditingController(text: '');
  TextEditingController _ageInputController = new TextEditingController(text: '');
  TextEditingController _sexInputController = new TextEditingController(text: '');

  final _formKey = GlobalKey<FormState>();

  final entries = {};
  int count = 0;

  @override
  initState() {
    super.initState();
    if (widget.status == "regist") {
      setState(() {});
    } else {}
  }

  void submit(String address) async {
    User user = widget.user;
    user.name = _nameInputController.text;
    user.age = _ageInputController.text;
    user.sex = _sexInputController.text;
    user.rank = "0";

    if (widget.status == "regist") {
      await mainReference.child("Gmail").child(address).set(user.toJson());

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          settings: const RouteSettings(name: "/main"),
          builder: (context) => MainPage(user: user, message: "登録完了しました"),
        ),
      );
    } else {}

    //userNameInputController.clear(); // 送信した後テキストフォームの文字をクリア
    print('finish register.');
  }

  List ageList() {
    List tmp = [];
    for (int i = 18; i <= 100; i++) {
      tmp.add(i.toString());
    }
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("初回登録", style: TextStyle(color: set.pointColor)),
        backgroundColor: set.baseColor,
        actions: [],
      ),
      backgroundColor: set.backGroundColor,
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(40.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                userName(),
                agePicker(),
                sexPicker(),
                FlatButton(
                  child: Text("登録(ホームへ)"),
                  textColor: Colors.white,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      this._formKey.currentState.save();
                      submit(widget.user.userId);
                    }
                  },
                ),
                FlatButton(
                  child: Text("キャンセル"),
                  textColor: Colors.white,
                  onPressed: () {
                    print("not set");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget userName() {
    return new Container(
      child: new TextFormField(
          style: TextStyle(color: set.pointColor),
          decoration: InputDecoration(
            icon: Icon(
              Icons.note, //変更必要
              color: set.fontColor,
            ),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
                borderSide: BorderSide(color: set.fontColor, width: 3.0)),
            hintText: 'userName',
            labelText: 'ユーザーネーム',
            labelStyle: TextStyle(color: set.fontColor),
          ),
          onSaved: (String value) {
            _nameInputController.text = value;
          }),
    );
  }

  Widget agePicker() {
    return InkWell(
      onTap: () {
        DataPicker.showDatePicker(
          context,
          showTitleActions: true,
          locale: 'en',
          datas: ageList(),
          title: 'age',
          onConfirm: (value) {
            if (value != "") {
              setState(() {
                _ageInputController.text = value;
              });
            }
          },
        );
      },
      child: AbsorbPointer(
        child: new TextFormField(
          style: TextStyle(color: set.pointColor),
          enableInteractiveSelection: false,
          controller: _ageInputController,
          decoration: InputDecoration(
            icon: Icon(
              IconData(57959, fontFamily: 'MaterialIcons'),
              color: set.fontColor,
            ),
            hintText: '年齢を選択してください',
            labelText: '年齢',
            labelStyle: TextStyle(color: set.fontColor),
            contentPadding: const EdgeInsets.only(left: 20.0, bottom: 10.0),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
                borderSide: BorderSide(color: set.fontColor, width: 3.0)),
          ),
        ),
      ),
    );
  }

  Widget sexPicker() {
    return InkWell(
      onTap: () {
        DataPicker.showDatePicker(
          context,
          showTitleActions: true,
          locale: 'en',
          datas: ['男性', '女性', 'その他'],
          title: '性別',
          onConfirm: (value) {
            if (value != "") {
              setState(() {
                _sexInputController.text = value;
              });
            }
          },
        );
      },
      child: AbsorbPointer(
        child: new TextFormField(
          style: TextStyle(color: set.pointColor),
          enableInteractiveSelection: false,
          controller: _sexInputController,
          decoration: InputDecoration(
            icon: Icon(
              Icons.wc,
              color: set.fontColor,
            ),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
                borderSide: BorderSide(color: set.fontColor, width: 3.0)),
            hintText: '性別を選択してください',
            labelText: '性別',
            labelStyle: TextStyle(color: set.fontColor),
            contentPadding: const EdgeInsets.only(left: 20.0, bottom: 10.0),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
