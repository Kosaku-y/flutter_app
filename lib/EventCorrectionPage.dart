import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';

/*----------------------------------------------

イベント管理用クラス

----------------------------------------------*/
class EventCorrectionPage extends StatefulWidget {
  Event event;
  EventCorrectionPage(this.event);

  @override
  EventCorrectionPageState createState() => new EventCorrectionPageState();
}


class EventCorrectionPageState extends State<EventCorrectionPage> {

  final _mainReference = FirebaseDatabase.instance.reference().child("Events");


  @override
  Widget build(BuildContext context) {

  }
}