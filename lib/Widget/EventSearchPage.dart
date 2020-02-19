import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app2/Entity/EventPlace.dart';
import 'package:flutter_app2/Entity/PageParts.dart';
import 'package:flutter_cupertino_data_picker/flutter_cupertino_data_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_app2/Widget/EventSerchResultPage.dart';

import 'RecritmentPage.dart';

/*----------------------------------------------

イベント検索フォームページクラス

----------------------------------------------*/
class EventManagePage extends StatefulWidget {
  @override
  EventManagePage({Key key}) : super(key: key);

  State<StatefulWidget> createState() {
    return new EventManagePageState();
  }
}

class EventManagePageState extends State<EventManagePage> {
  PageParts set = new PageParts();
  final _formKey = GlobalKey<FormState>();

  List lineData = [""];
  List stationData = [""];
  Pref pref;
  Line line;
  Station station;
  String _selectPref;
  String _selectLine;
  String _selectStation;
  String _eventId;
  int changePref = 0;
  int changeLine = 0;
  int changeStation = 0;
  Map lineMap = new Map<String, String>();
  Map stationMap = new Map<String, String>();

  TextEditingController _prefController = new TextEditingController(text: '');
  TextEditingController _lineController = new TextEditingController(text: '');
  TextEditingController _stationController = new TextEditingController(text: '');
  TextEditingController _eventIdController = new TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: set.baseColor,
        title: Text('イベント検索',
            style: TextStyle(
              color: set.pointColor,
            )),
      ),
      backgroundColor: set.backGroundColor,
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              Text("検索条件を入力してください", style: TextStyle(color: set.fontColor)),
              _prefPicker(),
              _linePicker(),
              _stationPicker(),
              Container(
                padding: EdgeInsets.only(top: 20.0),
                child: RaisedButton.icon(
                  label: Text("検索する"),
                  icon: Icon(
                    Icons.search,
                    color: set.fontColor,
                  ),
                  onPressed: () => _submission(),
                ),
              ),
              RaisedButton.icon(
                label: Text("削除する"),
                icon: Icon(
                  Icons.delete,
                  color: set.fontColor,
                ),
                onPressed: () => null,
              ),
              RaisedButton.icon(
                label: Text("修正する"),
                icon: Icon(
                  Icons.check,
                  color: set.fontColor,
                ),
                onPressed: () => _correction(),
              ),
            ]),
          ),
        ),
      ),
      floatingActionButton: IconButton(
        icon: Icon(
          Icons.person_add,
          color: set.fontColor,
        ),
        onPressed: () => Navigator.of(
          context,
          rootNavigator: true,
        ).push<Widget>(
          MaterialPageRoute(builder: (context) {
            return RecruitmentPage(mode: 0);
          }

//        Navigator.push(
//          context,
//          MaterialPageRoute(
//            //settings: const RouteSettings(name: "/detail"),
//            builder: (context) {
//              return RecruitmentPage(mode: 0);
//            },
//            fullscreenDialog: true,
              ),
        ),
      ),
    );
  }

  //イベント修正
  void _correction() {}

  //フォーム送信用メソッド
  void _submission() {
    if (this._formKey.currentState.validate()) {
      if (_eventId != null) {
      } else {
        Navigator.push(
            this.context,
            MaterialPageRoute(
                // パラメータを渡す
                builder: (context) => new EventSearchResultPage(
                    pref: _selectPref, line: _selectLine, station: _selectStation)));
      }
    }
  }

  //都道府県Picker
  Widget _prefPicker() {
    return new InkWell(
      onTap: () {
        DataPicker.showDatePicker(
          context,
          showTitleActions: true,
          locale: 'en',
          datas: Pref.pref.keys.toList(),
          title: '都道府県',
          onConfirm: (value) {
            if (value != "") {
              setState(() {
                _prefController.text = value;
                _selectPref = value;
                _prefChange(value);
              });
            }
          },
        );
      },
      child: AbsorbPointer(
        child: new TextFormField(
          style: TextStyle(color: Colors.white),
          enableInteractiveSelection: false,
          controller: _prefController,
          decoration: InputDecoration(
            icon: Icon(
              Icons.place,
              color: set.fontColor,
            ),
            hintText: 'Choose a prefecture',
            labelText: '都道府県',
            labelStyle: TextStyle(color: set.fontColor),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
                borderSide: BorderSide(color: set.fontColor, width: 3.0)),
          ),
          validator: (String value) {
            if (changePref == 2) {
              return '再選択してください';
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }

  //路線Picker
  Widget _linePicker() {
    return new InkWell(
      onTap: () {
        DataPicker.showDatePicker(
          context,
          showTitleActions: true,
          locale: 'en',
          datas: lineData,
          title: '路線',
          onConfirm: (value) {
            if (value != "") {
              setState(() {
                _lineController.text = value;
                _lineChange(value);
              });
            }
          },
        );
      },
      child: AbsorbPointer(
        child: new TextFormField(
          style: TextStyle(color: Colors.white),
          enableInteractiveSelection: false,
          controller: _lineController,
          decoration: InputDecoration(
            icon: Icon(
              Icons.train,
              color: set.fontColor,
            ),
            hintText: 'Choose a line',
            labelText: '路線',
            labelStyle: TextStyle(color: set.fontColor),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
                borderSide: BorderSide(color: set.fontColor, width: 3.0)),
          ),
          validator: (String value) {
            if (changeLine == 2) {
              return '再選択してください';
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }

  //駅Picker
  Widget _stationPicker() {
    return new InkWell(
      onTap: () {
        DataPicker.showDatePicker(
          context,
          showTitleActions: true,
          locale: 'en',
          datas: stationData,
          title: '駅',
          onConfirm: (value) {
            if (value != "") {
              setState(() {
                _stationController.text = value;
                _selectStation = value;
                changeStation = 1;
              });
            }
          },
        );
      },
      child: AbsorbPointer(
        child: new TextFormField(
          style: TextStyle(color: Colors.white),
          enableInteractiveSelection: false,
          controller: _stationController,
          decoration: InputDecoration(
            icon: Icon(
              Icons.subway,
              color: set.fontColor,
            ),
            hintText: 'Choose a station',
            labelText: '駅名',
            labelStyle: TextStyle(color: set.fontColor),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
                borderSide: BorderSide(color: set.fontColor, width: 3.0)),
          ),
          validator: (String value) {
            if (changeStation == 2) {
              return '再選択してください';
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }

  //イベントIDで検索する用のテキストエリア (管理者用)
  Widget eventIdForm() {
    return new TextFormField(
        style: TextStyle(color: Colors.white),
        controller: _eventIdController,
        decoration: InputDecoration(
          icon: Icon(Icons.format_list_numbered),
          hintText: 'input eventID',
          labelText: 'イベントID(管理者用)',
          labelStyle: TextStyle(color: set.fontColor),
          enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(1.0),
              borderSide: BorderSide(color: set.fontColor, width: 3.0)),
        ),
        validator: (String value) {
          return null;
        },
        onSaved: (String value) {
          _eventId = value;
        });
  }

  //県Pickerが選択された時の処理メソッド
  Future _prefChange(String prefName) async {
    changePref = 1;
    //県、路線、駅、組み合わせ矛盾チェック
    if (changeLine != 0 || changeStation != 0) {
      changeLine = 2;
      changeStation = 2;
    }
    //APIコール
    String prefCode = Pref.pref[prefName];
    var url = "http://api.ekispert.jp/v1/json/operationLine?prefectureCode=" +
        "$prefCode&offset=1&limit=100&gcs=tokyo&key=LE_UaP7Vyjs3wQPa";
    http.Response response = await http.get(url);
    var body = response.body;
    Map<String, dynamic> responseMap = jsonDecode(body);
    lineMap.clear();
    responseMap["ResultSet"]["Line"].forEach((i) {
      lineMap[i["Name"]] = i["code"];
    });
    setState(() {
      lineData.clear();
      lineData = lineMap.keys.toList();
    });
  }

  //路線チェンジ用
  Future _lineChange(String lineName) async {
    //県、路線、駅、組み合わせ矛盾チェック
    if (changeLine == 0) {
      changeLine = 1;
    } else if (changeLine == 1) {
      if (changeStation != 0) {
        changeStation = 2;
      }
    } else {
      changeLine = 1;
    }
    String lineCode = lineMap[lineName];
    //APIコール
    var url = "http://api.ekispert.jp/v1/json/station?operationLineCode=" +
        "$lineCode&type=train&offset=1&limit=100&direction=up&gcs=tokyo&key=LE_UaP7Vyjs3wQPa";
    http.Response response = await http.get(url);
    var body = response.body;
    Map<String, dynamic> responseMap = jsonDecode(body);
    stationMap.clear();
    responseMap["ResultSet"]["Point"].forEach((i) {
      stationMap[i["Station"]["Name"]] = i["Station"]["code"];
    });

    setState(() {
      stationData.clear();
      stationData = stationMap.keys.toList();
    });
  }
}
