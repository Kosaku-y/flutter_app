import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app2/Bloc/EventManageBloc.dart';
import 'package:flutter_app2/Common/CommonData.dart';
import 'package:flutter_app2/Entity/EventDetail.dart';
import 'package:flutter_app2/Entity/EventPlace.dart';
import 'package:flutter_app2/PageParts.dart';
import 'package:flutter_app2/Entity/User.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:intl/intl.dart';
import 'AdvertisementScreen.dart';

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
  var _formatter = new DateFormat('yyyy年 M月d日(E) HH時mm分');
  EventManageBloc _bloc = EventManageBloc();

  //validate用
  static const int init = 0;
  static const int changed = 1;
  static const int error = 2;

  int _changePref = init;
  int _changeLine = init;
  int _changeStation = init;

  Map _lineMap = Map<String, String>();
  Map _stationMap = Map<String, String>();

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

  //Pickerの初期選択位置
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
      _startingController = TextEditingController(text: '');
      _endingController = TextEditingController(text: '');
      _memberController = TextEditingController(text: '');
      _prefController = TextEditingController(text: '');
      _lineController = TextEditingController(text: '');
      _startingController = TextEditingController(text: '');
      _endingController = TextEditingController(text: '');
      _stationController = TextEditingController(text: '');
      _commentController = TextEditingController(text: '');
    } else {
      _bloc.callLineApi(CommonData.pref[widget.event.pref]);
      _selectPrefIndex = (CommonData.pref.keys.toList()).indexOf(widget.event.pref);
      _changePref = changed;
      _changeLine = changed;
      _changeStation = changed;
      _startingController =
          TextEditingController(text: _formatter.format(widget.event.startingTime));
      _start = widget.event.startingTime;
      _endingController = TextEditingController(text: _formatter.format(widget.event.endingTime));
      _end = widget.event.endingTime;
      _memberController = TextEditingController(text: widget.event.recruitMember);
      _prefController = TextEditingController(text: widget.event.pref);
      _lineController = TextEditingController(text: widget.event.line);
      _stationController = TextEditingController(text: widget.event.station);
      _commentController = TextEditingController(text: widget.event.comment);
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
              Text('募集条件を入力してください', style: _parts.guideWhite),
              _recruitMemberPicker(), //募集人数Picker
              _prefPicker(), //都道府県Picker
              _linePicker(), //路線Picker
              _stationPicker(), //駅名Picker
              _startTimePicker(), //開始日時Picker
              _endTimePicker(), //終了日時Picker
              _commentField(), //備考
              _parts.iconButton(
                  message: "確認", icon: Icons.event_available, onPressed: () => _confirm()),
              _parts.backButton(context),
            ]),
          ),
        ),
      ),
    );
  }

  void _confirm() {
    if (this._formKey.currentState.validate()) {
      this._formKey.currentState.save();
      EventDetail event = new EventDetail(
        _memberController.text,
        _lineController.text,
        _stationController.text,
        _start,
        _end,
        _commentController.text,
        widget.user.userId,
        widget.user.name,
      );
      _line.name = _lineController.text;
      _station.name = _stationController.text;
      if (_mode != register) event.eventId = widget.event.eventId;

      AwesomeDialog(
              context: context,
              headerAnimationLoop: false,
              animType: AnimType.TOPSLIDE,
              dialogType: DialogType.INFO,
              body: Column(children: <Widget>[
                Text(_mode == register ? "募集条件を確認して下さい。" : "変更内容を確認して下さい。"),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text("募集人数：${event.recruitMember}", style: _parts.guideBlack),
                    Text("路線　　：${event.line}", style: _parts.guideBlack),
                    Text("駅　　　：${event.station}", style: _parts.guideBlack),
                    Text("開始時間：${_formatter.format(event.startingTime)}", style: _parts.guideBlack),
                    Text("終了時間：${_formatter.format(event.endingTime)}", style: _parts.guideBlack),
                    Text("コメント：${event.comment}", style: _parts.guideBlack),
                  ],
                ),
              ]),
              btnOkOnPress: () => _commit(event),
              btnCancelOnPress: () {},
              btnCancelText: "戻る",
              btnOkText: "OK")
          .show();
    }
  }

  void _commit(EventDetail event) async {
    var _error = await Navigator.of(context).push(
      MaterialPageRoute(
        settings: const RouteSettings(name: "/Advertisement"),
        builder: (context) => _mode == register
            ? AdvertisementScreen(mode: _mode, stationCode: _station.code, event: event)
            : AdvertisementScreen(
                mode: _mode, stationCode: _station.code, event: event, oldEvent: widget.event),
        fullscreenDialog: true,
      ),
    );
    if (_error != null) {
      _error = null;
      print(_error);
      AwesomeDialog(
              context: context,
              headerAnimationLoop: false,
              animType: AnimType.TOPSLIDE,
              dialogType: DialogType.ERROR,
              body: Center(child: Text("イベント作成に失敗しました。\n再度やり直してください")),
              btnOkOnPress: () {},
              btnOkText: "OK")
          .show();
    }
  }

  //募集人数Picker
  Widget _recruitMemberPicker() {
    return InkWell(
      onTap: () {
        _parts
            .picker(
                adapter: NumberPickerAdapter(data: [NumberPickerColumn(begin: 1, end: 4)]),
                selected: _selectMemberIndex, //初期値
                onConfirm: (Picker picker, List value) {
                  if (value.toString().isNotEmpty) {
                    setState(() {
                      _memberController.text = picker.getSelectedValues()[0].toString();
                    });
                  }
                })
            .showModal(this.context);
      },
      child: AbsorbPointer(
        child: TextFormField(
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
      _changePref = changed;
      //県、路線、駅、組み合わせ矛盾チェック
      if (_changeLine != init || _changeStation != init) {
        _changeLine = error;
        _changeStation = error;
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
                  if (newData != _prefController.text && newData != " ") {
                    _bloc.callLineApi(CommonData.pref[newData]);
                    _selectPrefIndex = picker.selecteds[0];
                    _selectLineIndex = 0;
                    _prefChange();
                    setState(() => _prefController.text = newData);
                  }
                })
            .showModal(this.context);
      },
      child: AbsorbPointer(
        child: new TextFormField(
          style: TextStyle(color: _parts.pointColor),
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
          validator: (value) {
            if (_changePref == error) return "再選択してください";
            if (value == null) return "選択してください";
            return null;
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
      switch (_changeLine) {
        case init:
          _changeLine = changed; // 選択済み
          break;
        case changed:
          if (_changeStation == changed) _changeStation = error; // 駅が選択済みなら駅再選択
          break;
        case error:
          if (_changePref == changed) {
            _changeLine = changed; // 県が選択済みなら選択OK
            if (_changeStation == changed) _changeStation = error; // 駅が選択済みなら駅再選択
          }
          break;
      }
    }

    List _lineData = [""];
    return StreamBuilder<Map<String, String>>(
      stream: _bloc.lineMapStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text("エラーが発生しました。", style: _parts.guideWhite); // エラー @Todo
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
                        if (newData != _lineController.text && newData != " ") {
                          _bloc.callStationApi(_lineMap[newData]);
                          _selectLineIndex = picker.selecteds[0];
                          _selectStationIndex = 0;
                          _lineChange();
                          setState(() => _lineController.text = newData);
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
      style: TextStyle(color: _parts.pointColor),
      enableInteractiveSelection: false,
      controller: _lineController,
      decoration: InputDecoration(
        icon: Icon(Icons.train, color: _parts.fontColor),
        labelText: '路線',
        labelStyle: TextStyle(color: _parts.fontColor),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(1.0),
          borderSide: BorderSide(color: _parts.fontColor, width: 3.0),
        ),
      ),
      validator: (value) {
        if (_changeLine == error) return "再選択してください";
        if (value == null) return "選択してください";
        return null;
      },
    );
  }

  //駅Picker
  Widget _stationPicker() {
    List _stationData = [""];
    return StreamBuilder<Map<String, String>>(
      stream: _bloc.stationMapStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text("エラーが発生しました。", style: _parts.guideWhite); // エラー @Todo
        if (snapshot.connectionState == ConnectionState.waiting) return Container();
        if (!snapshot.hasData)
          return Text("Data is Empty", style: _parts.guideWhite); //データempty
        else {
          _stationMap = snapshot.data;
          _stationData = _stationMap.keys.toList();
          if (_mode == modify) {
            _mode = loaded;
            _station.code = _stationMap[widget.event.station];
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
                      if (newData != _stationController.text && newData != " ") {
                        _selectStationIndex = picker.selecteds[0];
                        _station.code = _stationMap[newData];
                        _changeStation = 1;
                        setState(() => _stationController.text = newData);
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
      style: TextStyle(color: _parts.pointColor),
      enableInteractiveSelection: false,
      controller: _stationController,
      decoration: InputDecoration(
        icon: Icon(Icons.subway, color: _parts.fontColor),
        labelText: '駅名',
        labelStyle: TextStyle(color: _parts.fontColor),
        enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(1.0),
            borderSide: BorderSide(color: _parts.fontColor, width: 3.0)),
      ),
      validator: (value) {
        if (_changeStation == error) return "再選択してください";
        if (value == null) return "選択してください";
        return null;
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
                  value: _start ?? DateTime.now()),
              onConfirm: (picker, _) {
                _start = DateTime.parse(picker.adapter.toString());
                _startingController.text = _formatter.format(_start);
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
              icon: Icon(Icons.calendar_today, color: _parts.fontColor),
              enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(1.0),
                  borderSide: BorderSide(color: _parts.fontColor, width: 3.0)),
              labelText: '*開始日時',
              labelStyle: TextStyle(color: _parts.fontColor),
            ),
            validator: (String value) {
              if (value.isEmpty) return '開始時間が未選択です';
              if (_start.isBefore(DateTime.now())) return '開始時間が現在時刻より前です';
              return null;
            }),
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
                  value: _end ?? DateTime.now()),
              onConfirm: (picker, _) {
                _end = DateTime.parse(picker.adapter.toString());
                _endingController.text = _formatter.format(_end);
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
            icon: Icon(Icons.calendar_today, color: _parts.fontColor),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
                borderSide: BorderSide(color: _parts.fontColor, width: 3.0)),
            labelText: '*終了日時',
            labelStyle: TextStyle(color: _parts.fontColor),
          ),
          validator: (String value) {
            if (value.isEmpty) return '終了時間が未選択です';
            if (_start != null && _start.isAfter(_end)) return '開始時間より前です';
            return null;
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
            icon: Icon(Icons.note, color: _parts.fontColor),
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
    _bloc?.dispose();
  }
}
