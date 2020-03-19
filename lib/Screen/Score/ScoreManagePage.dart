import 'package:flutter/material.dart';
import 'package:flutter_app2/Bloc/LocalDataBloc.dart';
import 'package:flutter_app2/Entity/PageParts.dart';
import 'package:flutter_app2/Entity/Score.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
  Map<DateTime, List<Score>> _events;
  List _selectedEvents;
  CalendarController _calendarController;
  Map<DateTime, dynamic> scoreMap;
  var formatter = DateFormat(DateFormat.YEAR_MONTH_WEEKDAY_DAY);
  final LocalDataBloc bloc = LocalDataBloc();
  final _selectedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 21).toUtc();

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
    initializeDateFormatting('ja_JP');
    _tabController = TabController(length: tabs.length, vsync: this);
    bloc.callMapSink.add(null);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 2.0,
          backgroundColor: _parts.baseColor,
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
      child: StreamBuilder<Map<String, dynamic>>(
        stream: bloc.scoreMapStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return _parts.indicator();
          } else {
//            if (snapshot.data.isEmpty) {
//              return Expanded(
//                child: Center(
//                  child: Text("まだ登録されていません", style: TextStyle(color: set.pointColor)),
//                ),
//              );
//            }
            _events = {};
            snapshot.data.forEach((k, v) {
              _events[DateTime.parse(k)] = v;
            });
            _selectedEvents = _events[_selectedDay] ?? [];
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
            _onDaySelected(date, events);
          },
          builders: CalendarBuilders(
            markersBuilder: (context, date, events, holidays) {
              final children = <Widget>[];
              if (events.isNotEmpty) {
                children.add(
                  Positioned(
                    right: 1,
                    bottom: 1,
                    child: _buildEventsMarker(date, events),
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

  void _onDaySelected(DateTime day, List<dynamic> events) {
    setState(() {
      _selectedEvents = events;
    });
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
                title: Text(event.date),
                onTap: () => print('$event tapped!'),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date) ? Colors.brown[300] : Colors.blue[400],
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

  Widget _bySynthesis() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: StreamBuilder<Map<String, List<Score>>>(
        stream: bloc.scoreMapStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return _parts.indicator();
          } else {
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
                        mainData(),
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
                          fontSize: 12,
                          color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void dataCleansing() {}
  LineChartData mainData() {
    //データクレンジング
    /*
    * Map<DateTime,List<Score>>からMap<DateTime,Score>の変換
    * */
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle:
              TextStyle(color: const Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
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
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData:
          FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
//      minX: 0,
//      maxX: 11,
//      minY: 0,
//      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
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
    );
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
    if (_calendarController != null) _calendarController.dispose();
  }
}
