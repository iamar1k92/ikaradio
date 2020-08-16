import 'package:base/data/providers/audio_ad_api_provider.dart';
import 'package:base/data/responses/audio_ad_response.dart';
import 'package:base/domain/interfaces/base_audio_ad_repository.dart';

class AudioAdRepository implements BaseAudioAdRepository {
  final AudioAdApiProvider _audioAdApiProvider = AudioAdApiProvider();

  @override
  Future<AudioAdResponse> getAudioAd() async {
    return await _audioAdApiProvider.getAudioAd();
  }
}
