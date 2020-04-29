import 'package:flutter/material.dart';
import 'package:flutter_app2/PageParts.dart';
import 'package:flutter_app2/Entity/Score.dart';
import 'package:flutter_app2/Repository/LocalDataRepository.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'Parts/AnalyzeScreenParts.dart';
import 'ScoreInputScreen.dart';

/*----------------------------------------------

スコア管理Screenクラス

----------------------------------------------*/

class ScoreManageScreen extends StatefulWidget {
  ScoreManageScreen({Key key}) : super(key: key);

  State<StatefulWidget> createState() {
    return new ScoreManageScreenState();
  }
}

class ScoreManageScreenState extends State<ScoreManageScreen> with TickerProviderStateMixin {
  TabController _tabController;
  final PageParts _parts = new PageParts();
  CalendarController _calendarController;
  Map<DateTime, List<Score>> _events;
  List<Score> _selectedEvents;
  Map<DateTime, dynamic> scoreMap;
  LocalDataRepository repository;
  DateTime _selectedDay = DateTime.now();
  ScoreAnalyze analyze;
  var formatter = DateFormat(DateFormat.YEAR_MONTH_WEEKDAY_DAY);
  int grid = 50;
  List<FlSpot> _lineData;

  bool showAvg = false;
  List<Color> gradientColors;

  List<Tab> tabs = <Tab>[Tab(text: '記録'), Tab(text: "分析")];

  @override
  void initState() {
    super.initState();
    repository = LocalDataRepository();
    _calendarController = CalendarController();
    _events = {};
    _lineData = [];
    reFleshEventList();
    DateTime today = DateTime.now();
    _selectedDay = DateTime(today.year, today.month, today.day, 21).toUtc();
    _selectedEvents = _events[_selectedDay] ?? [];
    initializeDateFormatting('ja_JP');
    _tabController = TabController(length: tabs.length, vsync: this);
    gradientColors = [_parts.startGradient, _parts.endGradient];
  }

  void reFleshEventList() async {
    Map<DateTime, List<Score>> map = await repository.getScoreMap();
    setState(() {
      _events = map;
      _selectedEvents = _events[_selectedDay] ?? [];
      if (map.isNotEmpty) analyze = ScoreAnalyze.fromMap(map);
      dataCleansing();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        elevation: 2.0,
        gradient: LinearGradient(colors: [_parts.startGradient, _parts.endGradient]),
        title: Text('スコア管理', style: TextStyle(color: _parts.pointColor)),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.menu), onPressed: () => _showModalBottomSheet())
        ],
        bottom: TabBar(
          //isScrollable: true,
          tabs: tabs,
          controller: _tabController,
          unselectedLabelColor: Colors.grey,
          labelColor: _parts.pointColor,
        ),
      ),
      backgroundColor: _parts.backGroundColor,
      body: TabBarView(controller: _tabController, children: <Widget>[
        _record(),
        _analyze(),
      ]),
      floatingActionButton: _parts.floatButton(
        icon: Icons.add,
        onPressed: () {
          showBarModalBottomSheet(
              context: context,
              builder: (context, scrollController) {
                return ScoreInputScreen();
              });
        },
      ),
    );
  }

  /*---------記録---------*/
  Widget _record() {
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

  /*---------総合成績---------*/
  Widget _analyze() {
    TextStyle textStyle = TextStyle(color: _parts.pointColor, fontSize: 20.0);
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: _events.length == 0
          ? Container(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(child: Center(child: Text("データがありません", style: _parts.guideWhite))),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
//                  Text("総得点の推移", style: textStyle),
//                  totalLineGraph(),
                  Container(
                    decoration: BoxDecoration(
                      border: new Border.all(color: _parts.pointColor),
                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: SizedBox(
                      width: 400,
                      height: 200,
                      child: PointsLineChart.withSampleData(),
                    ),
                  ),
                  Row(children: [
                    Container(
                      decoration: BoxDecoration(
                        border: new Border.all(color: _parts.pointColor),
                        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: const EdgeInsets.all(7.0),
                              child: Text("着順", style: _parts.basicWhite)),
                          SizedBox(
                              width: 190,
                              height: 200,
                              child: RankPieChart.withSampleData(analyze.rankingList)),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: new Border.all(color: _parts.pointColor),
                        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: const EdgeInsets.all(7.0),
                              child: Text("着順", style: _parts.basicWhite)),
                          SizedBox(
                              width: 190,
                              height: 200,
                              child: RankPieChart.withSampleData(analyze.rankingList)),
                        ],
                      ),
                    ),
                  ]),
                  //rankPercentage(),
                  aboutRankingRate()
                ],
              ),
            ),
    );
  }

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

  List<FlSpot> dataCleansing() {
    _lineData = [];
    int yAxis = 1;
    int sum = 0;
    _events.forEach((key, value) {
      value.forEach((element) => sum += element.total);
      _lineData.add(FlSpot(yAxis.toDouble(), sum.toDouble()));
      yAxis++;
    });
    grid = (analyze.maxPoint - analyze.minPoint) ~/ 5;
    return _lineData;
  }

  Widget totalLineGraph() {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(18))),
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
              child: LineChart(
                //showAvg ? avgData() : mainData(),
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    drawHorizontalLine: true,
                    checkToShowHorizontalLine: (value) {
                      return value == 0 || value == analyze.minPoint || value == analyze.maxPoint;
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    leftTitles: SideTitles(
                      showTitles: true,
                      textStyle: TextStyle(
                          color: const Color(0xff67727d),
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                      getTitles: (value) {
                        if (value == 0 || value == analyze.minPoint || value == analyze.maxPoint) {
                          return value.toString();
                        } else {
                          return '';
                        }
                      },
                      reservedSize: 28,
                      margin: 12,
                    ),
                  ),
                  borderData: FlBorderData(
                      show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
                  maxY: analyze.maxPoint + grid,
                  minY: analyze.minPoint - grid,
                  minX: 0,
                  maxX: (_lineData.length + 1).toDouble(),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _lineData,
                      //isCurved: true,
                      colors: gradientColors,
                      barWidth: 5,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                          show: true,
                          colors: gradientColors.map((color) => color.withOpacity(0.3)).toList()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 60,
          height: 34,
          child: FlatButton(
            onPressed: () {
              setState(() {
                //showAvg = !showAvg;
              });
            },
            child: Text('avg',
                style: TextStyle(
                    fontSize: 12, color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget aboutRankingRate() {
    double avoidFourthPercent = (analyze.avoidFourthRate * 10000).roundToDouble() / 10000;
    double associationPercent = (analyze.associationRate * 10000).roundToDouble() / 10000;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5.0),
            child: LinearPercentIndicator(
              width: 200,
              animation: true,
              leading: Text("４着回避率：", style: TextStyle(color: _parts.pointColor, fontSize: 15.0)),
              lineHeight: 20.0,
              animationDuration: 2000,
              percent: avoidFourthPercent,
              center: Text("${avoidFourthPercent * 100}%"),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Color(0xffb39ddb),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: LinearPercentIndicator(
              width: 200,
              animation: true,
              leading: Text("連対率　　：", style: TextStyle(color: _parts.pointColor, fontSize: 15.0)),
              lineHeight: 20.0,
              animationDuration: 2000,
              percent: associationPercent,
              center: Text("${associationPercent * 100}%"),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Color(0xffb39ddb),
            ),
          )
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
                repository.resetScore();
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
