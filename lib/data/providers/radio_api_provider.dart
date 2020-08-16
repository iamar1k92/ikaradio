import 'dart:convert';

import 'package:base/core/network/network_helper.dart';
import 'package:base/core/sharedpref/shared_preference_helper.dart';
import 'package:base/core/utils/exceptions/network_exceptions.dart';
import 'package:base/core/utils/network_helper.dart';
import 'package:base/data/models/radio_station.dart';
import 'package:base/data/responses/radio_response.dart';
import 'package:base/domain/interfaces/base_radio_repository.dart';
import 'package:base/injection_container.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RadioApiProvider implements BaseRadioRepository {
  NetworkHelper _networkHelper = sl<NetworkHelper>();
  SharedPreferenceHelper _sharedPreferenceHelper = sl<SharedPreferenceHelper>();

  @override
  Future<RadioResponse> getRadios({int categoryId, String search, bool isFeatured = false, int limit}) async {
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
          '/radio',
          queryParameters: params,
          options: buildCacheOptions(Duration(minutes: int.parse(sl<DotEnv>().env['CACHE_TIME'].toString())), primaryKey: 'radios-' + _lang),
        );
    dynamic parsedData = jsonDecode(response.data);
    if (parsedData['success'] == true) {
      return RadioResponse.success(parsedData['data']);
    } else {
      throw NetworkException(message: parsedData['error']);
    }
  }

  @override
  Future<RadioResponse> getFavoriteRadios() async {
    Response response = await _networkHelper.provideDio().get('/user/radio');
    dynamic parsedData = jsonDecode(response.data);
    if (parsedData['success'] == true) {
      return RadioResponse.success(parsedData['data']);
    } else {
      throw NetworkException(message: generateErrorText(parsedData['data']));
    }
  }

  @override
  Future<RadioResponse> addFavoriteRadio(RadioStation radio) async {
    Response response = await _networkHelper.provideDio().post('/user/radio', data: {"radio_id": radio.id.toString()});
    dynamic parsedData = jsonDecode(response.data);
    if (parsedData['success'] == true) {
      return RadioResponse();
    } else {
      throw NetworkException(message: generateErrorText(parsedData['data']));
    }
  }

  @override
  Future<RadioResponse> removeFavoriteRadio(RadioStation radio) async {
    Response response = await _networkHelper.provideDio().delete('/user/radio', data: {"radio_id": radio.id.toString()});
    dynamic parsedData = jsonDecode(response.data);
    if (parsedData['success'] == true) {
      return RadioResponse();
    } else {
      throw NetworkException(message: generateErrorText(parsedData['data']));
    }
  }
}
