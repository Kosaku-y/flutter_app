import 'package:flutter/material.dart';
import 'package:flutter_app2/Repository/LocalDataRepository.dart';
import 'package:flutter_app2/Entity/PageParts.dart';
import 'package:flutter_app2/Entity/Score.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

/*----------------------------------------------

スコア入力ページクラス

----------------------------------------------*/

/*
* String date; //日付,primaryKey
  int ranking; //順位
  int chip; //チップ
  int total; //最終得点
  int rate; //レート
  int balance; //収入
* */
class ScoreInputScreen extends StatefulWidget {
  ScoreInputScreen({Key key}) : super(key: key);
  State<StatefulWidget> createState() {
    return new ScoreInputScreenState();
  }
}

class ScoreInputScreenState extends State<ScoreInputScreen> {
  final PageParts _parts = new PageParts();
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
      appBar: _parts.appBar(title: "スコア入力"),
      backgroundColor: _parts.backGroundColor,
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: <Widget>[
            dateField(),
            rankingField(),
            chipField(),
            totalField(),
            rateField(),
            balanceField(),
            _parts.iconButton(
                message: "記録する",
                icon: Icons.send,
                onPressed: () {
                  submit();
                }),
          ],
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
          backgroundColor: Colors.white,
          headercolor: Colors.white,
          cancelText: "戻る",
          confirmText: "確定",
          cancelTextStyle: TextStyle(color: Colors.black, fontSize: 15.0),
          confirmTextStyle: TextStyle(color: Colors.black, fontSize: 15.0),
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
            icon: Icon(
              Icons.calendar_today,
              color: _parts.fontColor,
            ),
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
    return TextFormField(
      style: TextStyle(color: _parts.pointColor),
      enableInteractiveSelection: false,
      controller: rankingController,
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
        labelText: '*着順',
        labelStyle: TextStyle(color: _parts.fontColor),
      ),
      validator: (String value) {
        return value.isEmpty ? '必須項目です' : null;
      },
    );
  }

  Widget chipField() {
    return TextFormField(
      style: TextStyle(color: _parts.pointColor),
      enableInteractiveSelection: false,
      controller: chipController,
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
        labelText: '*チップ',
        labelStyle: TextStyle(color: _parts.fontColor),
      ),
      validator: (String value) {
        return value.isEmpty ? '必須項目です' : null;
      },
    );
  }

  Widget totalField() {
    return TextFormField(
      style: TextStyle(color: _parts.pointColor),
      enableInteractiveSelection: false,
      controller: totalController,
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
        labelText: '*トータル',
        labelStyle: TextStyle(color: _parts.fontColor),
      ),
      validator: (String value) {
        return value.isEmpty ? '必須項目です' : null;
      },
    );
  }

  Widget rateField() {
    return TextFormField(
      style: TextStyle(color: _parts.pointColor),
      enableInteractiveSelection: false,
      controller: rateController,
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
        labelText: '*レート',
        labelStyle: TextStyle(color: _parts.fontColor),
      ),
      validator: (String value) {
        return value.isEmpty ? '必須項目です' : null;
      },
    );
  }

  Widget balanceField() {
    return TextFormField(
      style: TextStyle(color: _parts.pointColor),
      enableInteractiveSelection: false,
      controller: balanceController,
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
      validator: (String value) {
        return value.isEmpty ? '必須項目です' : null;
      },
    );
  }
}
