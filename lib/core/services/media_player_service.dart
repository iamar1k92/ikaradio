import 'package:audio_service/audio_service.dart';
import 'package:base/core/services/ad_service.dart';
import 'package:base/core/sharedpref/shared_preference_helper.dart';
import 'package:base/core/utils/audio_player_task.dart';
import 'package:base/data/repositories/audio_ad_repository.dart';
import 'package:base/injection_container.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

void stopAudioService() async {
  await SharedPreferenceHelper(SharedPreferences.getInstance()).removeSleepingTime();
  await AudioService.connect();
  if (AudioService.running) {
    await AudioService.stop();
  }
}

class ScreenState {
  final List<MediaItem> queue;
  final MediaItem mediaItem;
  final PlaybackState playbackState;

  ScreenState(this.queue, this.mediaItem, this.playbackState);
}

Stream<ScreenState> get screenStateStream => Rx.combineLatest3<List<MediaItem>, MediaItem, PlaybackState, ScreenState>(
    AudioService.queueStream, AudioService.currentMediaItemStream, AudioService.playbackStateStream, (queue, mediaItem, playbackState) => ScreenState(queue, mediaItem, playbackState));

class MediaPlayerService {
  Future<void> start(MediaItem mediaItem, {List<MediaItem> queue = const []}) async {
    //if not connected, start new service
    if (!AudioService.running) {
      await AudioService.start(
        androidNotificationChannelName: sl<DotEnv>().env['APP_NAME'],
        backgroundTaskEntrypoint: audioPlayerTaskEntryPoint,
        androidNotificationColor: 0xFF2196f3,
        androidNotificationIcon: 'mipmap/ic_launcher',
        androidEnableQueue: true,
        params: mediaItem.toJson(),
      );
    }

    await sl<SharedPreferenceHelper>().incrementRadioListeningCount();
    if (await sl<SharedPreferenceHelper>().getRadioListeningCount() % int.parse(sl<DotEnv>().env['INTERSTITIAL_SHOW_EVERY_X_LISTENING'] ?? "1") == 0 &&
        (sl<DotEnv>().env["SHOW_ADMOB_INTERSTITIAL"] ?? "0") == "1") {
      sl<AdService>().buildInterstitialAd();
    }

    await AudioService.updateQueue(queue);
    await AudioService.playMediaItem(mediaItem);

    if (await sl<SharedPreferenceHelper>().getRadioListeningCount() % int.parse(sl<DotEnv>().env['SHOW_AUDIO_AD_EVERY_X_LISTENING'] ?? "1") == 0) {
      sl<AudioAdRepository>().getAudioAd().then((response) async {
        if (response.audioAd != null) {
          await AudioService.playMediaItem(response.audioAd.mediaItem);
        }
      });
    }
  }

  Future<void> updateItem(MediaItem mediaItem) async {
    if (AudioService.running) {
      if ((AudioService.currentMediaItem.id == mediaItem.id && AudioService.currentMediaItem.extras['type'] == 'radio') || AudioService.currentMediaItem.extras['type'] == 'podcast') {
        await AudioService.updateMediaItem(AudioService.currentMediaItem.copyWith(extras: mediaItem.extras));
      }
    }
  }
}
