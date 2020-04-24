import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Bloc/EventManageBloc.dart';
import 'package:flutter_app2/Entity/EventDetail.dart';
import 'package:flutter_app2/PageParts.dart';

/*----------------------------------------------

AdvertisementScreenクラス(Stateless)

----------------------------------------------*/

class AdvertisementScreen extends StatelessWidget {
  final PageParts _parts = PageParts();
  final EventDetail event;
  final String stationCode;
  AdvertisementScreen({Key key, @required this.event, @required this.stationCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EventManageBloc bloc = EventManageBloc()..callCreateEvent(stationCode, event);
    return Scaffold(
      appBar: _parts.appBar(title: "完了"),
      backgroundColor: _parts.backGroundColor,
      body: StreamBuilder<bool>(
        stream: bloc.newEventStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            myCallback(() => Navigator.pop(context, snapshot.error));
            print(snapshot.error);
            return Center(child: Text("エラーが発生しました。", style: _parts.guideWhite));
          }
          if (snapshot.connectionState == ConnectionState.waiting) return _parts.indicator;
          if (!snapshot.hasData) {
            return Text("Data is Empty", style: _parts.basicWhite); //データempty
          } else {
            return Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Expanded(child: Center(child: Text("イベントの作成が完了しました", style: _parts.basicWhite))),
                  Container(padding: const EdgeInsets.all(50.0), child: _parts.backButton(context)),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void myCallback(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }
}
