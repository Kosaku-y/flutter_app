import 'package:flutter/material.dart';
import 'package:flutter_app2/Util/ScreenParts.dart';
import 'package:flutter_app2/Entity/Score.dart';
import 'package:flutter_app2/Repository/LocalDataRepository.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'AnalyzeScreenParts.dart';
import 'ScoreInputScreen.dart';

/*----------------------------------------------

スコア管理Screenクラス

----------------------------------------------*/

class ScoreManageScreen extends StatefulWidget {
  ScoreManageScreen({Key key}) : super(key: key);

  State<StatefulWidget> createState() => ScoreManageScreenState();
}

class ScoreManageScreenState extends State<ScoreManageScreen> with TickerProviderStateMixin {
  TabController _tabController;
  final ScreenParts _parts = ScreenParts();
  CalendarController _calendarController;
  Map<DateTime, List<Score>> _events;
  List<Score> _selectedEvents;
  LocalDataRepository _repository;
  DateTime _selectedDay = DateTime.now();
  ScoreAnalyze _analyze;
  List<int> _lineData;
  List<Tab> _tabs = <Tab>[Tab(text: '記録'), Tab(text: "分析")];

  @override
  void initState() {
    super.initState();
    _repository = LocalDataRepository();
    _calendarController = CalendarController();
    _events = {};
    _lineData = [0];
    reFleshEventList();
    DateTime today = DateTime.now();
    _selectedDay = DateTime(today.year, today.month, today.day, 21).toUtc();
    _selectedEvents = _events[_selectedDay] ?? [];
    initializeDateFormatting('ja_JP');
    _tabController = TabController(length: _tabs.length, vsync: this);
    //_gradientColors = [_parts.startGradient, _parts.endGradient];
  }

  void reFleshEventList() async {
    Map<DateTime, List<Score>> map = await _repository.getScoreMap();
    setState(() {
      _events = map;
      _selectedEvents = _events[_selectedDay] ?? [];
      if (map.isNotEmpty) _analyze = ScoreAnalyze.fromMap(map);
      //dataCleansing();
      createLineGraphData();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        elevation: 2.0,
        gradient: LinearGradient(colors: [_parts.startGradient, _parts.endGradient]),
        title: Text('スコア管理', style: TextStyle(color: _parts.pointColor)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => showBarModalBottomSheet(
                context: context, builder: (context, scrollController) => ScoreInputScreen()),
          ),
          IconButton(icon: Icon(Icons.menu), onPressed: () => _showModalBottomSheet()),
        ],
        bottom: TabBar(
            //isScrollable: true,
            tabs: _tabs,
            controller: _tabController,
            unselectedLabelColor: Colors.grey,
            labelColor: _parts.pointColor),
      ),
      backgroundColor: _parts.backGroundColor,
      body: TabBarView(controller: _tabController, children: <Widget>[
        _recordTab(),
        _analyzeTab(),
      ]),
    );
  }

  /*---------記録タブ---------*/
  Widget _recordTab() {
    return Container(
      padding: const EdgeInsets.only(top: 10.0, right: 20.0, left: 20.0, bottom: 100.0),
      child: Column(
        children: <Widget>[
          _calendar(),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }

  /*---------総合成績タブ---------*/
  Widget _analyzeTab() {
    TextStyle _title = TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600);
    Decoration _decoration = BoxDecoration(
      color: Colors.white,
      border: Border.all(color: _parts.pointColor),
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
    );
    return Container(
        padding: const EdgeInsets.all(10.0),
        child: _events.length == 0
            ? Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(child: Center(child: Text("データがありません", style: _parts.guideWhite))),
                  ],
                ),
              )
            : StaggeredGridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10,
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                children: <Widget>[
                  Container(
                    decoration: _decoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.only(top: 7.0, left: 7.0),
                            child: Text("総得点の推移", style: _title)),
                        SizedBox(height: 200, child: PointsLineChart.withSampleData(_lineData)),
                      ],
                    ),
                  ),
                  Container(
                    decoration: _decoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.only(top: 7.0, left: 7.0),
                            child: Text("得点分析", style: _title)),
                        _analyzePointView()
                      ],
                    ),
                  ),
                  Container(
                    decoration: _decoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.only(top: 7.0, left: 7.0),
                            child: Text("チップ分析", style: _title)),
                        _analyzeChipView()
                      ],
                    ),
                  ),
                  Container(
                    decoration: _decoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 7.0, left: 7.0),
                          child: Text("着順の割合", style: _title),
                        ),
                        SizedBox(
                          height: 180,
                          child: RankPieChart.withSampleData(_analyze.rankingList),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: _decoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.only(top: 7.0, left: 7.0),
                            child: Text("着順分析", style: _title)),
                        aboutRankingRate(),
                      ],
                    ),
                  ),
                ],
                staggeredTiles: [
                  StaggeredTile.extent(2, 250.0),
                  StaggeredTile.extent(1, 200.0),
                  StaggeredTile.extent(1, 200.0),
                  StaggeredTile.extent(2, 220.0),
                  StaggeredTile.extent(2, 130.0),
                ],
              ));
  }

  //カレンダーWidget
  Widget _calendar() {
    Widget _buildEventsMarker(DateTime date, List events, CalendarController controller) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(shape: BoxShape.rectangle, color: Color(0xff7e57c2)),
        width: 16.0,
        height: 16.0,
        child: Center(
          child: Text('${events.length}',
              style: TextStyle().copyWith(color: Colors.white, fontSize: 12.0)),
        ),
      );
    }

    return Container(
      child: Card(
        color: _parts.pointColor,
        child: TableCalendar(
          locale: 'ja_JP',
          events: _events,
          calendarController: _calendarController,
          calendarStyle: CalendarStyle(markersColor: _parts.fontColor),
          onDaySelected: (date, events) {
            if (events.isNotEmpty) {
              setState(() {
                _selectedEvents = events;
                _selectedDay = date;
              });
            }
          },
          builders: CalendarBuilders(
            markersBuilder: (context, date, events, holidays) {
              final children = <Widget>[];
              if (events.isNotEmpty) {
                children.add(Positioned(
                    right: 1,
                    bottom: 1,
                    child: _buildEventsMarker(date, events, _calendarController)));
              }
              return children;
            },
          ),
        ),
      ),
    );
  }

  //イベントリスト
  Widget _buildEventList() {
    int dayIndex = 0;
    return ListView(
      children: _selectedEvents.map((event) {
        dayIndex++;
        return Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0.8),
            borderRadius: BorderRadius.circular(5.0),
            color: _parts.pointColor,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            leading: Text("$dayIndex"),
            title: Text("ポイント:${event.total} チップ:${event.chip} 収支:${event.balance}"),
            onTap: () {
              print('$event tapped!');
            },
          ),
        );
      }).toList(),
    );
  }

  void createLineGraphData() {
    int sum = 0;
    _events.forEach((key, value) {
      value.forEach((element) => sum += element.total);
      _lineData.add(sum);
    });
  }

  Widget aboutRankingRate() {
    AnalyzeScreenParts _analyzeParts = AnalyzeScreenParts();
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: _analyzeParts.percentIndicator("４着回避率：", _analyze.avoidFourthRate)),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: _analyzeParts.percentIndicator("連対率　　：", _analyze.associationRate))
        ],
      ),
    );
  }

  //得点分析
  Widget _analyzePointView() {
    TextStyle _style = TextStyle(fontSize: 15.0);
    return Container(
      padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("平均　　：${(_analyze.totalPoint / _analyze.games).toStringAsFixed(2)}", style: _style),
          Text("合計　　：${(_analyze.totalPoint).toInt()}", style: _style),
          Text("累計最高：${(_analyze.maxPoint).toInt()}", style: _style),
          Text("累計最低：${(_analyze.minPoint).toInt()}", style: _style),
        ],
      ),
    );
  }

  Widget _analyzeChipView() {
    TextStyle _style = TextStyle(fontSize: 15.0);
    return Container(
      padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("平均　　：${(_analyze.totalChip / _analyze.games).toStringAsFixed(2)}", style: _style),
          Text("合計　　：${(_analyze.totalChip).toInt()}", style: _style),
        ],
      ),
    );
  }

  //メニュー
  void _showModalBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.delete_forever, color: Colors.red),
              title: Text('全データを削除', style: TextStyle(color: Colors.red)),
              onTap: () {
                _repository.resetScore();
                reFleshEventList();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _calendarController?.dispose();
  }
}
