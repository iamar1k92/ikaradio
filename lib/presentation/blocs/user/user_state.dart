import 'package:meta/meta.dart';

@immutable
abstract class UserState {}

class InitialUserState extends UserState {}

class LoadingUserState extends UserState {}

class CompletedUserState extends UserState {}

class AuthenticatedUserState extends UserState {}

class ErrorUserState extends UserState {
  final String error;

  ErrorUserState({@required this.error});
}
