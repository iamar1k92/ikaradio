import 'package:meta/meta.dart';

@immutable
abstract class UserEvent {}

class CurrentUser extends UserEvent {}

class LoginWithEmailPassword extends UserEvent {
  final String email;
  final String password;

  LoginWithEmailPassword({@required this.email, @required this.password});
}

class SignUpWithEmailPassword extends UserEvent {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String password;

  SignUpWithEmailPassword({@required this.firstName, @required this.lastName, @required this.username, @required this.email, @required this.password});
}

class ForgotMyPassword extends UserEvent {
  final String email;

  ForgotMyPassword({@required this.email});
}


class UpdateEmailAddress extends UserEvent {
  final String email;

  UpdateEmailAddress({@required this.email});
}

class ChangePassword extends UserEvent {
  final String currentPassword;
  final String password;
  final String passwordConfirmation;

  ChangePassword({@required this.currentPassword, @required this.password, @required this.passwordConfirmation});
}


class UpdateMyInformation extends UserEvent {
  final String firstName;
  final String lastName;

  UpdateMyInformation({@required this.firstName,@required this.lastName});
}

class LogOut extends UserEvent {}
