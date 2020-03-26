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
/*----------------------------------------------

スコア管理ページクラス

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
  var formatter = DateFormat(DateFormat.YEAR_MONTH_WEEKDAY_DAY);
  int _max = 0;
  int _min = 0;
  int grid = 50;
  List<FlSpot> _lineData;
//  final _selectedDay =
//      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 21).toUtc();

  bool showAvg = false;
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  List<Tab> tabs = <Tab>[
    Tab(
      text: '月別',
    ),
    Tab(
      text: "総合",
    ),
  ];

  @override
  void initState() {
    super.initState();
    repository = LocalDataRepository();
    _calendarController = CalendarController();
    _events = {};
    _lineData = [];
    refleshEventList();
    _selectedEvents = _events[DateTime.now()] ?? [];
    initializeDateFormatting('ja_JP');
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  void refleshEventList() async {
    Map<DateTime, List<Score>> map = await repository.getScoreMap();
    setState(() {
      _events = map;
      dataCleansing();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradientAppBar(
          elevation: 2.0,
          gradient: LinearGradient(colors: [_parts.startGradient, _parts.endGradient]),
          title: Text('スコア管理', style: TextStyle(color: _parts.pointColor)),
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
          _byPeriod(),
          _bySynthesis(),
        ]),
        floatingActionButton: _parts.floatButton(
            icon: Icons.add,
            onPressed: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: "/ScoreInput"),
                  builder: (context) => ScoreInputScreen(),
                  fullscreenDialog: true,
                ),
              );
            }));
  }

  Widget _byPeriod() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          _calendar(),
          const SizedBox(height: 8.0),
          Expanded(
            child: _buildEventList(),
          ),
          _parts.iconButton(
            message: "全削除する",
            icon: Icons.delete,
            onPressed: () {
              _showModalBottomSheet();
            },
          )
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
            setState(() {
              _selectedEvents = events;
            });
          },
          builders: CalendarBuilders(
            markersBuilder: (context, date, events, holidays) {
              final children = <Widget>[];
              if (events.isNotEmpty) {
                children.add(
                  Positioned(
                    right: 1,
                    bottom: 1,
                    child: _buildEventsMarker(date, events, _calendarController),
                  ),
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
    return ListView(
      children: _selectedEvents
          .map(
            (event) => Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.8),
                borderRadius: BorderRadius.circular(12.0),
                color: _parts.pointColor,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: ListTile(
                title: Text("${event.date} total:${event.total} balance:${event.balance}"),
                onTap: () => print('$event tapped!'),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events, CalendarController controller) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.brown[500],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  /*---------総合成績---------*/
  Widget _bySynthesis() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          _events.length == 0 ? Text("No Data") : totalLineGraph(),
        ],
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
      _max = sum > _max ? sum : _max;
      _min = sum < _min ? sum : _min;
      _lineData.add(FlSpot(i.toDouble(), sum.toDouble()));
      i++;
    });
    grid = (_max - _min) ~/ 5;

    return _lineData;
  }

  Widget totalLineGraph() {
    //データクレンジング
    /*
    * Map<DateTime,List<Score>>からMap<DateTime,Score>の変換
    * */
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(18),
                ),
                color: const Color(0xff232d37)),
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
                      return value == 0;
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: false,
                    bottomTitles: SideTitles(
                      showTitles: false,
                      reservedSize: 22,
                      textStyle: TextStyle(
                          color: const Color(0xff68737d),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      getTitles: (value) {
                        switch (value.toInt()) {
                          case 2:
                            return 'MAR';
                          case 5:
                            return 'JUN';
                          case 8:
                            return 'SEP';
                        }
                        return '';
                      },
                      margin: 8,
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      textStyle: TextStyle(
                        color: const Color(0xff67727d),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      getTitles: (value) {
                        if (value.toInt() == 0) {
                          return '0';
                        } else if (value % grid == 0) {
                          return '${value.toInt()}';
                        }
                        return '';
                      },
                      reservedSize: 28,
                      margin: 12,
                    ),
                  ),
                  borderData: FlBorderData(
                      show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
                  maxY: _max.toDouble() + grid,
                  minY: _min.toDouble() - grid,
                  minX: 0,
                  maxX: (_lineData.length + 1).toDouble(),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _lineData,
                      //isCurved: true,
                      colors: gradientColors,
                      barWidth: 5,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(
                        show: true,
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
                      ),
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

  void _showModalBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.delete_forever),
              title: Text('削除'),
              onTap: () {
                repository.resetScore();
                refleshEventList();
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
    if (_calendarController != null) _calendarController.dispose();
  }
}
