import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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

  Widget backButton({Function() onTap}) {
    return RaisedButton.icon(
      label: Text("戻る"),
      icon: Icon(
        Icons.arrow_back_ios,
        color: fontColor,
      ),
      onPressed: onTap != null
          ? () => onTap()
          : () {
              print('Not set');
            },
    );
  }
}
