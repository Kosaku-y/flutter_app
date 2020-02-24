import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app2/Bloc/EventManageBloc.dart';
import 'package:flutter_app2/Entity/EventDetail.dart';
import 'package:flutter_app2/Entity/EventPlace.dart';
import 'package:flutter_app2/Entity/PageParts.dart';
import 'package:flutter_app2/Repository/EventRepository.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_cupertino_data_picker/flutter_cupertino_data_picker.dart';

/*----------------------------------------------

イベント作成・編集フォームページクラス

----------------------------------------------*/
class EventCreatePage extends StatefulWidget {
  int mode;

  EventCreatePage({Key key, this.mode}) : super(key: key);
  @override
  EventCreatePageState createState() => new EventCreatePageState();
}

class EventCreatePageState extends State<EventCreatePage> {
  PageParts set = new PageParts();
  final int NEW = 1;
  final int MODIFIED = 0;

  final int register = 0;

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

  TextEditingController _startingController = new TextEditingController(text: '');
  TextEditingController _endingController = new TextEditingController(text: '');
  TextEditingController _memberController = new TextEditingController(text: '');
  TextEditingController _prefController = new TextEditingController(text: '');
  TextEditingController _lineController = new TextEditingController(text: '');
  TextEditingController _stationController = new TextEditingController(text: '');
  TextEditingController _commentController = new TextEditingController(text: '');
  DateTime _start;
  DateTime _end;

  final _formKey = GlobalKey<FormState>();
  final EventRepository repository = new EventRepository();
  final List<String> _numberOfRecruit = <String>['1', '2', '3'];

  @override
  void initState() {
    super.initState();
    if (widget.mode == MODIFIED) {}
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: set.baseColor,
        title: Text('イベント作成ページ',
            style: TextStyle(
              color: set.pointColor,
            )),
      ),
      backgroundColor: set.backGroundColor,
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(40.0),
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              Text('募集条件を入力してください', style: TextStyle(color: set.fontColor)),
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
                    color: set.pointColor,
                    icon: Icon(
                      Icons.event_available,
                      color: set.fontColor,
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
                  color: set.fontColor,
                ),
                onPressed: () => Navigator.of(context).popUntil(ModalRoute.withName("/EventSearch")
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

      EventDetail event = new EventDetail(_memberController.text, _prefController.text,
          formatter.format(_start), formatter.format(_end), _commentController.text);
      //repository.createEvent(_prefController.text, _lineController.text, event);

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
          style: TextStyle(color: set.pointColor),
          enableInteractiveSelection: false,
          controller: _memberController,
          decoration: InputDecoration(
            icon: Icon(
              Icons.people,
              color: set.fontColor,
            ),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
                borderSide: BorderSide(color: set.fontColor, width: 3.0)),
            hintText: 'Choose a number of recruiting member',
            hintStyle: TextStyle(color: set.fontColor),
            labelText: '*募集人数',
            labelStyle: TextStyle(color: set.fontColor),
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
        DataPicker.showDatePicker(
          context,
          showTitleActions: true,
          locale: 'en',
          datas: Pref.pref.keys.toList(),
          title: '都道府県',
          onConfirm: (value) {
            if (_prefController.text != value) {
              setState(() {
                _prefController.text = value;
                if (value != "") {
                  _bloc.lineApiSink.add(Pref.pref[value]);
                  _prefChange();
                }
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
                          if (value != "") {
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
          color: set.fontColor,
        ),
        hintText: 'Choose a line',
        labelText: '路線',
        labelStyle: TextStyle(color: set.fontColor),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(1.0),
          borderSide: BorderSide(color: set.fontColor, width: 3.0),
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
                      if (value != "") {
                        if (_stationController.text != value) {
                          setState(() {
                            _stationController.text = value;
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
    );
  }

  Widget _startTimePicker() {
    return new InkWell(
      onTap: () {
        DatePicker.showDateTimePicker(context,
            showTitleActions: true,
            theme: DatePickerTheme(
              backgroundColor: Colors.white,
              itemStyle: TextStyle(color: Colors.black),
              doneStyle: TextStyle(color: Colors.black),
            ), onConfirm: (date) {
          setState(() {
            _start = date;
            _startingController.text = formatter.format(date);
          });
        }, currentTime: DateTime.now(), locale: LocaleType.en);
      },
      child: AbsorbPointer(
        child: new TextFormField(
          style: TextStyle(color: set.pointColor),
          enableInteractiveSelection: false,
          controller: _startingController,
          decoration: InputDecoration(
            icon: Icon(
              Icons.calendar_today,
              color: set.fontColor,
            ),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
                borderSide: BorderSide(color: set.fontColor, width: 3.0)),
            hintText: 'Choose a starting Time',
            labelText: '*開始日時',
            labelStyle: TextStyle(color: set.fontColor),
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
        DatePicker.showDateTimePicker(context,
            showTitleActions: true,
            theme: DatePickerTheme(
              backgroundColor: Colors.white,
              itemStyle: TextStyle(color: Colors.black),
              doneStyle: TextStyle(color: Colors.black),
            ), onConfirm: (date) {
          setState(() {
            _endingController.text = formatter.format(date);
            _end = date;
          });
        }, currentTime: DateTime.now(), locale: LocaleType.en);
      },
      child: AbsorbPointer(
        child: new TextFormField(
          style: TextStyle(color: set.pointColor),
          enableInteractiveSelection: false,
          controller: _endingController,
          decoration: InputDecoration(
            icon: Icon(
              Icons.calendar_today,
              color: set.fontColor,
            ),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
                borderSide: BorderSide(color: set.fontColor, width: 3.0)),
            hintText: 'Choose a station',
            labelText: '*終了日時',
            labelStyle: TextStyle(color: set.fontColor),
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
          style: TextStyle(color: set.pointColor),
          decoration: InputDecoration(
            icon: Icon(
              Icons.note,
              color: set.fontColor,
            ),
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(1.0),
              borderSide: BorderSide(color: set.fontColor, width: 3.0),
            ),
            hintText: 'add comment',
            labelText: '備考',
            labelStyle: TextStyle(color: set.fontColor),
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
    _bloc.dispose();
  }
}
