import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app2/Bloc/EventManageBloc.dart';
import 'package:flutter_app2/CommonData.dart';
import 'package:flutter_app2/Entity/EventDetail.dart';
import 'package:flutter_app2/Entity/EventPlace.dart';

import 'package:flutter_app2/PageParts.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:intl/intl.dart';
import '../ReturnTopScreen.dart';

/*----------------------------------------------

イベント作成・編集フォームScreenクラス

----------------------------------------------*/
class EventCreateScreen extends StatefulWidget {
  final int mode;
  final User user;
  final EventDetail event;
  EventCreateScreen({Key key, this.user, this.mode, this.event}) : super(key: key);
  @override
  EventCreateScreenState createState() => new EventCreateScreenState();
}

class EventCreateScreenState extends State<EventCreateScreen> {
  final PageParts _parts = new PageParts();

  //遷移モード
  int _mode;
  static const int register = 0;
  static const int modify = 1;
  static const int loaded = 2;

  // 日時を指定したフォーマットで指定するためのフォーマッター
  var formatter = new DateFormat('yyyy年 M月d日(E) HH時mm分');
  EventManageBloc _bloc = EventManageBloc();
  List lineData = [""];
  List stationData = [""];

  //validate用
  static const int init = 0;
  static const int changed = 1;
  static const int error = 2;

  int changePref = 0;
  int changeLine = 0;
  int changeStation = 0;

  Map _lineMap = new Map<String, String>();
  Map _stationMap = new Map<String, String>();

  //表示用Controller
  TextEditingController _startingController;
  TextEditingController _endingController;
  TextEditingController _memberController;
  TextEditingController _prefController;
  TextEditingController _lineController;
  TextEditingController _stationController;
  TextEditingController _commentController;

  Line _line = Line();
  Station _station = Station();
  DateTime _start;
  DateTime _end;

  int _selectMemberIndex = 0;
  int _selectPrefIndex = 0;
  int _selectLineIndex = 0;
  int _selectStationIndex = 0;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _mode = widget.mode;
    if (_mode == register) {
      _startingController = new TextEditingController(text: '');
      _endingController = new TextEditingController(text: '');
      _memberController = new TextEditingController(text: '');
      _prefController = new TextEditingController(text: '');
      _lineController = new TextEditingController(text: '');
      _stationController = new TextEditingController(text: '');
      _commentController = new TextEditingController(text: '');
    } else {
      _bloc.callLineApi(CommonData.pref[widget.event.pref]);
      _selectPrefIndex = (CommonData.pref.keys.toList()).indexOf(widget.event.pref);
      _startingController = new TextEditingController(text: widget.event.startingTime);
      _endingController = new TextEditingController(text: widget.event.endingTime);
      _memberController = new TextEditingController(text: widget.event.recruitMember);
      _prefController = new TextEditingController(text: widget.event.pref);
      _lineController = new TextEditingController(text: widget.event.line);
      _stationController = new TextEditingController(text: widget.event.station);
      _commentController = new TextEditingController(text: widget.event.comment);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _parts.appBar(title: "イベント作成"),
      backgroundColor: _parts.backGroundColor,
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(40.0),
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              Text('募集条件を入力してください', style: TextStyle(color: _parts.fontColor)),
              _recruitMemberPicker(), //募集人数Picker
              _prefPicker(), //都道府県Picker
              _linePicker(), //路線Picker
              _stationPicker(), //駅名Picker
              _startTimePicker(), //開始日時Picker
              _endTimePicker(), //終了日時Picker
              _commentField(), //備考
              _parts.iconButton(
                  message: "募集する", icon: Icons.event_available, onPressed: () => _submission()),
              RaisedButton.icon(
                label: Text("検索ページへ戻る"),
                icon: Icon(Icons.search, color: _parts.fontColor),
                onPressed: () => Navigator.pop(context),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void _submission() {
    if (this._formKey.currentState.validate()) {
      this._formKey.currentState.save();
      EventDetail event = new EventDetail(
          _memberController.text,
          _lineController.text,
          _stationController.text,
          formatter.format(_start),
          formatter.format(_end),
          _commentController.text,
          widget.user.userId,
          widget.user.name);
      _line.name = _lineController.text;
      _station.name = _stationController.text;

      AwesomeDialog(
              context: context,
              headerAnimationLoop: false,
              animType: AnimType.TOPSLIDE,
              dialogType: DialogType.INFO,
              body: Column(children: <Widget>[
                Text("募集条件を確認して下さい。"),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("募集人数：${event.recruitMember}", style: TextStyle(color: Colors.black)),
                    Text("路線　　：${event.line}", style: TextStyle(color: Colors.black)),
                    Text("駅　　　：${event.station}", style: TextStyle(color: Colors.black)),
                    Text("開始時間：${event.startingTime}", style: TextStyle(color: Colors.black)),
                    Text("終了時間：${event.endingTime}", style: TextStyle(color: Colors.black)),
                  ],
                ),
              ]),
              btnOkOnPress: () => commit(event),
              btnCancelOnPress: () {},
              btnCancelText: "修正する",
              btnOkText: "募集する")
          .show();
    }
  }

  commit(event) async {
    _bloc.callCreateEvent(_station.code, event);
    var result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StreamBuilder<bool>(
          stream: _bloc.newEventStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              Navigator.pop(this.context, 0);
              return Container();
            }
            if (snapshot.connectionState != ConnectionState.active)
              return Container(child: _parts.indicator());
            if (!snapshot.hasData) {
              return Container();
            } else {
              Navigator.pop(this.context, 1);
              return Container();
            }
          },
        );
      },
    );
    if (result == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          settings: const RouteSettings(name: "/ReturnTop"),
          builder: (context) => ReturnTopScreen(message: "登録が完了しました。"),
        ),
      );
    }
  }

  //募集人数Picker
  Widget _recruitMemberPicker() {
    return new InkWell(
      onTap: () {
        _parts
            .picker(
                adapter: NumberPickerAdapter(data: [NumberPickerColumn(begin: 1, end: 4)]),
                selected: _selectMemberIndex, //初期値
                onConfirm: (Picker picker, List value) {
                  if (value.toString() != "") {
                    setState(() {
                      _memberController.text = picker.getSelectedValues()[0].toString();
                    });
                  }
                })
            .showModal(this.context);
      },
      child: AbsorbPointer(
        child: new TextFormField(
          style: TextStyle(color: _parts.pointColor),
          enableInteractiveSelection: false,
          controller: _memberController,
          decoration: InputDecoration(
            icon: Icon(Icons.people, color: _parts.fontColor),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
                borderSide: BorderSide(color: _parts.fontColor, width: 3.0)),
            labelText: '*募集人数',
            labelStyle: TextStyle(color: _parts.fontColor),
          ),
          validator: (String value) => value.isEmpty ? '必須項目です' : null,
        ),
      ),
    );
  }

  //都道府県Picker
  Widget _prefPicker() {
    //県Pickerが選択された時の処理メソッド
    void _prefChange() {
      changePref = changed;
      //県、路線、駅、組み合わせ矛盾チェック
      if (changeLine != init || changeStation != init) {
        changeLine = error;
        changeStation = error;
      }
    }

    return new InkWell(
      onTap: () {
        _parts
            .picker(
                adapter: PickerDataAdapter<String>(pickerdata: CommonData.pref.keys.toList()),
                selected: _selectPrefIndex, //初期値
                onConfirm: (Picker picker, List value) {
                  var newData = picker.getSelectedValues()[0].toString();
                  if (_prefController.text != newData) {
                    setState(() {
                      if (newData != " ") {
                        _selectStationIndex = 0;
                        _bloc.callLineApi(CommonData.pref[newData]);
                      } else {
                        _selectPrefIndex = picker.selecteds[0];
                      }
                      _prefController.text = newData;
                      _prefChange();
                    });
                  }
                })
            .showModal(this.context);
      },
      child: AbsorbPointer(
        child: new TextFormField(
          style: TextStyle(color: Colors.white),
          enableInteractiveSelection: false,
          controller: _prefController,
          decoration: InputDecoration(
            icon: Icon(Icons.place, color: _parts.fontColor),
            labelText: '都道府県',
            labelStyle: TextStyle(color: _parts.fontColor),
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(1.0),
              borderSide: BorderSide(color: _parts.fontColor, width: 3.0),
            ),
          ),
          validator: (String value) {
            if (changePref == error) {
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
    //路線チェンジ用
    void _lineChange() {
      //県、路線、駅、組み合わせ矛盾チェック
      switch (changeLine) {
        case init:
          changeLine = changed;
          break;
        case changed:
          if (changeStation != init) {
            changeStation = error;
          }
          break;
        case error:
          break;
        default:
          changeLine = changed;
          break;
      }
    }

    List _lineData = [""];
    return StreamBuilder<Map<String, String>>(
      stream: _bloc.lineMapStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text("エラーが発生しました。"); // エラー @Todo
        if (snapshot.connectionState == ConnectionState.waiting) return Container();
        if (!snapshot.hasData) {
          return Text("Data is Empty"); //データempty
        } else {
          _lineMap = snapshot.data;
          _lineData = _lineMap.keys.toList();
          if (_mode == modify) {
            _bloc.callStationApi(_lineMap[widget.event.line]);
            _selectLineIndex = _lineData.indexOf(widget.event.line);
          }
          return new InkWell(
            onTap: () {
              _parts
                  .picker(
                      adapter: PickerDataAdapter<String>(pickerdata: _lineData),
                      selected: _selectLineIndex, //初期値
                      onConfirm: (Picker picker, List value) {
                        var newData = _lineData[value[0]];
                        if (_lineController.text != newData) {
                          setState(() {
                            _selectLineIndex = picker.selecteds[0];
                            _selectStationIndex = 0;
                            _lineController.text = newData;
                            if (newData != " ") {
                              _bloc.callStationApi(_lineMap[newData]);
                              _lineChange();
                            }
                          });
                        }
                      })
                  .showModal(this.context);
            },
            child: AbsorbPointer(child: _lineTextFormField()),
          );
        }
      },
    );
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
        labelText: '路線',
        labelStyle: TextStyle(color: _parts.fontColor),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(1.0),
          borderSide: BorderSide(color: _parts.fontColor, width: 3.0),
        ),
      ),
      validator: (String value) {
        if (changeLine == error) {
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
        if (snapshot.hasError) return Text("エラーが発生しました。"); // エラー @Todo
        if (snapshot.connectionState == ConnectionState.waiting) return Container();
        if (!snapshot.hasData)
          return Text("Data is Empty"); //データempty
        else {
          _stationMap = snapshot.data;
          _stationData = _stationMap.keys.toList();
          if (_mode == modify) {
            _mode = loaded;
            _selectStationIndex = _stationData.indexOf(widget.event.station);
          } //ロード完了
          return InkWell(
            onTap: () {
              _parts
                  .picker(
                    adapter: PickerDataAdapter<String>(pickerdata: _stationData),
                    selected: _selectStationIndex, //初期値
                    onConfirm: (Picker picker, List value) {
                      var newData = picker.getSelectedValues()[0].toString();
                      if (_stationController.text != newData) {
                        _selectStationIndex = picker.selecteds[0];
                        if (newData != " ") {
                          setState(() {
                            _stationController.text = newData;
                            _station.code = _stationMap[newData];
                            changeStation = 1;
                          });
                        }
                      }
                    },
                  )
                  .showModal(this.context);
            },
            child: AbsorbPointer(child: _stationTextFormField()),
          );
        }
      },
    );
  }

  Widget _stationTextFormField() {
    return new TextFormField(
      style: TextStyle(color: Colors.white),
      enableInteractiveSelection: false,
      controller: _stationController,
      decoration: InputDecoration(
        icon: Icon(
          Icons.subway,
          color: _parts.fontColor,
        ),
        labelText: '駅名',
        labelStyle: TextStyle(color: _parts.fontColor),
        enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(1.0),
            borderSide: BorderSide(color: _parts.fontColor, width: 3.0)),
      ),
      validator: (String value) {
        if (changeStation == 2) {
          return '再選択してください';
        } else {
          return null;
        }
      },
    );
  }

  Widget _startTimePicker() {
    return new InkWell(
      onTap: () {
        _parts
            .dateTimePicker(
              adapter: new DateTimePickerAdapter(
                type: PickerDateTimeType.kYMDHM,
                isNumberMonth: true,
                yearSuffix: "年",
                monthSuffix: "月",
                daySuffix: "日",
                value: _start ?? DateTime.now(),
              ),
              onConfirm: (picker, _) {
                _start = DateTime.parse(picker.adapter.toString());
                _startingController.text = formatter.format(_start);
              },
            )
            .showModal(this.context);
      },
      child: AbsorbPointer(
        child: new TextFormField(
          style: TextStyle(color: _parts.pointColor),
          enableInteractiveSelection: false,
          controller: _startingController,
          decoration: InputDecoration(
            icon: Icon(
              Icons.calendar_today,
              color: _parts.fontColor,
            ),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
                borderSide: BorderSide(color: _parts.fontColor, width: 3.0)),
            labelText: '*開始日時',
            labelStyle: TextStyle(color: _parts.fontColor),
          ),
          validator: (String value) {
            return value.isEmpty ? '開始時間が未選択です' : null;
          },
        ),
      ),
    );
  }

  Widget _endTimePicker() {
    return new InkWell(
      onTap: () {
        _parts
            .dateTimePicker(
              adapter: new DateTimePickerAdapter(
                type: PickerDateTimeType.kYMDHM,
                isNumberMonth: true,
                yearSuffix: "年",
                monthSuffix: "月",
                daySuffix: "日",
                value: _start ?? DateTime.now(),
              ),
              onConfirm: (picker, _) {
                _end = DateTime.parse(picker.adapter.toString());
                _endingController.text = formatter.format(_end);
              },
            )
            .showModal(this.context);
      },
      child: AbsorbPointer(
        child: new TextFormField(
          style: TextStyle(color: _parts.pointColor),
          enableInteractiveSelection: false,
          controller: _endingController,
          decoration: InputDecoration(
            icon: Icon(
              Icons.calendar_today,
              color: _parts.fontColor,
            ),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
                borderSide: BorderSide(color: _parts.fontColor, width: 3.0)),
            labelText: '*終了日時',
            labelStyle: TextStyle(color: _parts.fontColor),
          ),
          validator: (String value) {
            if (value.isEmpty) return '終了時間が未選択です';
            if (_start != null && _start.isBefore(_end)) {
              return null;
            } else {
              return '設定時間が不正です';
            }
          },
        ),
      ),
    );
  }

  Widget _commentField() {
    return new Container(
      child: new TextFormField(
          controller: _commentController,
          style: TextStyle(color: _parts.pointColor),
          decoration: InputDecoration(
            icon: Icon(
              Icons.note,
              color: _parts.fontColor,
            ),
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(1.0),
              borderSide: BorderSide(color: _parts.fontColor, width: 3.0),
            ),
            hintText: 'ルール,レート,etc...',
            hintStyle: TextStyle(color: _parts.pointColor),
            labelText: 'コメント',
            labelStyle: TextStyle(color: _parts.fontColor),
          ),
          textInputAction: TextInputAction.newline,
          maxLength: 100,
          maxLines: 5,
          onSaved: (String value) {
            _commentController.text = value;
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _startingController.dispose();
    _endingController.dispose();
    _memberController.dispose();
    _prefController.dispose();
    _lineController.dispose();
    _stationController.dispose();
    _commentController.dispose();
    _bloc.dispose();
  }
}
