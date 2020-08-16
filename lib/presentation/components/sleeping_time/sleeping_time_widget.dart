import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:base/core/services/media_player_service.dart';
import 'package:base/core/sharedpref/shared_preference_helper.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/injection_container.dart';
import 'package:base/presentation/components/custom_track_shape.dart';
import 'package:flutter/material.dart';

class SleepingTimeWidget extends StatefulWidget {
  @override
  _SleepingTimeWidgetState createState() => _SleepingTimeWidgetState();
}

class _SleepingTimeWidgetState extends State<SleepingTimeWidget> {
  SharedPreferenceHelper _sharedPreferenceHelper = sl<SharedPreferenceHelper>();
  double _sleepingTime = 1;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Sleeping Time"),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              SliderTheme(
                data: SliderThemeData(thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10), trackShape: CustomTrackShape(), trackHeight: 5.0),
                child: Slider(
                  activeColor: Theme.of(context).accentColor,
                  inactiveColor: Theme.of(context).accentColor.withOpacity(.5),
                  onChanged: (value) {
                    setState(() {
                      _sleepingTime = value;
                    });
                  },
                  max: 120,
                  min: 1,
                  value: _sleepingTime,
                ),
              ),
              Text(S.of(context).minutes(_sleepingTime.toInt().toString()))
            ],
          );
        },
      ),
      actions: <Widget>[
        FlatButton(onPressed: () => Navigator.of(context).pop(), child: Text(S.of(context).cancel, style: TextStyle(color: Theme.of(context).accentColor))),
        FlatButton(
          onPressed: () {
            _sharedPreferenceHelper.setSleepingTime(DateTime.now().add(Duration(minutes: _sleepingTime.toInt())));
            AndroidAlarmManager.oneShot(Duration(minutes: _sleepingTime.toInt()), 0, stopAudioService);
            Navigator.of(context).pop();
          },
          child: Text(S.of(context).set, style: TextStyle(color: Theme.of(context).accentColor)),
        ),
      ],
    );
  }
}
