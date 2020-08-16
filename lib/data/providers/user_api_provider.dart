import 'dart:convert';

import 'package:base/core/network/network_helper.dart';
import 'package:base/core/utils/exceptions/network_exceptions.dart';
import 'package:base/core/utils/network_helper.dart';
import 'package:base/data/responses/user_response.dart';
import 'package:base/domain/interfaces/base_user_repository.dart';
import 'package:base/injection_container.dart';
import 'package:dio/dio.dart';

class UserApiProvider implements BaseUserRepository {
  NetworkHelper _networkHelper = sl<NetworkHelper>();

  @override
  Future<UserResponse> currentUser() async {
    Response response = await _networkHelper.provideDio().get('/user');
    dynamic parsedData = jsonDecode(response.data);
    if (parsedData['success'] == true) {
      return UserResponse.successUser(parsedData['data']['user']);
    } else {
      throw NetworkException(message: parsedData['error']);
    }
  }

  @override
  Future<UserResponse> loginWithEmailPassword(String email, String password) async {
    Response response = await _networkHelper.provideDio().post('/login', data: {"email": email, "password": password});
    var parsedData = json.decode(response.data);
    if (parsedData['success'] == true) {
      return UserResponse.successUserWithToken(parsedData['data']);
    } else {
      throw NetworkException(message: generateErrorText(parsedData['data']));
    }
  }

  @override
  Future<UserResponse> signUpWithEmailPassword(String firstName, String lastName, String username, String email, String password) async {
    Response response = await _networkHelper.provideDio().post('/sign-up', data: {"first_name": firstName, "last_name": lastName, "username": username, "email": email, "password": password});
    dynamic parsedData = jsonDecode(response.data);
    if (parsedData['success'] == true) {
      return UserResponse.successUserWithToken(parsedData['data']);
    } else {
      throw NetworkException(message: generateErrorText(parsedData['data']));
    }
  }

  @override
  Future<UserResponse> forgotMyPassword(String email) async {
    Response response = await _networkHelper.provideDio().post('/password/forgot', data: {"email": email});
    dynamic parsedData = jsonDecode(response.data);
    if (parsedData['success'] == true) {
      return UserResponse();
    } else {
      throw NetworkException(message: generateErrorText(parsedData['data']));
    }
  }

  @override
  Future<UserResponse> logOut() async {
    Response response = await _networkHelper.provideDio().post('/logout');
    dynamic parsedData = jsonDecode(response.data);
    if (parsedData['success'] == true) {
      return UserResponse();
    } else {
      throw NetworkException(message: generateErrorText(parsedData['data']));
    }
  }

  @override
  Future<UserResponse> updateEmailAddress(String email) async {
    Response response = await _networkHelper.provideDio().post('/update-email-address', data: {"email": email});
    dynamic parsedData = jsonDecode(response.data);
    if (parsedData['success'] == true) {
      return UserResponse();
    } else {
      throw NetworkException(message: generateErrorText(parsedData['data']));
    }
  }

  @override
  Future<UserResponse> changePassword(String currentPassword, String password, String passwordConfirmation) async {
    Response response = await _networkHelper.provideDio().post('/change-password', data: {"current_password": currentPassword, "password": password, "password_confirmation": passwordConfirmation});
    dynamic parsedData = jsonDecode(response.data);
    if (parsedData['success'] == true) {
      return UserResponse();
    } else {
      throw NetworkException(message: generateErrorText(parsedData['data']));
    }
  }

  @override
  Future<UserResponse> updateMyInformation(String firstName, String lastName) async {
    Response response = await _networkHelper.provideDio().post('/update-my-information', data: {"first_name": firstName, "last_name": lastName});
    dynamic parsedData = jsonDecode(response.data);
    if (parsedData['success'] == true) {
      return UserResponse();
    } else {
      throw NetworkException(message: generateErrorText(parsedData['data']));
    }
  }
}
