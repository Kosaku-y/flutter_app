import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app2/Entity/PageParts.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:flutter_app2/Repository/LoginRepository.dart';
import 'package:flutter_app2/Repository/UserDataRepository.dart';
import 'package:flutter_picker/flutter_picker.dart';

import '../main.dart';
import 'LoginPage.dart';

class AccountRegisterPage extends StatefulWidget {
  final User user;
  AccountRegisterPage({Key key, @required this.user}) : super(key: key);

  @override
  _AccountRegisterPageState createState() => new _AccountRegisterPageState();
}

class _AccountRegisterPageState extends State<AccountRegisterPage> {
  PageParts set = PageParts();
  TextEditingController _nameInputController = new TextEditingController(text: '');
  TextEditingController _ageInputController = new TextEditingController(text: '');
  TextEditingController _sexInputController = new TextEditingController(text: '');

  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
  }

  void submit(String userId) async {
    User user = widget.user;
    user.name = _nameInputController.text;
    user.age = _ageInputController.text;
    user.sex = _sexInputController.text;
    user.rank = "0";
    UserDataRepository repository = UserDataRepository();
    await repository.registerUser(user);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        settings: const RouteSettings(name: "/main"),
        builder: (context) => MainPage(user: user, message: "登録完了しました"),
      ),
    );
    print('finish register');
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
                userNameField(),
                agePicker(),
                sexPicker(),
                set.iconButton(
                  message: "登録(ホームへ)",
                  icon: Icons.check,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      this._formKey.currentState.save();
                      submit(widget.user.userId);
                    }
                  },
                ),
                set.backButton(
                  onPressed: () {
                    LoginRepository repository = LoginRepository();
                    repository.signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        settings: const RouteSettings(name: "/Login"),
                        builder: (BuildContext context) => LoginPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget userNameField() {
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
        set
            .picker(
                adapter: NumberPickerAdapter(data: [NumberPickerColumn(begin: 18, end: 99)]),
                selecteds: [0], //初期値
                onConfirm: (Picker picker, List value) {
                  print(value.toString());
                  print(picker.getSelectedValues());
                  if (value.toString() != "") {
                    setState(() {
                      _ageInputController.text = picker.getSelectedValues()[0].toString();
                    });
                  }
                })
            .showModal(this.context);
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
        set
            .picker(
              adapter: PickerDataAdapter<String>(pickerdata: ['男性', '女性', 'その他']),
              selecteds: [0], //初期値
              onConfirm: (Picker picker, List value) {
                if (value.toString() != "") {
                  setState(() {
                    _sexInputController.text = picker.getSelectedValues()[0].toString();
                  });
                }
              },
            )
            .showModal(this.context);
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
    _nameInputController.dispose();
    _ageInputController.dispose();
    _sexInputController.dispose();
    super.dispose();
  }
}
