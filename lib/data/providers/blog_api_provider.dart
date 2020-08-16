import 'dart:convert';

import 'package:base/core/network/network_helper.dart';
import 'package:base/core/sharedpref/shared_preference_helper.dart';
import 'package:base/core/utils/exceptions/network_exceptions.dart';
import 'package:base/data/responses/blog_response.dart';
import 'package:base/domain/interfaces/base_blog_repository.dart';
import 'package:base/injection_container.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meta/meta.dart';

class BlogApiProvider implements BaseBlogRepository {
  SharedPreferenceHelper _sharedPreferenceHelper = sl<SharedPreferenceHelper>();
  NetworkHelper _networkHelper = sl<NetworkHelper>();

  @override
  Future<BlogResponse> getBlogs({int categoryId, String search, int limit}) async {
    String _lang = await _sharedPreferenceHelper.getLanguage();
    Map<String, dynamic> params = Map<String, dynamic>();

    if (categoryId != null) {
      params['category_id'] = categoryId;
    }

    if (search != null) {
      params['search'] = search;
    }

    if (limit != null) {
      params['limit'] = limit;
    }

    Response response = await _networkHelper.provideDio().get(
          '/blog',
          queryParameters: params,
          options: buildCacheOptions(Duration(minutes: int.parse(sl<DotEnv>().env['CACHE_TIME'].toString())), primaryKey: 'blogs-' + _lang),
        );
    dynamic parsedData = jsonDecode(response.data);
    if (parsedData['success'] == true) {
      return BlogResponse.success(parsedData['data']);
    } else {
      throw NetworkException(message: parsedData['error']);
    }
  }

  @override
  Future<BlogResponse> comment({@required int blogId, @required String comment}) async {
    Response response = await _networkHelper.provideDio().post('/blog/comment', data: {"blog_id": blogId, "comment": comment});
    dynamic parsedData = jsonDecode(response.data);
    if (parsedData['success'] == true) {
      return BlogResponse.successComments(parsedData['data']);
    } else {
      throw NetworkException(message: parsedData['error']);
    }
  }

  @override
  Future<BlogResponse> deleteComment({@required int commentId}) async {
    Response response = await _networkHelper.provideDio().delete('/blog/comment', data: {"comment_id": commentId});
    dynamic parsedData = jsonDecode(response.data);
    if (parsedData['success'] == true) {
      return BlogResponse.successComments(parsedData['data']);
    } else {
      throw NetworkException(message: parsedData['error']);
    }
  }
}
