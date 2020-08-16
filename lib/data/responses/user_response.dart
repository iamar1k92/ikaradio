import 'package:base/data/models/user.dart';

class UserResponse {
  final User user;
  final String token;
  final String error;

  UserResponse({this.user, this.error, this.token});

  UserResponse.successUserWithToken(Map<String, dynamic> json)
      : user = User.fromJson(json['user']),
        token = json['token'].toString(),
        error = null;

  UserResponse.successUser(Map<String, dynamic> json)
      : user = User.fromJson(json),
        token = null,
        error = null;

  UserResponse.error(String error)
      : user = null,
        token = null,
        error = error;

  @override
  String toString() {
    return 'UserResponse{user: $user, token: $token, error: $error}';
  }
}
