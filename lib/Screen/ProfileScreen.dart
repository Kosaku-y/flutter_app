import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app2/Util/ScreenParts.dart';
import 'package:flutter_app2/Entity/User.dart';

/*----------------------------------------------

プロフィールScreenクラス(Stateless)

----------------------------------------------*/

class ProfileScreen extends StatelessWidget {
  final User user;
  final String userId;
  final String userName;
  ProfileScreen({Key key, @required this.user, this.userId, this.userName}) : super(key: key);

  final ScreenParts _parts = ScreenParts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _parts.appBar(title: "プロフィール詳細"),
      backgroundColor: _parts.backGroundColor,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
        child: Column(
          children: <Widget>[
            Center(child: _avatarLayout(), heightFactor: 1.5),
            Divider(color: _parts.pointColor, height: 4.0),
            _listElement("名前", userName),
            _parts.backButton(context)
          ],
        ),
      ),
    );
  }

  Widget _listElement(String title, content) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(title, style: TextStyle(color: Colors.grey, fontSize: 18.0)),
          trailing: Text(content, style: TextStyle(color: _parts.pointColor, fontSize: 18.0)),
        ),
        Divider(color: _parts.pointColor, height: 4.0),
      ],
    );
  }

  Widget _avatarLayout() {
    return InkWell(
      child: CircleAvatar(
        radius: 60.0,
        backgroundColor: _parts.iconColor,
        //backgroundImage: NetworkImage(entry.userImageUrl),
        child: Text(userName[0], style: TextStyle(fontSize: 30)),
      ),
      onTap: () => null,
    );
  }
}
