import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_cupertino_data_picker/flutter_cupertino_data_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app2/Entity/Entity.dart';
import 'Recritment.dart';
import 'package:csv/csv.dart';
import 'dart:io';

/*----------------------------------------------

イベント検索フォームページクラス

----------------------------------------------*/
class EventManagePage extends StatefulWidget {
  @override
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
  Map lineMap;
  Map stationMap;

  TextEditingController _prefController = new TextEditingController(text: '');
  TextEditingController _lineController = new TextEditingController(text: '');
  TextEditingController _stationController = new TextEditingController(text: '');
  TextEditingController _eventIdController = new TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  onPressed: () => _delete(),
                ),
                RaisedButton.icon(
                  label: Text("修正する"),
                  icon: Icon(
                    Icons.check,
                    color: set.fontColor,
                  ),
                  onPressed: () => _correction(),
                ),
              ])))),
      floatingActionButton: IconButton(
        icon: Icon(
          Icons.person_add,
          color: set.fontColor,
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            settings: const RouteSettings(name: "/detail"),
            builder: (context) {
              return RecruitmentPage(0);
            },
            fullscreenDialog: true,
          ),
        ),
      ),
    );
  }

  //ログ出力用メソッド
  void printMap(String actionName, Map map) {
    print("\n-----------$actionName Data-----------\n"
            "eventId:" +
        map["eventId"].toString() +
        "\n"
            "member:" +
        map["recruitMember"] +
        "\n"
            "station:" +
        map["station"] +
        "\n"
            "start:" +
        DateTime.fromMillisecondsSinceEpoch(map["startingTime"]).toString() +
        "\n"
            "end:" +
        DateTime.fromMillisecondsSinceEpoch(map["endingTime"]).toString() +
        "\n"
            "remarks:" +
        map["remarks"] +
        "\n"
            "-------------------------------\n");
  }

  //イベント修正
  void _correction() {}

  //期限切れイベント削除用メソッド
  void _delete() {
    DateTime now = DateTime.now();
    final _mainReference = FirebaseDatabase.instance.reference().child("Events");
    _mainReference.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((k, v) {
        v.forEach((k1, v1) {
          v1.forEach((k2, v2) {
            if (DateTime.fromMillisecondsSinceEpoch(v2["endingTime"]).isBefore(now)) {
              _mainReference.child(k).child(k1).child(k2).remove();
              printMap("remove", v2);
            }
          });
        });
      });
    });
  }

  //フォーム送信用メソッド
  void _submission() {
    if (this._formKey.currentState.validate()) {
      if (_eventId != null) {
      } else {
        Navigator.push(
            this.context,
            MaterialPageRoute(
                // パラメータを渡す
                builder: (context) => new EventSearchResultPage(_selectPref, _selectLine, _selectStation)));
      }
    }
  }

  //都道府県Picker
  Widget _prefPicker() {
    return new GestureDetector(
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
            enabledBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(1.0), borderSide: BorderSide(color: set.fontColor, width: 3.0)),
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
    return new GestureDetector(
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
            enabledBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(1.0), borderSide: BorderSide(color: set.fontColor, width: 3.0)),
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
    return new GestureDetector(
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
            enabledBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(1.0), borderSide: BorderSide(color: set.fontColor, width: 3.0)),
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
          enabledBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(1.0), borderSide: BorderSide(color: set.fontColor, width: 3.0)),
        ),
        validator: (String value) {
          return null;
        },
        onSaved: (String value) {
          _eventId = value;
        });
  }

  //県Pickerが選択された時の処理メソッド
  void _prefChange(String newValue) {
    setState(() {
      changePref = 1;
      //県、路線、駅、組み合わせ矛盾チェック
      if (changeLine != 0 || changeStation != 0) {
        changeLine = 2;
        changeStation = 2;
      }

      lineMap = new Map<String, int>();
      final input = new File('assets/csv/line.csv').openRead();
      final fields = input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
      int prefNum = int.parse(Pref.pref[newValue]);

//      var url = 'http://www.ekidata.jp/api/p/' + prefNum.toString() + '.json';
//      //APIコール
//      http.get(url).then((response) {
//        var body = response.body.substring(50, response.body.length - 58);
//        var mapLine = jsonDecode(body);
//        mapLine["line"].forEach((i) {
//          lineMap[i["line_name"]] = i["line_cd"];
//        });
//        //lineMap.forEach((key,value) => lineData.add(key));
//        lineData = lineMap.keys.toList();
//      });
    });
  }

  //路線チェンジ用
  void _lineChange(String newValue) {
    setState(() {
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
      _selectLine = newValue;
      int lineNum = lineMap[newValue];
      stationMap = new Map<String, int>();

      //APIコール
      var url = 'http://www.ekidata.jp/api/l/' + lineNum.toString() + '.json';
      http.get(url).then((response) {
        var body = response.body.substring(50, response.body.length - 58);
        var mapStation = jsonDecode(body);
        mapStation["station_l"].forEach((i) {
          stationMap[i["station_name"]] = i["station_cd"];
        });
        //lineMap.forEach((key,value) => lineData.add(key));
        stationData = stationMap.keys.toList();
      });
    });
  }
}

/*----------------------------------------------

イベント検索　結果表示クラス

----------------------------------------------*/
class EventSearchResultPage extends StatefulWidget {
  String pref;
  String line;
  String station;

  EventSearchResultPage(this.pref, this.line, this.station);

  @override
  EventSearchResultPageState createState() => new EventSearchResultPageState();
}

/*----------------------------------------------

イベント検索　結果表示ページ出力（リスト表示）クラス

----------------------------------------------*/
class EventSearchResultPageState extends State<EventSearchResultPage> {
  PageParts set = new PageParts();
  final _mainReference = FirebaseDatabase.instance.reference().child("Events");

  //EventSearchResultPageState(this.pref, this.line, this.station);

  var formatter = new DateFormat('yyyy年 M月d日(E) HH時mm分'); // 日時を指定したフォーマットで指定するためのフォーマッター
  EventCreate em = new EventCreate();
  List<EventEntity> entries = new List();

  @override
  //初期コールメソッド
  void initState() {
    super.initState();
    _createList();
  }

  _createList() {
    print("${widget.pref},${widget.line},${widget.station}");
    //都道府県検索
    if (widget.pref != null && widget.line == null && widget.station == null) {
      _mainReference.child(widget.pref).once().then((DataSnapshot result) {
        result.value.forEach((k, v) {
          v.forEach((k2, v2) {
            setState(() {
              entries.add(new EventEntity.fromMap(v2));
            });
          });
        });
      });
      //駅名検索
    } else if (widget.pref != null && widget.line != null && widget.station != null) {
      //駅名検索
      _mainReference.child("${widget.pref}/${widget.station}").once().then((DataSnapshot result) {
        result.value.forEach((k, v) {
          setState(() {
            entries.add(new EventEntity.fromMap(v));
          });
        });
      });
    } else if (widget.pref == null && widget.line == null && widget.station == null) {
      _mainReference.once().then((DataSnapshot result) {
        result.value.forEach((k, v) {
          v.forEach((k1, v1) {
            v1.forEach((k2, v2) {
              setState(() {
                entries.add(new EventEntity.fromMap(v2));
              });
            });
          });
        });
      });
    }
  }

  //画面全体のビルド
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: set.backGroundColor,
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: new Column(
            children: <Widget>[
              Text('検索結果：' + entries.length.toString() + '件', style: TextStyle(color: set.fontColor, backgroundColor: set.backGroundColor)),
              Expanded(
                child: ListView.builder(
                  //padding: const EdgeInsets.all(16.0),
                  itemBuilder: (BuildContext context, int index) {
                    return _buildRow(index);
                  },
                  itemCount: entries.length,
                ),
              ),
              Divider(
                height: 8.0,
              ),
              RaisedButton.icon(
                label: Text("戻る"),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: set.fontColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
//              Container(
//                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
//                  child: _buildInputArea()
//              )
            ],
          )),
    );
  }

  //リスト要素生成
  Widget _buildRow(int index) {
    //リストの要素一つづつにonTapを付加して、詳細ページに飛ばす
    return new GestureDetector(
      onTap: () {
        Navigator.push(
            this.context,
            MaterialPageRoute(
                // パラメータを渡す
                builder: (context) => new EventDetailPage(entries[index])));
      },
      child: new SizedBox(
        child: new Card(
          elevation: 10,
          color: set.backGroundColor,
          child: new Container(
            decoration: BoxDecoration(
              border: Border.all(color: set.fontColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Text(
                    entries[index].station + "駅",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: set.pointColor,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                  child: Text(
                    entries[index].userId,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: set.fontColor,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                  child: Text(
                    "EventID :" + entries[index].eventId.toString(),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: set.fontColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*----------------------------------------------

イベント作成用クラス

----------------------------------------------*/
class EventCreate {
  var mainReference = FirebaseDatabase.instance.reference().child("Events");
  var managerReference = FirebaseDatabase.instance.reference().child("EventManager");
  //var userReference = FirebaseDatabase.instance.reference().child("User");
  var userReference = FirebaseDatabase.instance.reference().child("gmail");
  int eventId;

  //イベント追加メソッド
  void addEvent(String pref, String line, EventEntity event) {
    managerReference.once().then((DataSnapshot snapshot) {
      //print(snapshot.value["eventId"].toString());
      eventId = int.parse(snapshot.value["eventId"]);
      String newEventId = (eventId + 1).toString();
      managerReference.set({"eventId": "$newEventId"});
      event.eventId = newEventId;
      mainReference.child(pref).child(event.station).child(eventId.toString()).set(event.toJson());
    });
  }

  void addUsersEvent(String eventId) {}
}

/*----------------------------------------------

イベントの詳細ページ出力クラス(Stateless)

----------------------------------------------*/

class EventDetailPage extends StatelessWidget {
  EventEntity event;
  EventDetailPage(this.event);
  PageParts set = new PageParts();
  var formatter = new DateFormat('yyyy年 M月d日(E) HH時mm分');

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: set.backGroundColor,
      body: Center(
        child: Column(children: <Widget>[
          //イベント詳細
          Text(
            "イベントID:" +
                event.eventId.toString() +
                "\n"
                    "最寄駅:" +
                event.station +
                "\n"
                    "募集人数:" +
                event.recruitMember +
                "\n"
                    "開始時刻:" +
                event.startingTime +
                "\n"
                    "終了時刻:" +
                event.endingTime +
                "\n"
                    "備考:" +
                event.remarks +
                "\n",
            style: TextStyle(
              fontFamily: 'Roboto',
              color: set.fontColor,
              fontSize: 20,
            ),
          ),

          //戻るボタン
          set.backButton(
            onTap: () => Navigator.pop(context),
          ),
        ]),
      ),
    );
  }
}
