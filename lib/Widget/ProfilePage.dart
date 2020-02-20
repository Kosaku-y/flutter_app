import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app2/Entity/PageParts.dart';
import 'package:flutter_app2/Entity/User.dart';

import 'TalkPage.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key key, @required this.user, this.userId}) : super(key: key);

  User user;
  String userId;

  PageParts set = PageParts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 2.0,
          backgroundColor: set.baseColor,
          title: Text('プロフィール詳細',
              style: TextStyle(
                color: set.pointColor,
              )),
        ),
        backgroundColor: set.backGroundColor,
        body: Container(
          child: new Column(
            children: <Widget>[
              Card(
                elevation: 4.0,
                margin: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    //Image.asset('assets/neko1_600x400.jpg'),
                    _titleArea(context),
                  ],
                ),
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
            ],
          ),
        ));
  }

  Widget _titleArea(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(16.0),
        child: Row(
          // 1行目
          children: <Widget>[
            Expanded(
              // 2.1列目
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    // 3.1.1行目
                    margin: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      "${user.name}",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                  ),
                  Container(
                    // 3.1.2行目
                    child: Text(
                      "${user.age}",
                      style: TextStyle(fontSize: 12.0, color: set.fontColor),
                    ),
                  ),
                  Container(
                      child: InkWell(
                    onTap: () {
                      Navigator.of(context).push<Widget>(
                        MaterialPageRoute(
                          settings: const RouteSettings(name: "/Talk"),
                          builder: (context) => new TalkPage(user: user),
                        ),
                      );
                    },
                    child: Icon(Icons.mail),
                  )),
                ],
              ),
            ),
            Icon(
              // 2.2列目
              Icons.star,
              color: set.pointColor,
            ),
            Text('${user.rank}'), // 2.3列目
          ],
        ));
  }
}
