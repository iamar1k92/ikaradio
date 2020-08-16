import 'dart:async';
import 'package:base/core/sharedpref/shared_preference_helper.dart';
import 'package:base/core/utils/exceptions/network_exceptions.dart';
import 'package:base/data/models/user.dart';
import 'package:base/data/repositories/user_repository.dart';
import 'package:base/data/responses/user_response.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/injection_container.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserRepository _userRepository = sl<UserRepository>();
  final SharedPreferenceHelper _sharedPreferenceHelper = sl<SharedPreferenceHelper>();
  User _user;

  UserBloc() : super(InitialUserState());

  User get user => _user;

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    yield LoadingUserState();
    if (event is CurrentUser) {
      yield* _mapCurrentUserToState();
    } else if (event is LoginWithEmailPassword) {
      yield* _mapLoginWithEmailPasswordToState(event);
    } else if (event is SignUpWithEmailPassword) {
      yield* _mapSignUpWithEmailPasswordToState(event);
    } else if (event is ForgotMyPassword) {
      yield* _mapForgotMyPasswordToState(event);
    } else if (event is UpdateEmailAddress) {
      yield* _mapUpdateEmailAddressToState(event);
    } else if (event is ChangePassword) {
      yield* _mapChangePasswordToState(event);
    } else if (event is UpdateMyInformation) {
      yield* _mapUpdateMyInformationToState(event);
    } else if (event is LogOut) {
      yield* _mapLogoutToState();
    }
  }

  Stream<UserState> _mapCurrentUserToState() async* {
    try {
      //if logged in
      if (await _sharedPreferenceHelper.isLoggedIn()) {
        UserResponse _userResponse = await _userRepository.currentUser();
        if (_userResponse.error == null) {
          _user = _userResponse.user;
          yield CompletedUserState();
        } else {
          yield ErrorUserState(error: _userResponse.error);
        }
      } else {
        yield CompletedUserState();
      }
    } on NetworkException catch (e) {
      //if there is any error, let's log out
      _sharedPreferenceHelper.removeAuthToken();
      _user = null;
      yield ErrorUserState(error: e.message.toString());
    } catch (e) {
      yield ErrorUserState(error: S.current.an_unexpected_problem_has_occurred);
    }
  }

  Stream<UserState> _mapLoginWithEmailPasswordToState(LoginWithEmailPassword event) async* {
    try {
      UserResponse _userResponse = await _userRepository.loginWithEmailPassword(event.email, event.password);
      if (_userResponse.error == null) {
        _user = _userResponse.user;
        _sharedPreferenceHelper.saveAuthToken(_userResponse.token);
        yield AuthenticatedUserState();
      } else {
        yield ErrorUserState(error: _userResponse.error);
      }
    } on NetworkException catch (e) {
      yield ErrorUserState(error: e.message.toString());
    } catch (e) {
      yield ErrorUserState(error: S.current.an_unexpected_problem_has_occurred);
    }
  }

  Stream<UserState> _mapSignUpWithEmailPasswordToState(SignUpWithEmailPassword event) async* {
    try {
      UserResponse _userResponse = await _userRepository.signUpWithEmailPassword(event.firstName, event.lastName, event.username, event.email, event.password);
      if (_userResponse.error == null) {
        _user = _userResponse.user;
        _sharedPreferenceHelper.saveAuthToken(_userResponse.token);
        yield AuthenticatedUserState();
      } else {
        yield ErrorUserState(error: _userResponse.error);
      }
    } on NetworkException catch (e) {
      yield ErrorUserState(error: e.message.toString());
    } catch (e) {
      yield ErrorUserState(error: S.current.an_unexpected_problem_has_occurred);
    }
  }

  Stream<UserState> _mapForgotMyPasswordToState(ForgotMyPassword event) async* {
    try {
      UserResponse _userResponse = await _userRepository.forgotMyPassword(event.email);
      if (_userResponse.error == null) {
        yield CompletedUserState();
      } else {
        yield ErrorUserState(error: _userResponse.error);
      }
    } on NetworkException catch (e) {
      yield ErrorUserState(error: e.message.toString());
    } catch (e) {
      yield ErrorUserState(error: S.current.an_unexpected_problem_has_occurred);
    }
  }

  Stream<UserState> _mapUpdateEmailAddressToState(UpdateEmailAddress event) async* {
    try {
      UserResponse _userResponse = await _userRepository.updateEmailAddress(event.email);
      if (_userResponse.error == null) {
        yield CompletedUserState();
      } else {
        yield ErrorUserState(error: _userResponse.error);
      }
    } on NetworkException catch (e) {
      yield ErrorUserState(error: e.message.toString());
    } catch (e) {
      yield ErrorUserState(error: S.current.an_unexpected_problem_has_occurred);
    }
  }

  Stream<UserState> _mapChangePasswordToState(ChangePassword event) async* {
    try {
      UserResponse _userResponse = await _userRepository.changePassword(event.currentPassword, event.password, event.passwordConfirmation);
      if (_userResponse.error == null) {
        yield CompletedUserState();
      } else {
        yield ErrorUserState(error: _userResponse.error);
      }
    } on NetworkException catch (e) {
      yield ErrorUserState(error: e.message.toString());
    } catch (e) {
      yield ErrorUserState(error: S.current.an_unexpected_problem_has_occurred);
    }
  }

  Stream<UserState> _mapUpdateMyInformationToState(UpdateMyInformation event) async* {
    try {
      UserResponse _userResponse = await _userRepository.updateMyInformation(event.firstName, event.lastName);
      if (_userResponse.error == null) {
        yield CompletedUserState();
      } else {
        yield ErrorUserState(error: _userResponse.error);
      }
    } on NetworkException catch (e) {
      yield ErrorUserState(error: e.message.toString());
    } catch (e) {
      yield ErrorUserState(error: S.current.an_unexpected_problem_has_occurred);
    }
  }

  Stream<UserState> _mapLogoutToState() async* {
    try {
      _user = null;
      UserResponse _userResponse = await _userRepository.logOut();
      if (_userResponse.error == null) {
        _sharedPreferenceHelper.removeAuthToken();
        yield CompletedUserState();
      } else {
        yield ErrorUserState(error: _userResponse.error);
      }
    } on NetworkException catch (e) {
      yield ErrorUserState(error: e.message.toString());
    } catch (e) {
      yield ErrorUserState(error: S.current.an_unexpected_problem_has_occurred);
    }
  }
}
