import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:base/core/services/media_player_service.dart';
import 'package:base/presentation/components/custom_track_shape.dart';
import 'package:base/presentation/components/player/board_controls.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rxdart/rxdart.dart';

class CollapseWidget extends StatelessWidget {
  final Function tapOnOpenButton;
  final Function onEmpty;
  final BehaviorSubject<double> _dragPositionSubject = BehaviorSubject.seeded(null);

  CollapseWidget({Key key, @required this.tapOnOpenButton, this.onEmpty}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ScreenState>(
      stream: screenStateStream,
      builder: (BuildContext context, snapshot) {
        final screenState = snapshot.data;
        final mediaItem = screenState?.mediaItem;
        final state = screenState?.playbackState;
        if (mediaItem == null) {
          onEmpty();
          return Container();
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            border: Border.all(color: Theme.of(context).accentColor.withOpacity(.1)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: tapOnOpenButton,
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 40.0,
                            height: 40.0,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: mediaItem.artUri,
                                placeholder: (context, url) => Container(
                                  width: 40.0,
                                  height: 40.0,
                                  child: Center(child: CircularProgressIndicator()),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(mediaItem.title, style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold, fontSize: 13.0)),
                                SizedBox(width: 5.0),
                                Text(mediaItem.album, style: Theme.of(context).textTheme.caption.copyWith(fontSize: 10.0)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          padding: EdgeInsets.all(0),
                          iconSize: 22,
                          icon: Icon(FontAwesomeIcons.chevronUp),
                          onPressed: tapOnOpenButton,
                        ),
                        Container(width: 135, child: BoardControls(iconSize: 25, height: 35)),
                      ],
                    ),
                  )
                ],
              ),
              if (mediaItem.extras['type'] == 'podcast') positionIndicator(mediaItem, state),
            ],
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
                    style: Theme.of(context).textTheme.caption),
              ),
            ),
          ],
        );
      },
    );
  }
}
