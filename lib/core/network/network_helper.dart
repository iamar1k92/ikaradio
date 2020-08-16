import 'package:base/core/sharedpref/shared_preference_helper.dart';
import 'package:base/injection_container.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NetworkHelper {
  Dio provideDio() {
    final dio = Dio();
    dio
      ..options.baseUrl = sl<DotEnv>().env["BASE_API_URL"]
      ..options.connectTimeout = int.parse(sl<DotEnv>().env["CONNECTION_TIMEOUT"])
      ..options.receiveTimeout = int.parse(sl<DotEnv>().env["CONNECTION_TIMEOUT"])
      ..options.sendTimeout = int.parse(sl<DotEnv>().env["CONNECTION_TIMEOUT"])
      ..options.headers = {'Content-Type': 'application/json; charset=utf-8', 'Accept': 'application/json'}
      ..options.responseType = ResponseType.plain
      ..options.validateStatus = (int status) {
        return true;
      }
      ..interceptors.add(DioCacheManager(CacheConfig()).interceptor)
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (Options options) async {
            options.headers.putIfAbsent('X-Api-Key', () => sl<DotEnv>().env['API_KEY']);
            // getting shared pref instance
            SharedPreferenceHelper _sharedPreferenceHelper = sl<SharedPreferenceHelper>();
            // getting token
            var token = await _sharedPreferenceHelper.getAuthToken();
            if (token != null) {
              options.headers.putIfAbsent('Authorization', () => "Bearer $token");
            }

            // getting language
            var language = await _sharedPreferenceHelper.getLanguage();
            if (language != null) {
              options.headers.putIfAbsent('Language', () => language);
            }
          },
        ),
      );

    return dio;
  }
}
