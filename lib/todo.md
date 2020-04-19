


#最優先バグ事項
-未登録ユーザーがログインしようとすると落ちる
->ログインプロセスの見直し
LoginBloc
var user = await repository.checkFireBaseLogin(fireBaseUser);
-トーク処理


#To do
*文言日本語化
*変数整理(final const)
*ワーニング除去
*非同期処理(Indicator)
*db処理 try-catch
*theme
*profile画面の作成
*フォームフォーカス
*キーボードタイプ


~~-DateTimePickerの受け取り型と渡し型~~
~~-flutter_datetime_pickerのパッケージビルドエラー~~
~~-Home画面の遷移後の snackBar~~
->無理そう
~~-piechart stateless化~~
~~-カレンダーの当日イベントが表示されない~~
~~api変更~~
-Picker 都道府県->路線->都道府県 エラー(validate)
~~-駅すぱあとapiコール時差問題~~
-NewHomeの改善
-自身のイベント管理
-themeでレイアウト色管理
-google admob
-イベント作成ページの画面遷移
-路線検索ができない
	→路線検索：駅の路線APIを使えば、なんとかなりそう
-別の認証間で同じIDは？(.->[dot]はエスケープ処理いらないかもしれないからそのままでいいかも)
-戦績管理(Preferenceshared)
-DBルール制約
-プッシュ通知
-firebase 複数クエリのトランザクション、ロールバック
-bottomnavigation バッジ


-Talk　　
・User/room/userId 検索 -> roomId
        -リンクから
            -新規
            ・TalkRoomManagerから取得
            ・User/userID/roomに採番したroomIdをadd
            ・トーク相手のUser/userID/roomに採番したroomIdをadd
            ・Room/roomIdにmembersをadd
            -既存
            ・roomIdからroom表示
        -トーク履歴から
            -既存
            ・roomIdからroom表示
            
              




[Preferenceshared](https://medium.com/better-programming/flutter-how-to-save-objects-in-sharedpreferences-b7880d0ee2e4)


覚え書き

-a ??= b 
--aがnullならb代入

-b = a ?? b
--aがnullでなければa nullであればbを代入



 
--変数の変化(状態の変化)によってwidgetが変わる場合setState呼んで値を変える
->bloc を使ったり、providerやInheritedWidgetを使うことによって回避できる

-StreamBuilder 非同期処理の更新する変数が変化する度にウィジェットをbuildし直すBuilder
-FutureBuilder 指定した非同期処理の完了を待つBuilder
Future
非同期処理
値を取得すると処理が終了
Stream
非同期処理
ストリームが開いている間、ずっと値が流れてくる
--
```dart
child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text("指定の条件では見つかりませんでした。", style: guideStyle),
                    ),
                  ),
                  _parts.backButton(onPressed: () {
                    Navigator.pop(context);
                  }),
                ],
              ),
  Future<String> _getFutureValue() async {
    // 擬似的に通信中を表現するために１秒遅らせる
    await Future.delayed(
      Duration(seconds: 1),
    );

    try {
      // 必ずエラーを発生させる
        throw Exception("データの取得に失敗しました");
    } catch (error) {
      return Future.error(error);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FutureBuilder Demo'),
      ),
      body: Center(
        child: FutureBuilder(
          future: _getFutureValue(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            // エラー発生時はエラーメッセージを表示
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            // 通信中はスピナーを表示
            if (snapshot.connectionState != ConnectionState.active) {
            }



            // データがnullでないかチェック
            if (snapshot.hasData) {
              return Text(snapshot.data);
            } else {
              return Text("データが存在しません");
            }
          },
        ),
      ),
    );
  }

/*
import 'package:firebase_admob/firebase_admob.dart';

// 広告ターゲット
  String bannerId = "ca-app-pub-3866258831627989/4610309915";
  BannerAd myBanner = BannerAd(
    // テスト用のIDを使用
    // リリース時にはIDを置き換える必要あり
    adUnitId: "ca-app-pub-3866258831627989/4610309915",
    size: AdSize.smartBanner,
    targetingInfo: MobileAdTargetingInfo(
      keywords: <String>['flutterio', 'beautiful apps'],
      //contentUrl: 'https://flutter.io',
      childDirected: false,
      testDevices: <String>[], // Android emulators are considered test devices
    ),
    listener: (MobileAdEvent event) {
      // 広告の読み込みが完了
      print("BannerAd event is $event");
    },
  );
    @override
      void initState() {
        super.initState();
        // インスタンスを初期化
        FirebaseAdMob.instance.initialize(appId: bannerId);
    
        // バナー広告を表示する
        myBanner
          ..load()
          ..show(
            // ボトムからのオフセットで表示位置を決定
            anchorOffset: 50.0,
            anchorType: AnchorType.bottom,
          );
      }
      @override
      void dispose() {
        super.dispose();
        myBanner.dispose();
        }
*/
  ```
finalやconstはなるべく使う
https://oar.st40.xyz/article/265

https://note.com/shogoyamada/n/n3b752f2adf2e
1.setStateを使わない
2.StatelessWidgetを使う
3.変更がないWidgetにはConstをつける
*/

路線
http://api.ekispert.jp/v1/json/operationLine?prefectureCode=13&offset=1&limit=100&gcs=tokyo&key=LE_UaP7Vyjs3wQPa

駅
http://api.ekispert.jp/v1/json/station?operationLineCode=98&offset=1&limit=100&direction=up&gcs=tokyo&key=key=LE_UaP7Vyjs3wQPa



```txt
{
  "users": {
    "shiroyama": { "name": "Fumihiko Shiroyama", "room":["R0":{UserName:"",userID:"",nonRead:"",timestamp:""},"Room":"R2"]},
    "tanaka": { ... },
    "sato": { ... }
  },
  "TalkRoomManager":"3"
  "rooms": {
    "R0":{
        "title": "チャットルーム0",
        "members": {
          "userId":userName,
        "timestamp":373333333
    }
    "R1": {
      "title": "チャットルーム1",
      "members": {
        "member01": "shiroyama",
        "member02": "tanaka"
      }
    },
    "R2": { ... }
  },
  "messages": {
    "room01": {
      "キー01": {
        "sender": "shiroyama",
        "message": "こんにちは。誰かいますか？"
      },
      "キー02": {
        "sender": "tanaka",
        "message": "はい，いますよ。"
      },
      "message03": { ... }
    },
    "room02": { ... }
  }
}
```

```dart
import 'package:flutter/material.dart';
import 'package:flutter_app2/Bloc/LocalDataBloc.dart';
import 'package:flutter_app2/PageParts.dart';
import 'package:flutter_app2/Entity/Score.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class ProviderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<LocalDataBloc>(
      create: (_) => LocalDataBloc(),
      dispose: (_, bloc) => bloc.dispose(),
      child: _container(),
    );
  }

  Widget _container() {
    return Consumer<LocalDataBloc>(
      builder: (_, bloc, __) {
        bloc.callMapSink.add(null);
        return ScoreManagePage2();
      },
    );
  }
}

class ScoreManagePage2 extends StatelessWidget {
  PageParts set = new PageParts();
  Map<DateTime, List<Score>> _events;
  List _selectedEvents;
  CalendarController _calendarController;
  Map<DateTime, dynamic> scoreMap;
  DateTime selectedDay;
  var formatter = DateFormat(DateFormat.YEAR_MONTH_WEEKDAY_DAY);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<LocalDataBloc>(context);
    return StreamBuilder<Map<String, List<Score>>>(
      stream: bloc.scoreMapStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return set.indicator();
        } else {
          _events = {};
          snapshot.data.forEach((k, v) {
            _events[formatter.parse(k)] = v;
          });
          _selectedEvents = _events[selectedDay] ?? [];
          _calendarController = CalendarController();
          return Column(
            children: <Widget>[
              _calendar(),
              const SizedBox(height: 8.0),
              Expanded(
                child: _buildEventList(),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _calendar() {
    return Container(
      child: Card(
        color: set.pointColor,
        child: TableCalendar(
          locale: 'ja_JP',
          events: _events,
          calendarController: _calendarController,
          calendarStyle: CalendarStyle(
            markersColor: set.fontColor,
          ),
          onDaySelected: (date, events) {
            _onDaySelected(date, events);
          },
        ),
      ),
    );
  }

  void _onDaySelected(DateTime day, List<dynamic> events) {
    //_calendarController.setSelectedDay(DateTime(day.year, day.month, day.day));
    selectedDay = DateTime(day.year, day.month, day.day);
    _selectedEvents = _events[selectedDay] ?? [];
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map(
            (event) => Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.8),
                borderRadius: BorderRadius.circular(12.0),
                color: set.pointColor,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: ListTile(
                title: Text(event.date),
                onTap: () => print('$event tapped!'),
              ),
            ),
          )
          .toList(),
    );
  }
}

```
