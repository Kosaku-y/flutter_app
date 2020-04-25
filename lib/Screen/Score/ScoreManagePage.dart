import 'package:flutter/material.dart';
import 'package:flutter_app2/PageParts.dart';
import 'package:flutter_app2/Entity/Score.dart';
import 'package:flutter_app2/Repository/LocalDataRepository.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'ScoreInputScreen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
  SolidController _solidController = SolidController();
  Map<DateTime, List<Score>> _events;
  List<Score> _selectedEvents;
  Map<DateTime, dynamic> scoreMap;
  LocalDataRepository repository;
  DateTime _selectedDay = DateTime.now();
  ScoreAnalyze analyze;
  var formatter = DateFormat(DateFormat.YEAR_MONTH_WEEKDAY_DAY);
  int grid = 50;
  List<FlSpot> _lineData;
//  final _selectedDay =
//      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 21).toUtc();

  bool showAvg = false;
  List<Color> gradientColors;

  List<Tab> tabs = <Tab>[Tab(text: '月別'), Tab(text: "総合")];

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
            labelColor: _parts.pointColor),
      ),
      backgroundColor: _parts.backGroundColor,
      body: TabBarView(controller: _tabController, children: <Widget>[
        _byPeriod(),
        _bySynthesis(),
      ]),
      floatingActionButton: _parts.floatButton(
        icon: Icons.add,
        onPressed: () {
          _solidController.isOpened ? _solidController.hide() : _solidController.show();
        },
      ),
      bottomSheet: SolidBottomSheet(
          headerBar: Container(),
          canUserSwipe: true,
          draggableBody: true,
          controller: _solidController,
          maxHeight: 500,
          body: ScoreInputScreen()),
    );
  }

/*---------月別---------*/
  Widget _byPeriod() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          _calendar(),
          const SizedBox(height: 8.0),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }

  /*---------総合成績---------*/
  Widget _bySynthesis() {
    TextStyle textStyle = TextStyle(color: _parts.pointColor, fontSize: 20.0);
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: _events.length == 0
          ? Text("No Data")
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("総得点の推移", style: textStyle),
                totalLineGraph(),
                rankPercentage(),
                aboutRankingRate()
//                Container(
//                  decoration: BoxDecoration(
//                    border: new Border.all(color: _parts.fontColor),
//                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
//                  ),
//                  child: Column(children: <Widget>[rankPercentage()]),
//                ),
//                Container(
//                  decoration: BoxDecoration(
//                    border: new Border.all(color: _parts.fontColor),
//                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
//                  ),
//                  child: aboutRankingRate(),
//                ),
              ],
            ),
    );
  }

  Widget _calendar() {
    return Container(
      child: Card(
        color: _parts.pointColor,
        child: TableCalendar(
          locale: 'ja_JP',
          events: _events,
          calendarController: _calendarController,
          calendarStyle: CalendarStyle(
            markersColor: _parts.fontColor,
          ),
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
                children.add(
                  Positioned(
                      right: 1,
                      bottom: 1,
                      child: _buildEventsMarker(date, events, _calendarController)),
                );
              }
              return children;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEventList() {
    int i = 0;
    return ListView(
      children: _selectedEvents.map((event) {
        i++;
        return Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0.8),
            borderRadius: BorderRadius.circular(5.0),
            color: _parts.pointColor,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            title: Text("$i　ポイント:${event.total} チップ:${event.chip} 収支:${event.balance}"),
            onTap: () {
              print('$event tapped!');
            },
          ),
        );
      }).toList(),
    );
  }

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

  List<FlSpot> dataCleansing() {
    _lineData = [];
    int i = 1;
    int sum = 0;
    _events.forEach((key, value) {
      value.forEach((element) {
        sum += element.total;
      });
      _lineData.add(FlSpot(i.toDouble(), sum.toDouble()));
      i++;
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
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(18),
              ),
            ),
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
            child: Text(
              'avg',
              style: TextStyle(
                  fontSize: 12, color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget rankPercentage() {
    return PieChart(
      PieChartData(
          borderData: FlBorderData(show: false),
          sectionsSpace: 0,
          centerSpaceRadius: 30,
          startDegreeOffset: -90,
          sections: showingSections()),
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

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final double fontSize = 16;
      final double radius = 50;
      final TextStyle _label =
          TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: _parts.pointColor);
      double rate;

      switch (i) {
        case 0:
          rate = analyze.rankingList[0] * 100 / analyze.games * 10.roundToDouble() / 10;
          return PieChartSectionData(
            color: Color(0xff6200ea),
            value: rate,
            title: rate != 0 ? '1着' : '',
            radius: radius,
            titleStyle: _label,
          );
        case 1:
          rate = analyze.rankingList[1] * 100 / analyze.games * 10.roundToDouble() / 10;
          return PieChartSectionData(
            color: Color(0xff651fff),
            value: rate,
            title: rate != 0 ? '2着' : '',
            radius: radius,
            titleStyle: _label,
          );
        case 2:
          rate = analyze.rankingList[2] * 100 / analyze.games * 10.roundToDouble() / 10;
          return PieChartSectionData(
            color: Color(0xff7c4dff),
            value: rate,
            title: rate != 0 ? '3着' : '',
            radius: radius,
            titleStyle: _label,
          );
        case 3:
          rate = analyze.rankingList[3] * 100 / analyze.games * 10.roundToDouble() / 10;
          return PieChartSectionData(
            color: Color(0xffb388ff),
            value: rate,
            title: rate != 0 ? '4着' : '',
            radius: radius,
            titleStyle: _label,
          );
        default:
          return null;
      }
    });
  }

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
