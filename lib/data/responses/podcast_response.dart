
import 'package:base/data/models/podcast.dart';

class PodcastResponse {
  final List<Podcast> podcasts;
  final String error;

  PodcastResponse({this.podcasts, this.error});

  PodcastResponse.success(json)
      : podcasts = List<Podcast>.from((json as List).map((x) => Podcast.fromJson(x))),
        error = null;

  PodcastResponse.error(String error)
      : podcasts = null,
        error = error;

  @override
  String toString() {
    return 'PodcastResponse{podcasts: $podcasts, error: $error}';
  }
}
