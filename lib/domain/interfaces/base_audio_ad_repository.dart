import 'package:base/data/responses/audio_ad_response.dart';

abstract class BaseAudioAdRepository {
  Future<AudioAdResponse> getAudioAd();
}
