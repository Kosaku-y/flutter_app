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
  final int mode;
  final EventDetail oldEvent;
  final EventDetail event;
  final String stationCode;
  static const int register = 0;
  AdvertisementScreen(
      {Key key,
      @required this.mode,
      @required this.event,
      @required this.stationCode,
      this.oldEvent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EventManageBloc bloc = EventManageBloc();
    mode == register
        ? bloc.callCreateEvent(stationCode, event)
        : bloc.callModifyEvent(oldEvent.pref, oldEvent.station, stationCode, event);
    return Scaffold(
      appBar: _parts.appBar(title: "完了"),
      backgroundColor: _parts.backGroundColor,
      body: StreamBuilder<bool>(
        stream: bloc.eventStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            myCallback(() => Navigator.pop(context, snapshot.error));
            print(snapshot.error);
            return Center(child: Text("エラーが発生しました", style: _parts.guideWhite));
          }
          if (snapshot.connectionState == ConnectionState.waiting) return _parts.indicator;
          if (!snapshot.hasData) {
            return Center(child: Text("データがありません", style: _parts.basicWhite)); //データempty
          } else {
            return Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: Center(
                          child: Text("イベントの${mode == register ? "作成" : "変更"}が完了しました",
                              style: _parts.basicWhite))),
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
