import 'package:base/core/local/database_helper.dart';
import 'package:base/core/sharedpref/shared_preference_helper.dart';
import 'package:base/data/models/podcast.dart';
import 'package:base/data/models/radio_station.dart';
import 'package:base/data/providers/search_api_provider.dart';
import 'package:base/data/responses/search_response.dart';
import 'package:base/domain/interfaces/base_search_repository.dart';
import 'package:base/injection_container.dart';

class SearchRepository implements BaseSearchRepository {
  final SearchApiProvider _searchApiProvider = sl<SearchApiProvider>();
  final SharedPreferenceHelper _sharedPreferenceHelper = sl<SharedPreferenceHelper>();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<SearchResponse> search({String query}) async {
    SearchResponse _searchResponse = await _searchApiProvider.search(query: query);

    if (_searchResponse.error == null) {
      if (!await _sharedPreferenceHelper.isLoggedIn()) {
        await Future.wait(_searchResponse.radios.map((radioStation) async {
          radioStation.isFavorite = await _databaseHelper.exist(RadioStation.table, radioStation.id);
          return radioStation;
        }).toList());

        await Future.wait(_searchResponse.podcasts.map((podcast) async {
          podcast.isFavorite = await _databaseHelper.exist(Podcast.table, podcast.id);
          return podcast;
        }).toList());
      }
    }

    return _searchResponse;
  }
}
