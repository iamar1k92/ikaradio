import 'dart:convert';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:base/core/sharedpref/shared_preference_helper.dart';
import 'package:base/data/models/radio_station.dart';
import 'package:base/injection_container.dart';
import 'package:base/presentation/blocs/favorite_radio/bloc.dart';
import 'package:base/presentation/components/circle_button.dart';
import 'package:base/presentation/components/empty_app_bar_widget.dart';
import 'package:base/presentation/components/player/board_controls.dart';
import 'package:base/presentation/components/sleeping_time/sleeping_time_counter.dart';
import 'package:base/presentation/components/sleeping_time/sleeping_time_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RadioDetail extends StatefulWidget {
  final Function tapOnCloseButton;
  final ScrollController scrollController;

  RadioDetail({Key key, @required this.tapOnCloseButton, @required this.scrollController}) : super(key: key);

  @override
  _RadioDetailState createState() => _RadioDetailState();
}

class _RadioDetailState extends State<RadioDetail> {
  SharedPreferenceHelper _sharedPreferenceHelper = sl<SharedPreferenceHelper>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem>(
      stream: AudioService.currentMediaItemStream,
      builder: (BuildContext context, AsyncSnapshot<MediaItem> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        MediaItem _mediaItem = snapshot.data;
        Map<String, dynamic> _radioStationData = _mediaItem.extras;
        if (_radioStationData['categories'].runtimeType == String) {
          _radioStationData['categories'] = jsonDecode(_radioStationData['categories']);
        }

        RadioStation radioStation = RadioStation.fromJson(_radioStationData);
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: EmptyAppBar(),
          body: Container(
            color: Theme.of(context).canvasColor,
            height: MediaQuery.of(context).size.height - kBottomNavigationBarHeight,
            padding: EdgeInsets.all(20.0),
            child: ListView(
              controller: widget.scrollController,
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: FlatButton(
                    onPressed: widget.tapOnCloseButton,
                    child: Icon(FontAwesomeIcons.chevronDown),
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                ),
                SizedBox(height: 10.0),
                Center(
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    margin: EdgeInsets.symmetric(horizontal: 50.0),
                    elevation: 3,
                    child: Container(
                      padding: EdgeInsets.all(25.0),
                      child: CachedNetworkImage(
                        imageUrl: radioStation.cover,
                        width: MediaQuery.of(context).size.width / 3,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25.0),
                Center(child: Text(radioStation.name, style: Theme.of(context).textTheme.headline1.copyWith(fontWeight: FontWeight.bold))),
                SizedBox(height: 5.0),
                Center(child: Text(radioStation.categories.map((category) => category.name).toList().join(", "), style: Theme.of(context).textTheme.caption)),
                SizedBox(height: 15.0),
                if (radioStation.description?.isNotEmpty ?? false) Html(data: radioStation.description),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            height: 80.0,
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Platform.isIOS
                      ? SizedBox()
                      : CircleButton(
                          backgroundColor: Theme.of(context).primaryIconTheme.color,
                          size: 40.0,
                          child: Icon(Icons.alarm, size: 20.0, color: Theme.of(context).floatingActionButtonTheme.backgroundColor),
                          onPressed: () async {
                            Widget widget;
                            await _sharedPreferenceHelper.reload();
                            if (await _sharedPreferenceHelper.getSleepingTime() != null) {
                              widget = SleepingTimeCounterWidget();
                            } else {
                              widget = SleepingTimeWidget();
                            }
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return widget;
                              },
                            );
                          },
                        ),
                ),
                Expanded(
                  flex: 4,
                  child: BoardControls(height: 40.0),
                ),
                Expanded(
                  flex: 2,
                  child: CircleButton(
                    backgroundColor: Theme.of(context).primaryIconTheme.color,
                    size: 40.0,
                    child: Icon(radioStation.isFavorite ? Icons.favorite : Icons.favorite_border, size: 20.0, color: Theme.of(context).floatingActionButtonTheme.backgroundColor),
                    onPressed: () async => BlocProvider.of<FavoriteRadioBloc>(context).add(ToggleRadioFavoriteStatus(radioStation: radioStation)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
