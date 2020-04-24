import 'package:flutter/material.dart';
import 'package:flutter_app2/Repository/LocalDataRepository.dart';
import 'package:flutter_app2/PageParts.dart';
import 'package:flutter_app2/Entity/Score.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

/*----------------------------------------------

スコア入力Screenクラス

----------------------------------------------*/

class ScoreInputScreen extends StatefulWidget {
  ScoreInputScreen({Key key}) : super(key: key);
  State<StatefulWidget> createState() {
    return new ScoreInputScreenState();
  }
}

class ScoreInputScreenState extends State<ScoreInputScreen> {
  final PageParts _parts = PageParts();
  Score score;
  List<Score> listScore;
  DateTime _date;
  var formatter;
  LocalDataRepository repository = LocalDataRepository();

  TextEditingController dateController = TextEditingController(text: '');
  TextEditingController rankingController = TextEditingController(text: '');
  TextEditingController chipController = TextEditingController(text: '');
  TextEditingController totalController = TextEditingController(text: '');
  TextEditingController rateController = TextEditingController(text: '');
  TextEditingController balanceController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ja_JP');
    Intl.defaultLocale = 'ja_JP';
    formatter = DateFormat(DateFormat.YEAR_MONTH_WEEKDAY_DAY);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: _parts.appBar(title: "スコア入力"),
      backgroundColor: _parts.backGroundColor,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
          child: Column(
            children: <Widget>[
              dateField(),
              rankingField(),
              chipField(),
              totalField(),
              rateField(),
              balanceField(),
              _parts.iconButton(message: "記録する", icon: Icons.send, onPressed: () => submit())
            ],
          ),
        ),
      ),
    );
  }

  void submit() async {
    Score score = Score(
        (DateTime(_date.year, _date.month, _date.day, 21).toUtc()).toIso8601String(),
        int.parse(rankingController.text),
        int.parse(chipController.text),
        int.parse(totalController.text),
        int.parse(rateController.text),
        int.parse(balanceController.text));
    repository.addScore(score);
  }

  Widget dateField() {
    return new InkWell(
      onTap: () {
        Picker(
          itemExtent: 40.0,
          height: 200.0,
          headerDecoration: BoxDecoration(color: _parts.baseColor),
          backgroundColor: _parts.baseColor,
          cancelText: "戻る",
          confirmText: "確定",
          textStyle: TextStyle(color: _parts.pointColor, fontSize: 18.0),
          cancelTextStyle: TextStyle(color: _parts.pointColor, fontSize: 15.0),
          confirmTextStyle: TextStyle(color: _parts.pointColor, fontSize: 15.0),
          adapter: DateTimePickerAdapter(
            type: PickerDateTimeType.kYMD,
            isNumberMonth: true,
            yearSuffix: "年",
            monthSuffix: "月",
            daySuffix: "日",
            value: _date ?? DateTime.now(),
          ),
          onConfirm: (picker, _) {
            _date = DateTime.parse(picker.adapter.toString());
            dateController.text = formatter.format(_date);
          },
        ).showModal(this.context);
      },
      child: AbsorbPointer(
        child: new TextFormField(
          style: TextStyle(color: _parts.pointColor),
          enableInteractiveSelection: false,
          controller: dateController,
          decoration: InputDecoration(
            icon: Icon(Icons.calendar_today, color: _parts.fontColor),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
                borderSide: BorderSide(color: _parts.fontColor, width: 3.0)),
            hintText: 'Choose a starting Time',
            labelText: '*日時',
            labelStyle: TextStyle(color: _parts.fontColor),
          ),
          validator: (String value) {
            return value.isEmpty ? '開始時間が未選択です' : null;
          },
        ),
      ),
    );
  }

  Widget rankingField() {
    return new InkWell(
      onTap: () {
        _parts
            .picker(
              adapter: NumberPickerAdapter(data: [NumberPickerColumn(begin: 1, end: 4)]),
              selected: 0, //初期値
              onConfirm: (Picker picker, List value) {
                if (value.toString() != "") {
                  setState(() {
                    rankingController.text = picker.getSelectedValues()[0].toString();
                  });
                }
              },
            )
            .showModal(this.context);
      },
      child: AbsorbPointer(
        child: TextFormField(
          style: TextStyle(color: _parts.pointColor),
          enableInteractiveSelection: false,
          controller: rankingController,
          decoration: InputDecoration(
            icon: Icon(Icons.people, color: _parts.fontColor),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
                borderSide: BorderSide(color: _parts.fontColor, width: 3.0)),
            hintText: 'Choose a number of recruiting member',
            hintStyle: TextStyle(color: _parts.fontColor),
            labelText: '*着順',
            labelStyle: TextStyle(color: _parts.fontColor),
          ),
          validator: (String value) => value.isEmpty ? '必須項目です' : null,
        ),
      ),
    );
  }

  Widget chipField() {
    return TextFormField(
      style: TextStyle(color: _parts.pointColor),
      enableInteractiveSelection: false,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      controller: chipController,
      decoration: InputDecoration(
        icon: Icon(Icons.people, color: _parts.fontColor),
        enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(1.0),
            borderSide: BorderSide(color: _parts.fontColor, width: 3.0)),
        hintText: 'Choose a number of recruiting member',
        hintStyle: TextStyle(color: _parts.fontColor),
        labelText: '*チップ',
        labelStyle: TextStyle(color: _parts.fontColor),
      ),
      validator: (String value) => value.isEmpty ? '必須項目です' : null,
    );
  }

  Widget totalField() {
    return TextFormField(
      style: TextStyle(color: _parts.pointColor),
      enableInteractiveSelection: false,
      controller: totalController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        icon: Icon(Icons.people, color: _parts.fontColor),
        enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(1.0),
            borderSide: BorderSide(color: _parts.fontColor, width: 3.0)),
        hintText: 'Choose a number of recruiting member',
        hintStyle: TextStyle(color: _parts.fontColor),
        labelText: '*トータル',
        labelStyle: TextStyle(color: _parts.fontColor),
      ),
      validator: (String value) => value.isEmpty ? '必須項目です' : null,
    );
  }

  Widget rateField() {
    return TextFormField(
      style: TextStyle(color: _parts.pointColor),
      enableInteractiveSelection: true,
      keyboardType: TextInputType.number,
      controller: rateController,
      decoration: InputDecoration(
        icon: Icon(Icons.people, color: _parts.fontColor),
        enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(1.0),
            borderSide: BorderSide(color: _parts.fontColor, width: 3.0)),
        hintText: 'Choose a number of recruiting member',
        hintStyle: TextStyle(color: _parts.fontColor),
        labelText: '*レート',
        labelStyle: TextStyle(color: _parts.fontColor),
      ),
      validator: (String value) => value.isEmpty ? '必須項目です' : null,
    );
  }

  Widget balanceField() {
    return TextFormField(
      style: TextStyle(color: _parts.pointColor),
      enableInteractiveSelection: true,
      controller: balanceController,
      keyboardType: TextInputType.number,
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
        labelText: '*収支',
        labelStyle: TextStyle(color: _parts.fontColor),
      ),
      validator: (String value) => value.isEmpty ? '必須項目です' : null,
    );
  }
}
