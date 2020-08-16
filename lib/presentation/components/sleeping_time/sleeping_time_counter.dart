import 'dart:async';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:base/core/sharedpref/shared_preference_helper.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/injection_container.dart';
import 'package:flutter/material.dart';

class SleepingTimeCounterWidget extends StatefulWidget {
  @override
  _SleepingTimeCounterWidgetState createState() => _SleepingTimeCounterWidgetState();
}

class _SleepingTimeCounterWidgetState extends State<SleepingTimeCounterWidget> {
  SharedPreferenceHelper _sharedPreferenceHelper = sl<SharedPreferenceHelper>();
  int secondsRemaining = 0;
  Timer _timer;
  int seconds = 0;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  _init() async {
    DateTime _sleepingTime = await _sharedPreferenceHelper.getSleepingTime();
    setState(() {
      secondsRemaining = seconds = _sleepingTime.difference(DateTime.now()).inSeconds;
    });
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Sleeping Time"),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(formatter(), style: Theme.of(context).textTheme.headline2),
            ],
          );
        },
      ),
      actions: <Widget>[
        FlatButton(onPressed: () => Navigator.of(context).pop(), child: Text(S.of(context).cancel, style: TextStyle(color: Theme.of(context).accentColor))),
        FlatButton(
          onPressed: () async {
            await _sharedPreferenceHelper.removeSleepingTime();
            await AndroidAlarmManager.cancel(0);
            Navigator.of(context).pop();
          },
          child: Text(S.of(context).stop, style: TextStyle(color: Theme.of(context).accentColor)),
        ),
      ],
    );
  }

  void startTimer() async {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (mounted) {
          setState(
            () {
              if (secondsRemaining < 1) {
                timer.cancel();
              } else {
                secondsRemaining--;
              }
              seconds = secondsRemaining;
            },
          );
        }
      },
    );
  }

  String formatter() {
    int hours = ((seconds / 3600)).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();
    String text = "";

    hours = (hours % 24);
    seconds = (seconds % 60).truncate();

    text = hours.toString().padLeft(2, '0') + ":" + minutes.toString().padLeft(2, '0') + ":" + seconds.toString().padLeft(2, '0');

    return text;
  }
}
