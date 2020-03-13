import 'package:flutter/material.dart';
import 'package:flutter_app2/Repository/LocalDataRepository.dart';
import 'package:flutter_app2/Entity/PageParts.dart';
import 'package:flutter_app2/Entity/Score.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
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
class ScoreInputPage extends StatefulWidget {
  ScoreInputPage({Key key}) : super(key: key);
  State<StatefulWidget> createState() {
    return new ScoreInputPageState();
  }
}

class ScoreInputPageState extends State<ScoreInputPage> {
  PageParts set = new PageParts();
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
      appBar: AppBar(
          elevation: 2.0,
          backgroundColor: set.baseColor,
          title: Text('スコア入力', style: TextStyle(color: set.pointColor))),
      backgroundColor: set.backGroundColor,
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
            set.iconButton(
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
        formatter.format(_date),
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
        DatePicker.showDatePicker(context,
            showTitleActions: true,
            theme: DatePickerTheme(
              backgroundColor: Colors.white,
              itemStyle: TextStyle(color: Colors.black),
              doneStyle: TextStyle(color: Colors.black),
            ), onConfirm: (date) {
          setState(() {
            _date = date;
            dateController.text = formatter.format(date);
          });
        }, currentTime: DateTime.now(), locale: LocaleType.en);
      },
      child: AbsorbPointer(
        child: new TextFormField(
          style: TextStyle(color: set.pointColor),
          enableInteractiveSelection: false,
          controller: dateController,
          decoration: InputDecoration(
            icon: Icon(
              Icons.calendar_today,
              color: set.fontColor,
            ),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
                borderSide: BorderSide(color: set.fontColor, width: 3.0)),
            hintText: 'Choose a starting Time',
            labelText: '*日時',
            labelStyle: TextStyle(color: set.fontColor),
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
      style: TextStyle(color: set.pointColor),
      enableInteractiveSelection: false,
      controller: rankingController,
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
        labelText: '*着順',
        labelStyle: TextStyle(color: set.fontColor),
      ),
      validator: (String value) {
        return value.isEmpty ? '必須項目です' : null;
      },
    );
  }

  Widget chipField() {
    return TextFormField(
      style: TextStyle(color: set.pointColor),
      enableInteractiveSelection: false,
      controller: chipController,
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
        labelText: '*チップ',
        labelStyle: TextStyle(color: set.fontColor),
      ),
      validator: (String value) {
        return value.isEmpty ? '必須項目です' : null;
      },
    );
  }

  Widget totalField() {
    return TextFormField(
      style: TextStyle(color: set.pointColor),
      enableInteractiveSelection: false,
      controller: totalController,
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
        labelText: '*トータル',
        labelStyle: TextStyle(color: set.fontColor),
      ),
      validator: (String value) {
        return value.isEmpty ? '必須項目です' : null;
      },
    );
  }

  Widget rateField() {
    return TextFormField(
      style: TextStyle(color: set.pointColor),
      enableInteractiveSelection: false,
      controller: rateController,
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
        labelText: '*レート',
        labelStyle: TextStyle(color: set.fontColor),
      ),
      validator: (String value) {
        return value.isEmpty ? '必須項目です' : null;
      },
    );
  }

  Widget balanceField() {
    return TextFormField(
      style: TextStyle(color: set.pointColor),
      enableInteractiveSelection: false,
      controller: balanceController,
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
        labelText: '*収支',
        labelStyle: TextStyle(color: set.fontColor),
      ),
      validator: (String value) {
        return value.isEmpty ? '必須項目です' : null;
      },
    );
  }
}
