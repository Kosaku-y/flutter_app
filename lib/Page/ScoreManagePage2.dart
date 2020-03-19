import 'package:flutter/material.dart';
import 'package:flutter_app2/Bloc/LocalDataBloc.dart';
import 'package:flutter_app2/Entity/PageParts.dart';
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
