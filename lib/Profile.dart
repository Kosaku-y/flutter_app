import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app2/Entity/Entity.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage(User user, int mode, String userId);

  final int OTHER = 1;
  final int OWN = 0;
  User user;
  PageParts set = PageParts();
  String UserId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: set.backGroundColor,
        appBar: AppBar(
          title: Text("Profile"),
        ),
        body: Card(
          elevation: 4.0,
          margin: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //Image.asset('assets/neko1_600x400.jpg'),
              _titleArea(),
            ],
          ),
        ));
  }

  Widget _titleArea() {
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
