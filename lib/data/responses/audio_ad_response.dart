import 'package:base/data/models/audio_ad.dart';

class AudioAdResponse {
  final AudioAd audioAd;
  final String error;

  AudioAdResponse({this.audioAd, this.error});

  AudioAdResponse.success(json)
      : audioAd = AudioAd.fromJson(json),
        error = null;

  AudioAdResponse.error(String error)
      : audioAd = null,
        error = error;
}
