import 'dart:convert';

import 'package:base/core/network/network_helper.dart';
import 'package:base/core/utils/exceptions/network_exceptions.dart';
import 'package:base/data/responses/notification_response.dart';
import 'package:base/domain/interfaces/base_notification_repository.dart';
import 'package:base/injection_container.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NotificationApiProvider implements BaseNotificationRepository {
  NetworkHelper _networkHelper = sl<NetworkHelper>();

  @override
  Future<NotificationResponse> getNotifications() async {
    Response response =
        await _networkHelper.provideDio().get('/notification', options: buildCacheOptions(Duration(minutes: int.parse(sl<DotEnv>().env['CACHE_TIME'].toString())), primaryKey: 'notifications'));
    dynamic parsedData = jsonDecode(response.data);
    if (parsedData['success'] == true) {
      return NotificationResponse.success(parsedData['data']);
    } else {
      throw NetworkException(message: parsedData['error']);
    }
  }
}
