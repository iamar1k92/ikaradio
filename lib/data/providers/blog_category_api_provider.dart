import 'dart:convert';

import 'package:base/core/network/network_helper.dart';
import 'package:base/core/sharedpref/shared_preference_helper.dart';
import 'package:base/core/utils/exceptions/network_exceptions.dart';
import 'package:base/data/responses/blog_category_response.dart';
import 'package:base/domain/interfaces/base_blog_category_repository.dart';
import 'package:base/injection_container.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BlogCategoryApiProvider implements BaseBlogCategoryRepository {
  NetworkHelper _networkHelper = sl<NetworkHelper>();
  SharedPreferenceHelper _sharedPreferenceHelper = sl<SharedPreferenceHelper>();

  @override
  Future<BlogCategoryResponse> getCategories() async {
    String _lang = await _sharedPreferenceHelper.getLanguage();
    Response response = await _networkHelper.provideDio().get(
          '/blog-category',
          options: buildCacheOptions(Duration(minutes: int.parse(sl<DotEnv>().env['CACHE_TIME'].toString())), primaryKey: 'blog-categories-' + _lang),
        );
    dynamic parsedData = jsonDecode(response.data);
    if (parsedData['success'] == true) {
      return BlogCategoryResponse.success(parsedData['data']);
    } else {
      throw NetworkException(message: parsedData['error']);
    }
  }
}
