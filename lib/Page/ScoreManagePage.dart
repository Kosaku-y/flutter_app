import 'package:flutter/material.dart';
import 'package:flutter_app2/Entity/PageParts.dart';

import 'ScoreInputPage.dart';

/*----------------------------------------------

スコア管理ページクラス

----------------------------------------------*/

class ScoreManagePage extends StatefulWidget {
  ScoreManagePage({Key key}) : super(key: key);

  State<StatefulWidget> createState() {
    return new ScoreManagePageState();
  }
}

class ScoreManagePageState extends State<ScoreManagePage> {
  PageParts set = new PageParts();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 2.0,
            backgroundColor: set.baseColor,
            title: Text('スコア管理', style: TextStyle(color: set.pointColor))),
        backgroundColor: set.backGroundColor,
        body: Container(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: <Widget>[
              _calendar(),
              _lineChart(),
            ],
          ),
        ),
        floatingActionButton: set.floatButton(
            icon: Icons.add,
            onPressed: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).push<Widget>(
                MaterialPageRoute(
                  settings: const RouteSettings(name: "/ScoreInput"),
                  builder: (context) => ScoreInputPage(),
                  fullscreenDialog: true,
                ),
              );
            }));
  }
}

Widget _calendar() {
  return Container();
}

Widget _lineChart() {
  return Container();
}
