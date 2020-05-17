import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app2/Util/ScreenParts.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:flutter_app2/Repository/LoginRepository.dart';
import 'package:flutter_app2/Repository/UserDataRepository.dart';
import 'package:flutter_picker/flutter_picker.dart';

import '../../main.dart';
import 'LoginScreen.dart';

/*----------------------------------------------

アカウント登録Screenクラス

----------------------------------------------*/

class AccountRegisterScreen extends StatefulWidget {
  final User user;
  AccountRegisterScreen({Key key, @required this.user}) : super(key: key);
  @override
  _AccountRegisterScreenState createState() => new _AccountRegisterScreenState();
}

class _AccountRegisterScreenState extends State<AccountRegisterScreen> {
  final ScreenParts _parts = ScreenParts();
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameInputController = new TextEditingController(text: '');
  TextEditingController _ageInputController = new TextEditingController(text: '');
  TextEditingController _sexInputController = new TextEditingController(text: '');

  @override
  initState() {
    super.initState();
  }

  void submit(String userId) async {
    User user = widget.user;
    user.setName = _nameInputController.text;
    user.setAge = _ageInputController.text;
    user.setSex = _sexInputController.text;
    UserDataRepository repository = UserDataRepository();
    await repository.registerUser(user);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        settings: const RouteSettings(name: "/Main"),
        builder: (context) => MainScreen(user: user, message: "登録完了しました"),
      ),
    );
    print('Register finished');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _parts.appBar(title: "初回登録"),
      backgroundColor: _parts.backGroundColor,
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
                _parts.iconButton(
                  message: "登録",
                  icon: Icons.check,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      this._formKey.currentState.save();
                      submit(widget.user.userId);
                    }
                  },
                ),
                _parts.iconButton(
                  message: "戻る",
                  icon: Icons.keyboard_backspace,
                  onPressed: () {
                    LoginRepository repository = LoginRepository();
                    repository.signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        settings: const RouteSettings(name: "/Login"),
                        builder: (BuildContext context) => LoginScreen(),
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
          style: TextStyle(color: _parts.pointColor),
          decoration: InputDecoration(
            icon: Icon(Icons.account_circle, color: _parts.fontColor),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
                borderSide: BorderSide(color: _parts.fontColor, width: 3.0)),
            hintText: 'userName',
            labelText: 'ユーザーネーム',
            labelStyle: TextStyle(color: _parts.fontColor),
          ),
          onSaved: (String value) => _nameInputController.text = value,
          validator: (String value) {
            if (value.isEmpty) return '必須項目です';

            ///Todo 文字数
            return null;
          }),
    );
  }

  Widget agePicker() {
    return InkWell(
      onTap: () {
        _parts
            .picker(
                adapter: NumberPickerAdapter(data: [NumberPickerColumn(begin: 18, end: 99)]),
                selected: 0, //初期値
                onConfirm: (Picker picker, List value) {
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
          style: TextStyle(color: _parts.pointColor),
          enableInteractiveSelection: false,
          controller: _ageInputController,
          decoration: InputDecoration(
            icon: Icon(IconData(57959, fontFamily: 'MaterialIcons'), color: _parts.fontColor),
            hintText: '年齢を選択してください',
            labelText: '年齢',
            labelStyle: TextStyle(color: _parts.fontColor),
            contentPadding: const EdgeInsets.only(left: 20.0, bottom: 10.0),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
                borderSide: BorderSide(color: _parts.fontColor, width: 3.0)),
          ),
        ),
      ),
    );
  }

  Widget sexPicker() {
    return InkWell(
      onTap: () {
        _parts
            .picker(
              adapter: PickerDataAdapter<String>(pickerdata: [' ', '男性', '女性', 'その他']),
              selected: 0, //初期値
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
          style: TextStyle(color: _parts.pointColor),
          enableInteractiveSelection: false,
          controller: _sexInputController,
          decoration: InputDecoration(
            icon: Icon(Icons.wc, color: _parts.fontColor),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
                borderSide: BorderSide(color: _parts.fontColor, width: 3.0)),
            hintText: '性別を選択してください',
            labelText: '性別',
            labelStyle: TextStyle(color: _parts.fontColor),
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
