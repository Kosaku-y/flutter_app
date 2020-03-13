import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:intl/date_symbol_data_local.dart';

/*----------------------------------------------
部品クラス
----------------------------------------------*/
class PageParts {
  //案1
  var baseColor = Color(0xff160840);
  var backGroundColor = Color(0xff00152d);
  var fontColor = Color(0xff00A968);
  var pointColor = Colors.white;

  ThemeData defaultTheme = ThemeData(
    backgroundColor: Color(0xff00152d),
    scaffoldBackgroundColor: Color(0xff00152d),
    bottomAppBarColor: Color(0xff160840),
    selectedRowColor: Color(0xff00A968),
    dividerColor: Color(0xff00A968),
  );

  ThemeData light = new ThemeData.light();

  ThemeData dark = new ThemeData.dark();

  Widget indicator() {
    return SpinKitWave(
      color: pointColor,
      size: 50.0,
    );
  }

  Widget backButton({Function() onPressed}) {
    return RaisedButton.icon(
      label: Text("戻る"),
      icon: Icon(
        Icons.keyboard_backspace,
        color: fontColor,
      ),
      onPressed: onPressed != null
          ? () => onPressed()
          : () {
              print('Not set');
            },
    );
  }

  Widget iconButton({String message, IconData icon, Function() onPressed}) {
    return RaisedButton.icon(
      label: Text(message),
      icon: Icon(
        icon,
        color: fontColor,
      ),
      onPressed: onPressed,
    );
  }

  Widget floatButton({IconData icon, Function() onPressed}) {
    return Ink(
      decoration: ShapeDecoration(
        color: backGroundColor,
        shape: CircleBorder(
          side: BorderSide(
            color: fontColor,
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: fontColor,
        ),
        color: Colors.white,
        onPressed: onPressed,
      ),
    );
  }

  Picker picker(
      {PickerAdapter adapter, int selected, Function(Picker picker, List<int> value) onConfirm}) {
    return Picker(
      itemExtent: 40.0,
      height: 200.0,
      backgroundColor: Colors.white,
      headercolor: Colors.white,
      //changeToFirst: false,
      cancelText: "戻る",
      confirmText: "確定",
      cancelTextStyle: TextStyle(color: Colors.black, fontSize: 15.0),
      confirmTextStyle: TextStyle(color: Colors.black, fontSize: 15.0),
      adapter: adapter,
      selecteds: [selected],
      onConfirm: onConfirm,
    );
  }
}
