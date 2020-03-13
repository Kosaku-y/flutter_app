import 'package:flutter/material.dart';
import 'package:flutter_app2/Bloc/LocalDataBloc.dart';
import 'package:flutter_app2/Entity/PageParts.dart';
import 'package:flutter_app2/Entity/Score.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'ScoreInputPage.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';

/*----------------------------------------------

スコア管理ページクラス

----------------------------------------------*/

class ScoreManagePage extends StatefulWidget {
  ScoreManagePage({Key key}) : super(key: key);

  State<StatefulWidget> createState() {
    return new ScoreManagePageState();
  }
}

class ScoreManagePageState extends State<ScoreManagePage> with TickerProviderStateMixin {
  TabController _tabController;
  PageParts set = new PageParts();
  Map<DateTime, List<Score>> _events;
  List _selectedEvents;
  CalendarController _calendarController;
  Map<DateTime, dynamic> scoreMap;
  DateTime selectedDay;
  var formatter = DateFormat(DateFormat.YEAR_MONTH_WEEKDAY_DAY);
  final LocalDataBloc bloc = LocalDataBloc();
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
    Intl.defaultLocale = 'ja_JP';
    initializeDateFormatting('ja_JP');
    var today = DateTime.now();
    selectedDay = DateTime(today.year, today.month, today.day);

    bloc.callMapSink.add(null);
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 2.0,
          backgroundColor: set.baseColor,
          title: Text('スコア管理', style: TextStyle(color: set.pointColor)),
          bottom: TabBar(
//          isScrollable: true,
            tabs: tabs,
            controller: _tabController,
            unselectedLabelColor: Colors.grey,
//            indicatorColor: Colors.blue,
//            indicatorSize: TabBarIndicatorSize.tab,
//            indicatorWeight: 2,
//            indicatorPadding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
//            indicator: set.indicator(),
            labelColor: set.pointColor,
          ),
        ),
        backgroundColor: set.backGroundColor,
        body: TabBarView(controller: _tabController, children: <Widget>[
          _byPeriod(),
          _bySynthesis(),
        ]),
        floatingActionButton: set.floatButton(
            icon: Icons.add,
            onPressed: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: "/ScoreInput"),
                  builder: (context) => ScoreInputPage(),
                  fullscreenDialog: true,
                ),
              );
            }));
  }

  Widget _byPeriod() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: StreamBuilder(
        stream: bloc.scoreMapStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return set.indicator();
          } else {
            _events = snapshot.data;
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
      ),
    );
  }

  Widget _bySynthesis() {
    return Text('not set', style: TextStyle(color: set.pointColor));
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
            print(date.year);
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
    _calendarController.setSelectedDay(DateTime(day.year, day.month, day.day));
    setState(() {
      _selectedEvents = events;
    });
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
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
              ))
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

  @override
  void dispose() {
    bloc.dispose();
    _calendarController.dispose();
    super.dispose();
  }
}
