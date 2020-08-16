import 'package:base/data/providers/user_api_provider.dart';
import 'package:base/domain/interfaces/base_user_repository.dart';
import 'package:base/data/responses/user_response.dart';
import 'package:base/injection_container.dart';

class UserRepository implements BaseUserRepository {
  final UserApiProvider _userApiProvider = sl<UserApiProvider>();

  @override
  Future<UserResponse> currentUser() async {
    UserResponse userResponse = await _userApiProvider.currentUser();
    return userResponse;
  }

  @override
  Future<UserResponse> updateEmailAddress(String email) async {
    return await _userApiProvider.updateEmailAddress(email);
  }

  @override
  Future<UserResponse> changePassword(String currentPassword, String password, String passwordConfirmation) async {
    return await _userApiProvider.changePassword(currentPassword, password, passwordConfirmation);
  }

  @override
  Future<UserResponse> updateMyInformation(String firstName, String lastName) async {
    return await _userApiProvider.updateMyInformation(firstName, lastName);
  }

  @override
  Future<UserResponse> loginWithEmailPassword(String email, String password) async {
    return await _userApiProvider.loginWithEmailPassword(email, password);
  }

  @override
  Future<UserResponse> signUpWithEmailPassword(String firstName, String lastName, String username, String email, String password) async {
    return await _userApiProvider.signUpWithEmailPassword(firstName, lastName, username, email, password);
  }

  @override
  Future<UserResponse> forgotMyPassword(String email) async {
    return await _userApiProvider.forgotMyPassword(email);
  }

  @override
  Future<UserResponse> logOut() async {
    return await _userApiProvider.logOut();
  }
}
