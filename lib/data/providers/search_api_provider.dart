import 'dart:convert';

import 'package:base/core/network/network_helper.dart';
import 'package:base/core/sharedpref/shared_preference_helper.dart';
import 'package:base/core/utils/exceptions/network_exceptions.dart';
import 'package:base/data/responses/search_response.dart';
import 'package:base/domain/interfaces/base_search_repository.dart';
import 'package:base/injection_container.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meta/meta.dart';

class SearchApiProvider implements BaseSearchRepository {
  NetworkHelper _networkHelper = sl<NetworkHelper>();
  SharedPreferenceHelper _sharedPreferenceHelper = sl<SharedPreferenceHelper>();

  @override
  Future<SearchResponse> search({@required String query}) async {
    String _lang = await _sharedPreferenceHelper.getLanguage();
    Response response = await _networkHelper.provideDio().get(
          '/search',
          queryParameters: {"query": query},
          options: buildCacheOptions(Duration(minutes: int.parse(sl<DotEnv>().env['CACHE_TIME'].toString())), primaryKey: 'search-' + _lang),
        );
    dynamic parsedData = jsonDecode(response.data);
    if (parsedData['success'] == true) {
      return SearchResponse.success(parsedData['data']);
    } else {
      throw NetworkException(message: parsedData['error']);
    }
  }
}
