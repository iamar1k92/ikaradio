import 'dart:convert';

import 'package:base/core/network/network_helper.dart';
import 'package:base/core/sharedpref/shared_preference_helper.dart';
import 'package:base/core/utils/exceptions/network_exceptions.dart';
import 'package:base/core/utils/network_helper.dart';
import 'package:base/data/models/podcast.dart';
import 'package:base/data/responses/podcast_response.dart';
import 'package:base/domain/interfaces/base_podcast_repository.dart';
import 'package:base/injection_container.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PodcastApiProvider implements BasePodcastRepository {
  NetworkHelper _networkHelper = sl<NetworkHelper>();
  SharedPreferenceHelper _sharedPreferenceHelper = sl<SharedPreferenceHelper>();

  @override
  Future<PodcastResponse> getPodcasts({int categoryId, String search, bool isFeatured = false, int limit}) async {
    Map<String, dynamic> params = Map<String, dynamic>();
    if (categoryId != null) {
      params['category_id'] = categoryId;
    }

    if (search != null) {
      params['search'] = search;
    }

    if (isFeatured == true) {
      params['is_featured'] = isFeatured;
    }

    if (limit != null) {
      params['limit'] = limit;
    }

    String _lang = await _sharedPreferenceHelper.getLanguage();
    Response response = await _networkHelper.provideDio().get(
          '/podcast',
          queryParameters: params,
          options: buildCacheOptions(Duration(minutes: int.parse(sl<DotEnv>().env['CACHE_TIME'].toString())), primaryKey: 'podcasts-' + _lang),
        );
    dynamic parsedData = jsonDecode(response.data);
    if (parsedData['success'] == true) {
      return PodcastResponse.success(parsedData['data']);
    } else {
      throw NetworkException(message: parsedData['error']);
    }
  }

  @override
  Future<PodcastResponse> getFavoritePodcasts() async {
    Response response = await _networkHelper.provideDio().get('/user/podcast');
    dynamic parsedData = jsonDecode(response.data);
    if (parsedData['success'] == true) {
      return PodcastResponse.success(parsedData['data']);
    } else {
      throw NetworkException(message: generateErrorText(parsedData['data']));
    }
  }

  @override
  Future<PodcastResponse> addFavoritePodcast(Podcast podcast) async {
    Response response = await _networkHelper.provideDio().post('/user/podcast', data: {"podcast_id": podcast.id.toString()});
    dynamic parsedData = jsonDecode(response.data);
    if (parsedData['success'] == true) {
      return PodcastResponse();
    } else {
      throw NetworkException(message: generateErrorText(parsedData['data']));
    }
  }

  @override
  Future<PodcastResponse> removeFavoritePodcast(Podcast podcast) async {
    Response response = await _networkHelper.provideDio().delete('/user/podcast', data: {"podcast_id": podcast.id.toString()});
    dynamic parsedData = jsonDecode(response.data);
    if (parsedData['success'] == true) {
      return PodcastResponse();
    } else {
      throw NetworkException(message: generateErrorText(parsedData['data']));
    }
  }
}
