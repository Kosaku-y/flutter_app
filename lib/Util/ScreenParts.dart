import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

/*----------------------------------------------

共通部品クラス

----------------------------------------------*/
class ScreenParts {
  //案1
  final Color baseColor = Color(0xff160840);
  final Color backGroundColor = Color(0xff00152d);
  final Color fontColor = Color(0xff00A968);
  final Color pointColor = Colors.white;
  final Color startGradient = Color(0xff8e24aa);
  final Color endGradient = Color(0xff311b92);
  final Color iconColor = Color(0xff7c4dff);
  final Color hintColor = Colors.grey;

  final ThemeData defaultTheme = ThemeData(
    backgroundColor: Color(0xff00152d),
    scaffoldBackgroundColor: Color(0xff00152d),
    bottomAppBarColor: Color(0xff160840),
    selectedRowColor: Color(0xff00A968),
    dividerColor: Color(0xff00A968),
  );

  final ThemeData light = new ThemeData.light();

  final ThemeData dark = new ThemeData.dark();

  Widget indicator = SpinKitWave(color: Colors.white, size: 50.0);

  final TextStyle basicWhite = TextStyle(color: Colors.white, fontSize: 18.0);
  final TextStyle basicBlack = TextStyle(color: Colors.black, fontSize: 18.0);
  final TextStyle basicGreen = TextStyle(color: Color(0xff00A968), fontSize: 18.0);
  final TextStyle guideWhite = TextStyle(color: Colors.white, fontSize: 15.0);
  final TextStyle guideBlack = TextStyle(color: Colors.black, fontSize: 15.0);

  Widget appBar({String title}) {
    return GradientAppBar(
        title: Text(title, style: TextStyle(color: pointColor)),
        gradient: LinearGradient(colors: [startGradient, endGradient]));
  }

  Widget appBarNormal({String title}) {
    return AppBar(
      elevation: 2.0,
      backgroundColor: baseColor,
      title: Text(title, style: TextStyle(color: pointColor)),
    );
  }

  Widget backButton(BuildContext context) {
    return RaisedButton.icon(
        label: Text("戻る"),
        icon: Icon(Icons.keyboard_backspace, color: fontColor),
        onPressed: () => Navigator.pop(context));
  }

  Widget iconButton({String message, IconData icon, Function() onPressed}) {
    return RaisedButton.icon(
      label: Text(message),
      icon: Icon(icon, color: fontColor),
      onPressed: onPressed != null ? () => onPressed() : () => print('Not set'),
    );
  }

  Widget floatButton({IconData icon, Function() onPressed}) {
    return Ink(
      decoration: ShapeDecoration(
        color: fontColor,
        shape:
            CircleBorder(side: BorderSide(color: pointColor, width: 1.0, style: BorderStyle.solid)),
      ),
      child: IconButton(
          icon: Icon(icon, color: pointColor), color: Colors.white, onPressed: onPressed),
    );
  }

  Picker picker(
      {PickerAdapter adapter, int selected, Function(Picker picker, List<int> value) onConfirm}) {
    return Picker(
      itemExtent: 40.0,
      height: 200.0,
      backgroundColor: baseColor,
      headerDecoration: BoxDecoration(color: baseColor),
      //changeToFirst: false,
      cancelText: "戻る",
      confirmText: "確定",
      textStyle: TextStyle(color: pointColor, fontSize: 18.0),
      cancelTextStyle: TextStyle(color: pointColor, fontSize: 15.0),
      confirmTextStyle: TextStyle(color: pointColor, fontSize: 15.0),
      adapter: adapter,
      selecteds: [selected],
      onConfirm: onConfirm,
    );
  }

  Picker dateTimePicker(
      {PickerAdapter adapter, Function(Picker picker, List<int> value) onConfirm}) {
    return Picker(
      itemExtent: 40.0,
      height: 200.0,
      headerDecoration: BoxDecoration(color: baseColor),
      backgroundColor: baseColor,
      cancelText: "戻る",
      confirmText: "確定",
      textStyle: TextStyle(color: pointColor, fontSize: 18.0),
      cancelTextStyle: TextStyle(color: pointColor, fontSize: 15.0),
      confirmTextStyle: TextStyle(color: pointColor, fontSize: 15.0),
      delimiter: [
        PickerDelimiter(
            column: 4,
            child: Container(
              width: 5.0,
              alignment: Alignment.center,
              child: Text(':', style: TextStyle(color: pointColor, fontWeight: FontWeight.bold)),
              color: baseColor,
            ))
      ],
      adapter: adapter,
      onConfirm: onConfirm,
    );
  }

  AwesomeDialog dialog(BuildContext context) {
    return AwesomeDialog(
      context: context,
      animType: AnimType.SCALE,
      dialogType: DialogType.ERROR,
      body: Center(
        child: Text(
          'If the body is specified, then title and description will be ignored, this allows to further customize the dialogue.',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      tittle: 'This is Ignored',
      desc: 'This is also Ignored',
      btnOkOnPress: () {
        Navigator.pop(context);
      },
    );
  }

  ModalProgressHUD modalProgress({Widget child, bool inAsyncCall}) {
    return ModalProgressHUD(child: child, inAsyncCall: inAsyncCall, progressIndicator: indicator);
  }
}
