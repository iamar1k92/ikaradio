import 'package:base/data/responses/user_response.dart';

abstract class BaseUserRepository {
  Future<UserResponse> currentUser();

  Future<UserResponse> loginWithEmailPassword(String email, String password);

  Future<UserResponse> signUpWithEmailPassword(String firstName, String lastName, String username, String email, String password);

  Future<UserResponse> forgotMyPassword(String email);

  Future<UserResponse> updateEmailAddress(String email);

  Future<UserResponse> changePassword(String currentPassword, String password, String passwordConfirmation);

  Future<UserResponse> updateMyInformation(String firstName, String lastName);

  Future<UserResponse> logOut();

}
