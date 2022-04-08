import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Counter extends StatefulWidget {
  int endTimer;
  Counter(this.endTimer);
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int next;
  int seconds=0,minutes=0,hours=0;
  int current;
  @override
  void initState() {
      setState(() {
        next=widget.endTimer;
        // next = pref.getInt("last checked");
        Timer.periodic(Duration(seconds: 1), (Timer t) {
          setState(() {
            current = DateTime.now().millisecondsSinceEpoch;
            seconds = ((next - current)/1000).round();
            hours=(seconds/3600).floor();
            seconds=(seconds%3600).round();
            minutes=(seconds/60).floor();
            seconds=seconds%60;
          });
        });
      });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int current = DateTime.now().millisecondsSinceEpoch;
    return Row(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(alignment: Alignment.center,
          color: Colors.black12,
          height: 100,
          width: 70,
          child: Text(
            hours.toString(),
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold
            ),),
        ),
        SizedBox(width: 20,),
        Container(alignment: Alignment.center,
          color: Colors.black12,
          height: 100,
          width: 70,
          child: Text(minutes.toString(),style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),),
        ),
        SizedBox(width: 20,),
        Container(alignment: Alignment.center,
          color: Colors.black12,
          height: 100,
          width: 70,
          child: Text(seconds.toString(),style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),),
        ),
      ],
    );
  }

}
