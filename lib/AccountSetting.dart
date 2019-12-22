import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_cupertino_data_picker/flutter_cupertino_data_picker.dart';
import 'Entity.dart';
import 'main.dart';

class AccountPage extends StatefulWidget {
  User user;
  String status;

  AccountPage(this.user, this.status);
  @override
  _AccountPage createState() => new _AccountPage();
}

class _AccountPage extends State<AccountPage> {
  final title = 'Account';
  PageParts set = PageParts();
  var mainReference = FirebaseDatabase.instance.reference().child("User");

  //送信用変数
  String _userName;
  String _userAge;
  String _userLineId;
  String _userSex;

  TextEditingController _userNameInputController = new TextEditingController(text: '');
  TextEditingController _userAgeInputController = new TextEditingController(text: '');
  TextEditingController _userLineIdInputController;
  //TextEditingController userGmailInputController;
  TextEditingController _userSexInputController = new TextEditingController(text: '');

  final _formKey = GlobalKey<FormState>();

  final entries = {};
  int count = 0;

  @override
  initState() {
    if (widget.status == "regist") {
      setState(() {});
    } else {}
  }

  setTextEditingController() {
    print(count);
    if (count == 1) {
      _userNameInputController = new TextEditingController(text: entries['user_name'] != null ? entries['user_name'] : '');
      _userAgeInputController = new TextEditingController(text: entries['age'] != null ? entries['age'] : '');
      _userSexInputController = new TextEditingController(text: entries['sex'] != null ? entries['sex'] : '');
    }
    count += 1;
  }

  void submit(String address) async {
    User user = User();
    user.name = _userName;
    user.age = _userAge;
    user.sex = _userSex;
    user.mail = address;

    if (widget.status == "regist") {
      await mainReference.child("Gmail").child(address).set(user.toJson());

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Home(user, "登録完了しました"),
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
        actions: [
          FlatButton(
            child: Text("Save"),
            color: Colors.green,
            textColor: Colors.white,
            onPressed: () {
              if (_formKey.currentState.validate()) {
                this._formKey.currentState.save();
                submit(widget.user.mail);
              }
            },
          ),
          /*キャンセルボタン
          leading: FlatButton(
            padding: EdgeInsets.only(left: 10.0),
            child: Text("Cancel"),
            color: Colors.green,
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Main(widget.userAddress),
                ),
              );
            },
          ),
          */
        ],
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
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                ),
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
            enabledBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(1.0), borderSide: BorderSide(color: set.fontColor, width: 3.0)),
            hintText: 'userName',
            labelText: 'ユーザーネーム',
            labelStyle: TextStyle(color: set.fontColor),
          ),
          onSaved: (String value) {
            _userNameInputController.text = value;
            _userName = value;
          }),
    );
  }

  Widget agePicker() {
    return GestureDetector(
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
                _userAgeInputController.text = value;
                _userAge = value;
              });
            }
          },
        );
      },
      child: AbsorbPointer(
        child: new TextFormField(
          style: TextStyle(color: set.pointColor),
          enableInteractiveSelection: false,
          controller: _userAgeInputController,
          decoration: InputDecoration(
            icon: Icon(
              IconData(57959, fontFamily: 'MaterialIcons'),
              color: set.fontColor,
            ),
            hintText: 'Choose your age',
            labelText: '年齢',
            labelStyle: TextStyle(color: set.fontColor),
            contentPadding: const EdgeInsets.only(left: 20.0, bottom: 10.0),
            enabledBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(1.0), borderSide: BorderSide(color: set.fontColor, width: 3.0)),
          ),
        ),
      ),
    );
  }

  Widget sexPicker() {
    return GestureDetector(
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
                _userSexInputController.text = value;
                _userSex = value;
              });
            }
          },
        );
      },
      child: AbsorbPointer(
        child: new TextFormField(
          style: TextStyle(color: set.pointColor),
          enableInteractiveSelection: false,
          controller: _userSexInputController,
          decoration: InputDecoration(
            icon: Icon(
              Icons.wc,
              color: set.fontColor,
            ),
            enabledBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(1.0), borderSide: BorderSide(color: set.fontColor, width: 3.0)),
            hintText: 'Choose your sex',
            labelText: '性別',
            labelStyle: TextStyle(color: set.fontColor),
            contentPadding: const EdgeInsets.only(left: 20.0, bottom: 10.0),
          ),
        ),
      ),
    );
  }
}
