import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:base/core/services/media_player_service.dart';
import 'package:base/core/sharedpref/shared_preference_helper.dart';
import 'package:base/data/models/item.dart';
import 'package:base/data/models/podcast.dart';
import 'package:base/injection_container.dart';
import 'package:base/presentation/blocs/favorite_podcast/bloc.dart';
import 'package:base/presentation/components/circle_button.dart';
import 'package:base/presentation/components/custom_track_shape.dart';
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
import 'package:rxdart/rxdart.dart';

class PodcastDetail extends StatefulWidget {
  final Function tapOnCloseButton;
  final ScrollController scrollController;

  PodcastDetail({Key key, @required this.tapOnCloseButton, @required this.scrollController}) : super(key: key);

  @override
  _PodcastDetailState createState() => _PodcastDetailState();
}

class _PodcastDetailState extends State<PodcastDetail> {
  final BehaviorSubject<double> _dragPositionSubject = BehaviorSubject.seeded(null);

  final MediaPlayerService _mediaPlayerService = sl<MediaPlayerService>();

  SharedPreferenceHelper _sharedPreferenceHelper = sl<SharedPreferenceHelper>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ScreenState>(
      stream: screenStateStream,
      builder: (BuildContext context, snapshot) {
        final screenState = snapshot.data;
        final mediaItem = screenState?.mediaItem;
        final state = screenState?.playbackState;

        if (!snapshot.hasData) {
          return Container();
        }

        Map<String, dynamic> _podcastData = mediaItem.extras;
        if (_podcastData['categories'].runtimeType == String) {
          _podcastData['categories'] = jsonDecode(_podcastData['categories']);
        }

        if (_podcastData['items'].runtimeType == String) {
          _podcastData['items'] = jsonDecode(_podcastData['items']);
        }

        Podcast podcast = Podcast.fromJson(_podcastData);
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
                        imageUrl: podcast.cover,
                        width: MediaQuery.of(context).size.width / 3,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25.0),
                Center(child: Text(podcast.title, style: Theme.of(context).textTheme.headline1.copyWith(fontWeight: FontWeight.bold))),
                SizedBox(height: 5.0),
                Center(child: Text(podcast.categories.map((category) => category.name).toList().join(", "), style: Theme.of(context).textTheme.caption)),
                SizedBox(height: 15.0),
                if (podcast.description?.isNotEmpty ?? false) Html(data: podcast.description),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: podcast.items.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemBuilder: (BuildContext context, int index) {
                    Item item = podcast.items[index];
                    return ListTile(
                      onTap: () => _mediaPlayerService.start(
                        MediaItem(
                          id: item.audioFile,
                          album: podcast.title,
                          title: item.title,
                          artUri: podcast.cover,
                          genre: podcast.categories.map((e) => e.name).toList().join(',').toString(),
                          extras: podcast.toJson(),
                        ),
                        queue: podcast.queue,
                      ),
                      leading: Icon(FontAwesomeIcons.microphone, color: Theme.of(context).accentColor, size: 36.0),
                      title: Text(item.title, style: Theme.of(context).textTheme.subtitle2.copyWith(fontWeight: FontWeight.bold)),
                      subtitle: Text(item.subtitle ?? ""),
                      selected: mediaItem.id == item.audioFile,
                      dense: true,
                    );
                  },
                )
              ],
            ),
          ),
          bottomNavigationBar: Container(
            height: 100.0,
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                positionIndicator(mediaItem, state),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      flex: 8,
                      child: BoardControls(
                        width: 175,
                        height: 40.0,
                        iconSize: 30.0,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: CircleButton(
                        backgroundColor: Theme.of(context).primaryIconTheme.color,
                        size: 40.0,
                        child: Icon(podcast.isFavorite ? Icons.favorite : Icons.favorite_border, size: 20.0, color: Theme.of(context).floatingActionButtonTheme.backgroundColor),
                        onPressed: () async => BlocProvider.of<FavoritePodcastBloc>(context).add(TogglePodcastFavoriteStatus(podcast: podcast)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget positionIndicator(MediaItem mediaItem, PlaybackState state) {
    double seekPos;
    return StreamBuilder(
      stream: Rx.combineLatest2<double, double, double>(_dragPositionSubject.stream, Stream.periodic(Duration(milliseconds: 200)), (dragPosition, _) => dragPosition),
      builder: (context, snapshot) {
        double position = snapshot.data ?? state.currentPosition.inMilliseconds.toDouble();
        double duration = mediaItem?.duration?.inMilliseconds?.toDouble();
        return Row(
          children: [
            Expanded(
              flex: 3,
              child: duration != null
                  ? SizedBox(
                      height: 18.0,
                      child: SliderTheme(
                        data: SliderThemeData(thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5), trackShape: CustomTrackShape(), trackHeight: 5.0),
                        child: Slider(
                          activeColor: Theme.of(context).accentColor,
                          inactiveColor: Theme.of(context).accentColor.withOpacity(.5),
                          min: 0.0,
                          max: duration,
                          value: seekPos ?? max(0.0, min(position, duration)),
                          onChanged: (value) {
                            _dragPositionSubject.add(value);
                          },
                          onChangeEnd: (value) {
                            AudioService.seekTo(Duration(milliseconds: value.toInt()));
                            seekPos = value;
                            _dragPositionSubject.add(null);
                          },
                        ),
                      ),
                    )
                  : SizedBox(height: 0),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  [state.currentPosition.inHours, state.currentPosition.inMinutes, state.currentPosition.inSeconds].map((seg) => seg.remainder(60).toString().padLeft(2, '0')).join(':') +
                      " / " +
                      [mediaItem.duration.inHours, mediaItem.duration.inMinutes, mediaItem.duration.inSeconds].map((seg) => seg.remainder(60).toString().padLeft(2, '0')).join(':'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
