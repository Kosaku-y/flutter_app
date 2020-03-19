import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app2/Bloc/EventManageBloc.dart';
import 'package:flutter_app2/Entity/EventDetail.dart';
import 'package:flutter_app2/Entity/EventPlace.dart';
import 'package:flutter_app2/Entity/PageParts.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_cupertino_data_picker/flutter_cupertino_data_picker.dart';

import 'EventCreateConfirmScreen.dart';

/*----------------------------------------------

イベント作成・編集フォームページクラス

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

  final int register = 0;
  final int modify = 1;

  // 日時を指定したフォーマットで指定するためのフォーマッター
  var formatter = new DateFormat('yyyy年 M月d日(E) HH時mm分');
  EventManageBloc _bloc = EventManageBloc();
  List lineData = [""];
  List stationData = [""];

  int changePref = 0;
  int changeLine = 0;
  int changeStation = 0;

  Map _lineMap = new Map<String, String>();
  Map _stationMap = new Map<String, String>();

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

  final _formKey = GlobalKey<FormState>();
  final List<String> _numberOfRecruit = <String>['1', '2', '3'];

  @override
  void initState() {
    super.initState();
    if (widget.mode == register) {
      _startingController = new TextEditingController(text: '');
      _endingController = new TextEditingController(text: '');
      _memberController = new TextEditingController(text: '');
      _prefController = new TextEditingController(text: '');
      _lineController = new TextEditingController(text: '');
      _stationController = new TextEditingController(text: '');
      _commentController = new TextEditingController(text: '');
    } else {
      _bloc.lineApiSink.add(Pref.pref[widget.event.pref]);
      setState(() {
        //_bloc.stationApiSink.add(_lineMap[widget.event.line]);
      });
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
              _recruitMemberPicker(), //募集人数プルダウン
              _prefPicker(), //都道府県Picker
              _linePicker(), //路線Picker
              _stationPicker(), //駅名Picker
              _startTimePicker(), //開始日時プルダウン
              _endTimePicker(), //終了日時プルダウン
              _commentField(), //備考
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: RaisedButton.icon(
                    label: Text("募集する"),
                    color: _parts.pointColor,
                    icon: Icon(
                      Icons.event_available,
                      color: _parts.fontColor,
                    ),
                    onPressed: () {
                      //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                      _submission();
                    }),
              ),
              RaisedButton.icon(
                label: Text("検索ページへ戻る"),
                icon: Icon(
                  Icons.search,
                  color: _parts.fontColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }

  //県Pickerが選択された時の処理メソッド
  void _prefChange() {
    changePref = 1;
    //県、路線、駅、組み合わせ矛盾チェック
    if (changeLine != 0 || changeStation != 0) {
      changeLine = 2;
      changeStation = 2;
    }
  }

  //路線チェンジ用
  void _lineChange() {
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
        widget.user.name,
      );
      _line.name = _lineController.text;
      _station.name = _stationController.text;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          settings: const RouteSettings(name: "/EventCreateConfirm"),
          builder: (BuildContext context) => EventCreateConfirmScreen(
              line: _line, station: _station, user: widget.user, event: event),
        ),
      );
    }
  }

  Widget _recruitMemberPicker() {
    return new InkWell(
      onTap: () {
        DataPicker.showDatePicker(
          context,
          showTitleActions: true,
          locale: 'en',
          datas: _numberOfRecruit,
          title: '募集人数',
          onConfirm: (value) {
            if (value != "") {
              setState(() {
                _memberController.text = value;
              });
            }
          },
        );
      },
      child: AbsorbPointer(
        child: new TextFormField(
          style: TextStyle(color: _parts.pointColor),
          enableInteractiveSelection: false,
          controller: _memberController,
          decoration: InputDecoration(
            icon: Icon(
              Icons.people,
              color: _parts.fontColor,
            ),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
                borderSide: BorderSide(color: _parts.fontColor, width: 3.0)),
            hintText: 'Choose a number of recruiting member',
            hintStyle: TextStyle(color: _parts.fontColor),
            labelText: '*募集人数',
            labelStyle: TextStyle(color: _parts.fontColor),
          ),
          validator: (String value) {
            return value.isEmpty ? '必須項目です' : null;
          },
        ),
      ),
    );
  }

  //都道府県Picker
  Widget _prefPicker() {
    return new InkWell(
      onTap: () {
        _parts
            .picker(
                adapter: PickerDataAdapter<String>(pickerdata: Pref.pref.keys.toList()),
                selected: 0, //初期値
                onConfirm: (Picker picker, List value) {
                  var newData = picker.getSelectedValues()[0].toString();
                  if (_prefController.text != newData) {
                    setState(() {
                      _prefController.text = newData;
                      if (newData != " ") _bloc.lineApiSink.add(Pref.pref[newData]);
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
            icon: Icon(
              Icons.place,
              color: _parts.fontColor,
            ),
            hintText: 'Choose a prefecture',
            labelText: '都道府県',
            labelStyle: TextStyle(color: _parts.fontColor),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
                borderSide: BorderSide(color: _parts.fontColor, width: 3.0)),
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
    List _lineData = [""];
    return StreamBuilder<Map<String, String>>(
        stream: _bloc.lineMapStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return _lineTextFormField();
          } else if (snapshot.hasError) {
            return Text("エラーが発生しました。");
          } else {
            if (snapshot.data == null || snapshot.data.isEmpty) {
              return Text("データが空です。");
            } else {
              _lineMap = snapshot.data;
              _lineData = _lineMap.keys.toList();
              return new InkWell(
                onTap: () {
                  DataPicker.showDatePicker(
                    context,
                    showTitleActions: true,
                    locale: 'en',
                    datas: _lineData,
                    title: '路線',
                    onConfirm: (value) {
                      if (_lineController.text != value) {
                        setState(() {
                          _lineController.text = value;
                          _line.code = _lineMap[value];
                          if (value != " ") {
                            _bloc.stationApiSink.add(_lineMap[value]);
                            _lineChange();
                          }
                        });
                      }
                    },
                  );
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
        if (changeLine == 2) {
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
                  DataPicker.showDatePicker(
                    context,
                    showTitleActions: true,
                    locale: 'en',
                    datas: _stationData,
                    title: '駅',
                    onConfirm: (value) {
                      if (value != " ") {
                        if (_stationController.text != value) {
                          setState(() {
                            _stationController.text = value;
                            _station.code = _stationMap[value];
                            changeStation = 1;
                          });
                        }
                      }
                    },
                  );
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
        icon: Icon(
          Icons.subway,
          color: _parts.fontColor,
        ),
        hintText: 'Choose a station',
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
            hintText: 'Choose a starting Time',
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
            hintText: 'Choose a station',
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
            hintText: 'add comment',
            labelText: '備考',
            labelStyle: TextStyle(color: _parts.fontColor),
          ),
          keyboardType: TextInputType.multiline,
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
