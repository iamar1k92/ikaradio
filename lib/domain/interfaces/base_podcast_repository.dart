import 'package:base/data/models/podcast.dart';
import 'package:base/data/responses/podcast_response.dart';

abstract class BasePodcastRepository {
  Future<PodcastResponse> getPodcasts({int categoryId, String search, bool isFeatured,int limit});

  Future<PodcastResponse> addFavoritePodcast(Podcast podcast);

  Future<PodcastResponse> removeFavoritePodcast(Podcast podcast);

  Future<PodcastResponse> getFavoritePodcasts();
}
