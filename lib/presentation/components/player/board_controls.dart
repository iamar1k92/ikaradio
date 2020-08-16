import 'package:audio_service/audio_service.dart';
import 'package:base/core/services/media_player_service.dart';
import 'package:flutter/material.dart';

class BoardControls extends StatelessWidget {
  final double width;
  final double iconSize;
  final double height;

  const BoardControls({Key key, this.width = 245, this.iconSize = 40, this.height = 60}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ScreenState>(
      stream: screenStateStream,
      builder: (BuildContext context, snapshot) {
        final screenState = snapshot.data;
        final queue = screenState?.queue;
        final mediaItem = screenState?.mediaItem;
        final state = screenState?.playbackState;
        final processingState = state?.processingState ?? AudioProcessingState.none;
        final playing = state?.playing ?? false;

        return Container(
          height: iconSize * 2,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).accentColor.withOpacity(.2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: mediaItem == (queue?.first ?? null)
                            ? SizedBox(height: 0)
                            : GestureDetector(
                                onTap: () => AudioService.skipToPrevious(),
                                child: Icon(
                                  Icons.fast_rewind,
                                  color: Theme.of(context).accentColor.withOpacity(.5),
                                  size: iconSize,
                                ),
                              ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: mediaItem == (queue?.last ?? null)
                            ? SizedBox(height: 0)
                            : GestureDetector(
                                onTap: () => AudioService.skipToNext(),
                                child: Icon(
                                  Icons.fast_forward,
                                  color: Theme.of(context).accentColor.withOpacity(.5),
                                  size: iconSize,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    if (playing) {
                      AudioService.pause();
                    } else {
                      AudioService.play();
                    }
                  },
                  child: Container(
                    height: height + 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).accentColor,
                    ),
                    child: Center(
                      child: processingState == AudioProcessingState.connecting
                          ? SizedBox(
                              width: iconSize,
                              height: iconSize,
                              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).floatingActionButtonTheme.backgroundColor)))
                          : AnimatedCrossFade(
                              duration: Duration(milliseconds: 200),
                              crossFadeState: playing ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                              firstChild: Icon(Icons.pause, size: iconSize, color: Theme.of(context).floatingActionButtonTheme.backgroundColor),
                              secondChild: Icon(Icons.play_arrow, size: iconSize, color: Theme.of(context).floatingActionButtonTheme.backgroundColor),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
