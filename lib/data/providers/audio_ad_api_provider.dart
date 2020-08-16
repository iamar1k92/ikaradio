import 'dart:convert';

import 'package:base/core/utils/exceptions/network_exceptions.dart';
import 'package:base/data/responses/audio_ad_response.dart';
import 'package:base/domain/interfaces/base_audio_ad_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AudioAdApiProvider implements BaseAudioAdRepository {
  @override
  Future<AudioAdResponse> getAudioAd() async {
    await DotEnv().load('.env');

    Dio dio = new Dio();
    dio.options.headers['X-Api-Key'] = DotEnv().env['API_KEY'];
    dio.options.headers['Content-Type'] = 'application/json; charset=utf-8';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.responseType = ResponseType.plain;

    Response response = await dio.get("${DotEnv().env['BASE_API_URL'].toString()}audio-ad");
    dynamic parsedData = jsonDecode(response.data.toString());
    if (parsedData['success'] == true) {
      return AudioAdResponse.success(parsedData['data']);
    } else {
      throw NetworkException(message: parsedData['error']);
    }
  }
}
