import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app2/Bloc/EventManageBloc.dart';
import 'package:flutter_app2/Entity/EventPlace.dart';
import 'package:flutter_app2/Entity/EventSearch.dart';
import 'package:flutter_app2/PageParts.dart';
import 'package:flutter_app2/Entity/User.dart';
import '../../CommonData.dart';
import 'EventCreateScreen.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'EventSearchResultScreen.dart';

/*----------------------------------------------

イベント検索フォームScreenクラス

----------------------------------------------*/

class EventManageScreen extends StatefulWidget {
  final User user;
  EventManageScreen({Key key, this.user}) : super(key: key);
  State<StatefulWidget> createState() => EventManageScreenState();
}

class EventManageScreenState extends State<EventManageScreen> {
  final PageParts _parts = new PageParts();
  final _formKey = GlobalKey<FormState>();

  //validate用
  static const int init = 0;
  static const int changed = 1;
  static const int error = 2;

  Pref pref;
  Line line;
  Station station;
  String _eventId;
  int changePref = init;
  int changeLine = init;
  int changeStation = init;
  Map _lineMap = Map<String, String>();
  Map _stationMap = Map<String, String>();
  EventManageBloc _bloc = EventManageBloc();
  int _selectedPref = 0;
  int _selectedLine = 0;
  int _selectedStation = 0;

  TextEditingController _prefController = TextEditingController(text: " ");
  TextEditingController _lineController = TextEditingController(text: " ");
  TextEditingController _stationController = TextEditingController(text: " ");
  TextEditingController _eventIdController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _parts.appBar(title: "イベント検索"),
      backgroundColor: _parts.backGroundColor,
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(40.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text("検索条件を入力してください", style: _parts.guideWhite),
                _prefPicker(),
                _linePicker(),
                _stationPicker(),
                Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: _parts.iconButton(message: "検索", icon: Icons.search, onPressed: _submit),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _parts.floatButton(
          icon: Icons.person_add,
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push<Widget>(
              MaterialPageRoute(
                settings: const RouteSettings(name: "/EventCreate"),
                builder: (context) => EventCreateScreen(user: widget.user, mode: 0),
                fullscreenDialog: true,
              ),
            );
          }),
    );
  }

  //フォーム送信用メソッド
  void _submit() {
    if (this._formKey.currentState.validate()) {
      if (_eventId != null) {
      } else {
        Navigator.push(
          this.context,
          MaterialPageRoute(
            settings: const RouteSettings(name: "/EventSearchResult"),
            builder: (context) => new EventSearchResultScreen(
                user: widget.user,
                eventSearch: EventSearch(
                    pref: _prefController.text == " " ? null : _prefController.text,
                    line: _lineController.text == " " ? null : _lineController.text,
                    station: _stationController.text == " " ? null : _stationController.text)),
          ),
        );
      }
    }
  }

  //都道府県Picker
  Widget _prefPicker() {
    return new InkWell(
      onTap: () {
        _parts
            .picker(
              adapter: PickerDataAdapter<String>(pickerdata: CommonData.pref.keys.toList()),
              selected: _selectedPref, //初期値
              onConfirm: (Picker picker, List value) {
                var newData = picker.getSelectedValues()[0].toString();
                if (_prefController.text != newData) {
                  setState(() {
                    _selectedPref = picker.selecteds[0];
                    _prefController.text = newData;
                    if (newData != " ") _bloc.callLineApi(CommonData.pref[newData]);
                    _prefChange();
                  });
                }
              },
            )
            .showModal(this.context);
      },
      child: AbsorbPointer(
        child: new TextFormField(
          style: TextStyle(color: Colors.white),
          enableInteractiveSelection: false,
          controller: _prefController,
          decoration: InputDecoration(
            icon: Icon(Icons.place, color: _parts.fontColor),
            hintText: 'Choose a prefecture',
            labelText: '都道府県',
            labelStyle: TextStyle(color: _parts.fontColor),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
                borderSide: BorderSide(color: _parts.fontColor, width: 3.0)),
          ),
          validator: (value) => changePref == error ? "再選択してください" : null,
        ),
      ),
    );
  }

  //路線Picker
  Widget _linePicker() {
    List _lineData = [""];
    return StreamBuilder<Map<String, String>>(
        stream: _bloc.lineMapStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text("エラーが発生しました。");
          if (!snapshot.hasData) {
            return _lineTextFormField();
          } else {
            if (snapshot.data == null || snapshot.data.isEmpty) {
              return Text("データが空です。");
            } else {
              _lineMap = snapshot.data;
              _lineData = _lineMap.keys.toList();
              return new InkWell(
                onTap: () {
                  _parts
                      .picker(
                        adapter: PickerDataAdapter<String>(pickerdata: _lineData),
                        selected: _selectedLine, //初期値
                        onConfirm: (Picker picker, List value) {
                          var newData = picker.getSelectedValues()[0].toString();
                          if (_lineController.text != newData) {
                            setState(() {
                              _selectedLine = picker.selecteds[0];
                              _lineController.text = newData;
                              if (newData != " ") _bloc.callStationApi(_lineMap[newData]);
                              _lineChange();
                            });
                          }
                        },
                      )
                      .showModal(this.context);
                },
                child: AbsorbPointer(
                  child: _lineTextFormField(),
                ),
              );
            }
          }
        });
  }

  Widget _lineTextFormField() {
    return new TextFormField(
      style: TextStyle(color: Colors.white),
      enableInteractiveSelection: false,
      controller: _lineController,
      decoration: InputDecoration(
        icon: Icon(
          Icons.train,
          color: _parts.fontColor,
        ),
        hintText: 'Choose a line',
        labelText: '路線',
        labelStyle: TextStyle(color: _parts.fontColor),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(1.0),
          borderSide: BorderSide(color: _parts.fontColor, width: 3.0),
        ),
      ),
      validator: (String value) {
        if ((value != " " && _prefController.text == " ") ||
            (value == " " && _stationController.text != " ")) {
          return '再選択してください';
        }
        if (changeLine == error) {
          if (_lineController.text == " ") return null;
          return '再選択してください';
        } else {
          return null;
        }
      },
    );
  }

  //駅Picker
  Widget _stationPicker() {
    List _stationData = [""];
    return StreamBuilder<Map<String, String>>(
        stream: _bloc.stationMapStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return _stationTextFormField();
          } else if (snapshot.hasError) {
            return Text("エラーが発生しました。");
          } else {
            if (snapshot.data == null || snapshot.data.isEmpty) {
              return Text("データが空です。");
            } else {
              _stationMap = snapshot.data;
              _stationData = _stationMap.keys.toList();
              return InkWell(
                onTap: () {
                  _parts
                      .picker(
                        adapter: PickerDataAdapter<String>(pickerdata: _stationData),
                        selected: _selectedStation, //初期値
                        onConfirm: (Picker picker, List value) {
                          var newData = picker.getSelectedValues()[0].toString();
                          if (_stationController.text != newData) {
                            setState(() {
                              _selectedStation = picker.selecteds[0];
                              _stationController.text = newData;
                              _stationChange();
                            });
                          }
                        },
                      )
                      .showModal(this.context);
                },
                child: AbsorbPointer(
                  child: _stationTextFormField(),
                ),
              );
            }
          }
        });
  }

  Widget _stationTextFormField() {
    return new TextFormField(
      style: TextStyle(color: Colors.white),
      enableInteractiveSelection: false,
      controller: _stationController,
      decoration: InputDecoration(
        icon: Icon(Icons.subway, color: _parts.fontColor),
        hintText: 'Choose a station',
        labelText: '駅名',
        labelStyle: TextStyle(color: _parts.fontColor),
        enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(1.0),
            borderSide: BorderSide(color: _parts.fontColor, width: 3.0)),
      ),
      validator: (String value) {
        if ((value != " " && _prefController.text == " ") ||
            (value != " " && _lineController.text == " ")) {
          return '再選択してください';
        }
        if (changeStation == error) {
          if (_stationController.text == " ") return null;
          return '再選択してください';
        } else {
          return null;
        }
      },
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
          labelStyle: TextStyle(color: _parts.fontColor),
          enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(1.0),
              borderSide: BorderSide(color: _parts.fontColor, width: 3.0)),
        ),
//        validator: (String value) {
//          return null;
//        },
        onSaved: (String value) {
          _eventId = value;
        });
  }

  //県Pickerが選択された時の処理メソッド
  void _prefChange() {
    changePref = changed;
    //県、路線、駅、組み合わせ矛盾チェック
    if (changeLine != init || changeStation != init) {
      changeLine = error;
      changeStation = error;
    }
  }

  //路線チェンジ用
  void _lineChange() {
    //県、路線、駅、組み合わせ矛盾チェック
    if (changeLine == init) {
      changeLine = 1;
    } else if (changeLine == changed) {
      if (changeStation != init) {
        changeStation = error;
      }
    } else {
      changeLine = changed;
    }
  }

  //路線チェンジ用
  void _stationChange() {
    changeStation = changed;
  }

  @override
  void dispose() {
    super.dispose();
    _prefController.dispose();
    _lineController.dispose();
    _stationController.dispose();
    _eventIdController.dispose();
    _bloc.dispose();
  }
}
