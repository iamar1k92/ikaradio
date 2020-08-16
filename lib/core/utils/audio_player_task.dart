import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:base/core/sharedpref/shared_preference_helper.dart';
import 'package:base/data/repositories/audio_ad_repository.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

void audioPlayerTaskEntryPoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

MediaControl playControl = MediaControl(
  androidIcon: 'drawable/ic_action_play_arrow',
  label: 'Play',
  action: MediaAction.play,
);
MediaControl pauseControl = MediaControl(
  androidIcon: 'drawable/ic_action_pause',
  label: 'Pause',
  action: MediaAction.pause,
);
MediaControl skipToNextControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_next',
  label: 'Next',
  action: MediaAction.skipToNext,
);
MediaControl skipToPreviousControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_previous',
  label: 'Previous',
  action: MediaAction.skipToPrevious,
);
MediaControl stopControl = MediaControl(
  androidIcon: 'drawable/ic_action_stop',
  label: 'Stop',
  action: MediaAction.stop,
);

class AudioPlayerTask extends BackgroundAudioTask {
  AudioPlayer _audioPlayer = new AudioPlayer();
  StreamSubscription<AudioPlaybackState> _playerStateSubscription;
  StreamSubscription<AudioPlaybackEvent> _eventSubscription;
  bool _playing = false;
  AudioProcessingState _skipState;
  int _queueIndex = -1;
  List<MediaItem> _queue = List<MediaItem>();
  Duration currentPosition;
  int currentSecond = 0;

  bool get hasNext => _queueIndex + 1 < _queue.length;

  bool get hasPrevious => _queueIndex > 0;

  MediaItem get mediaItem => _queue.asMap().containsKey(_queueIndex) ? _queue[_queueIndex] : null;

  bool isAd = false;

  bool _interrupted = false;

  MediaItem tempMediaItem;
  Timer timer;

  @override
  void onStart(Map<String, dynamic> params) {
    _playerStateSubscription = _audioPlayer.playbackStateStream.where((state) => state == AudioPlaybackState.completed).listen((state) {
      _handlePlaybackCompleted();
    });

    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if ((await SharedPreferenceHelper(SharedPreferences.getInstance()).getAudioAdMinute() * 60) < currentSecond) {
        currentSecond = 0;
        AudioAdRepository().getAudioAd().then((response) async {
          if (response.audioAd != null) {
            onPlayMediaItem(response.audioAd.mediaItem);
          }
        });
      }

      if (mediaItem != null && _playing) {
        if (mediaItem.extras['type'] != 'ad') {
          currentSecond++;
        }
      }
    });

    _eventSubscription = _audioPlayer.playbackEventStream.listen((event) {
      final bufferingState = event.buffering ? AudioProcessingState.buffering : null;

      if (mediaItem != null) {
        //only for radios
        if (mediaItem.extras['type'] == 'radio') {
          AudioServiceBackground.setMediaItem(mediaItem.copyWith(album: (event.icyMetadata.info?.title?.isNotEmpty ?? false) ? event.icyMetadata.info.title : mediaItem.album ?? ""));
        }

        if (mediaItem.extras['type'] == 'podcast') {
          if (event.position.inSeconds > 3) {
            currentPosition = event.position;
          }
        }
      }

      switch (event.state) {
        case AudioPlaybackState.paused:
          _setState(
            processingState: bufferingState ?? AudioProcessingState.ready,
            position: event.position,
          );
          break;
        case AudioPlaybackState.playing:
          _setState(
            processingState: bufferingState ?? AudioProcessingState.ready,
            position: event.position,
          );
          break;
        case AudioPlaybackState.connecting:
          _setState(
            processingState: _skipState ?? AudioProcessingState.connecting,
            position: event.position,
          );
          break;
        default:
          break;
      }
    });

    onPlayMediaItem(MediaItem.fromJson(params));
  }

  @override
  Future<void> onUpdateMediaItem(MediaItem mediaItem) async {
    AudioServiceBackground.setMediaItem(mediaItem);
  }

  @override
  Future<void> onUpdateQueue(List<MediaItem> queue) async {
    _queue = queue;
    AudioServiceBackground.setQueue(_queue);
  }

  @override
  void onPlayMediaItem(MediaItem mItem) async {
    if (mItem.extras['type'] == 'ad') {
      isAd = true;
      tempMediaItem = mediaItem;
      _queue.add(mItem);
      _queueIndex = _queue.length - 1;
    } else {
      _queueIndex = _queue.indexOf(mItem) != -1 ? _queue.indexOf(mItem) : 0;
      tempMediaItem = null;
      if (isAd) {
        isAd = false;
        _queue.removeLast();
      }

      currentPosition = null;
    }

    _setState(processingState: AudioProcessingState.connecting);
    mItem = mItem.copyWith(duration: await _audioPlayer.setUrl(mItem.id));
    _audioPlayer.play();
    _playing = true;

    AudioServiceBackground.setMediaItem(mItem);
  }

  void _handlePlaybackCompleted() {
    if (isAd) {
      isAd = false;
      _queue.removeLast();
      _queueIndex = _queue.indexOf(tempMediaItem) - 1;
      tempMediaItem = null;
    } else {
      currentPosition = null;
    }

    if (hasNext) {
      onSkipToNext();
    } else {
      onStop();
    }
  }

  void playPause() {
    if (AudioServiceBackground.state.playing)
      onPause();
    else
      onPlay();
  }

  @override
  Future<void> onSkipToNext() => _skip(1);

  @override
  Future<void> onSkipToPrevious() => _skip(-1);

  Future<void> _skip(int offset) async {
    final newPos = _queueIndex + offset;
    if (!(newPos >= 0 && newPos < _queue.length)) return;
    if (_playing == null) {
      // First time, we want to start playing
      _playing = true;
    } else if (_playing) {
      // Stop current item
      await _audioPlayer.stop();
    }

    // Load next item
    _queueIndex = newPos;

    AudioServiceBackground.setMediaItem(mediaItem.copyWith(duration: await _audioPlayer.setUrl(mediaItem.id)));
    _skipState = offset > 0 ? AudioProcessingState.skippingToNext : AudioProcessingState.skippingToPrevious;
    await _audioPlayer.setUrl(mediaItem.id);
    _skipState = null;

    if (currentPosition != null) {
      _audioPlayer.seek(currentPosition);
    }

    // Resume playback if we were playing
    if (_playing) {
      onPlay();
    } else {
      _setState(processingState: AudioProcessingState.ready);
    }

    if (currentPosition != null) {
      onSeekTo(currentPosition);
    }
  }

  @override
  void onPlay() {
    if (_skipState == null) {
      _playing = true;
      _audioPlayer.play();
      AudioServiceBackground.sendCustomEvent('just played');
    }
  }

  @override
  void onPause() {
    if (_skipState == null) {
      _playing = false;
      _audioPlayer.pause();
      AudioServiceBackground.sendCustomEvent('just paused');
    }
  }

  @override
  void onSeekTo(Duration position) {
    _audioPlayer.seek(position);
  }

  @override
  void onClick(MediaButton button) {
    playPause();
  }

  @override
  Future<void> onFastForward() async {
    await _seekRelative(fastForwardInterval);
  }

  @override
  Future<void> onRewind() async {
    await _seekRelative(-rewindInterval);
  }

  Future<void> _seekRelative(Duration offset) async {
    var newPosition = _audioPlayer.playbackEvent.position + offset;
    if (newPosition < Duration.zero) newPosition = Duration.zero;
    if (newPosition > mediaItem.duration) newPosition = mediaItem.duration;
    await _audioPlayer.seek(newPosition);
  }

  @override
  Future<void> onStop() async {
    await _audioPlayer.stop();
    await _audioPlayer.dispose();
    timer.cancel();
    _playing = false;
    _playerStateSubscription.cancel();
    _eventSubscription.cancel();
    await _setState(processingState: AudioProcessingState.stopped);
    // Shut down this task
    await super.onStop();
  }

  /* Handling Audio Focus */
  @override
  void onAudioFocusLost(AudioInterruption interruption) {
    if (_playing) _interrupted = true;
    switch (interruption) {
      case AudioInterruption.pause:
      case AudioInterruption.temporaryPause:
      case AudioInterruption.unknownPause:
        onPause();
        break;
      case AudioInterruption.temporaryDuck:
        _audioPlayer.setVolume(0.5);
        break;
    }
  }

  @override
  void onAudioFocusGained(AudioInterruption interruption) {
    switch (interruption) {
      case AudioInterruption.temporaryPause:
        if (!_playing && _interrupted) onPlay();
        break;
      case AudioInterruption.temporaryDuck:
        _audioPlayer.setVolume(1.0);
        break;
      default:
        break;
    }
    _interrupted = false;
  }

  @override
  void onAudioBecomingNoisy() {
    onPause();
  }

  Future<void> _setState({
    AudioProcessingState processingState,
    Duration position,
    Duration bufferedPosition,
  }) async {
    if (position == null) {
      position = _audioPlayer.playbackEvent.position;
    }
    await AudioServiceBackground.setState(
      controls: getControls(),
      systemActions: [MediaAction.seekTo],
      processingState: processingState ?? AudioServiceBackground.state.processingState,
      playing: _playing,
      position: position,
      bufferedPosition: bufferedPosition ?? position,
      speed: _audioPlayer.speed,
    );
  }

  List<MediaControl> getControls() {
    if (mediaItem != null) {
      if (mediaItem.extras['type'] == 'ad') {
        return [pauseControl, stopControl];
      }
    }

    if (_playing) {
      return [skipToPreviousControl, pauseControl, stopControl, skipToNextControl];
    } else {
      return [skipToPreviousControl, playControl, stopControl, skipToNextControl];
    }
  }
}
