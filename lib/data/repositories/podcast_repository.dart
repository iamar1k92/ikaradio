import 'package:base/core/local/database_helper.dart';
import 'package:base/core/sharedpref/shared_preference_helper.dart';
import 'package:base/data/models/podcast.dart';
import 'package:base/data/providers/podcast_api_provider.dart';
import 'package:base/data/responses/podcast_response.dart';
import 'package:base/domain/interfaces/base_podcast_repository.dart';
import 'package:base/injection_container.dart';

class PodcastRepository implements BasePodcastRepository {
  final PodcastApiProvider _podcastApiProvider = sl<PodcastApiProvider>();
  final SharedPreferenceHelper _sharedPreferenceHelper = sl<SharedPreferenceHelper>();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<PodcastResponse> getPodcasts({int categoryId, String search, bool isFeatured, int limit}) async {
    PodcastResponse _podcastResponse = await _podcastApiProvider.getPodcasts(categoryId: categoryId, search: search, isFeatured: isFeatured, limit: limit);
    if (_podcastResponse.error == null) {
      if (!await _sharedPreferenceHelper.isLoggedIn()) {
        await Future.wait(_podcastResponse.podcasts.map((podcast) async {
          podcast.isFavorite = await _databaseHelper.exist(Podcast.table, podcast.id);
          return podcast;
        }).toList());
      }
    }

    return _podcastResponse;
  }

  @override
  Future<PodcastResponse> getFavoritePodcasts() async {
    if (await _sharedPreferenceHelper.isLoggedIn()) {
      return await _podcastApiProvider.getFavoritePodcasts();
    } else {
      List<Podcast> _podcastList = await Podcast().getList();
      return PodcastResponse(podcasts: _podcastList);
    }
  }

  @override
  Future<PodcastResponse> addFavoritePodcast(Podcast podcast) async {
    if (await _sharedPreferenceHelper.isLoggedIn()) {
      return await _podcastApiProvider.addFavoritePodcast(podcast);
    } else {
      await _databaseHelper.insert(Podcast.table, podcast);
      return PodcastResponse();
    }
  }

  @override
  Future<PodcastResponse> removeFavoritePodcast(Podcast podcast) async {
    if (await _sharedPreferenceHelper.isLoggedIn()) {
      return await _podcastApiProvider.removeFavoritePodcast(podcast);
    } else {
      await _databaseHelper.delete(Podcast.table, podcast.id);
      return PodcastResponse();
    }
  }
}
