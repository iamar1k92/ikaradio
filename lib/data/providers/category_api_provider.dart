import 'dart:convert';

import 'package:base/core/network/network_helper.dart';
import 'package:base/core/sharedpref/shared_preference_helper.dart';
import 'package:base/core/utils/exceptions/network_exceptions.dart';
import 'package:base/data/responses/category_response.dart';
import 'package:base/domain/interfaces/base_category_repository.dart';
import 'package:base/injection_container.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CategoryApiProvider implements BaseCategoryRepository {
  NetworkHelper _networkHelper = sl<NetworkHelper>();
  SharedPreferenceHelper _sharedPreferenceHelper = sl<SharedPreferenceHelper>();

  @override
  Future<CategoryResponse> getCategories() async {
    String _lang = await _sharedPreferenceHelper.getLanguage();
    Response response = await _networkHelper.provideDio().get(
          '/category',
          options: buildCacheOptions(Duration(minutes: int.parse(sl<DotEnv>().env['CACHE_TIME'].toString())), primaryKey: 'categories-' + _lang),
        );
    dynamic parsedData = jsonDecode(response.data);
    if (parsedData['success'] == true) {
      return CategoryResponse.success(parsedData['data']);
    } else {
      throw NetworkException(message: parsedData['error']);
    }
  }
}
