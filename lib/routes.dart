import 'package:base/presentation/pages/profile/account_settings/account_settings.dart';
import 'package:base/presentation/pages/authentication/forgot_password_page.dart';
import 'package:base/presentation/pages/authentication/login_page.dart';
import 'package:base/presentation/pages/authentication/sign_up_page.dart';
import 'package:base/presentation/pages/main_page.dart';
import 'package:base/presentation/pages/landing_page.dart';
import 'package:base/presentation/pages/profile/account_settings/change_password_page.dart';
import 'package:base/presentation/pages/profile/account_settings/update_email_address_page.dart';
import 'package:base/presentation/pages/profile/account_settings/update_my_information_page.dart';
import 'package:base/presentation/pages/profile/settings_page.dart';
import 'package:base/presentation/pages/search_page.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes._();

  //static variables
  static const String mainPage = 'main';
  static const String landing = 'landing';
  static const String logIn = 'log-in';
  static const String signUp = 'sign-up';
  static const String forgotPassword = 'forgot-password';
  static const String settings = 'settings';
  static const String accountSettings = 'account-settings';
  static const String updateEmailAddress = 'update-email-address';
  static const String changePassword = 'change-password';
  static const String updateMyInformation = 'update-my-information';
  static const String search = 'search';

  static final routes = <String, WidgetBuilder>{
    mainPage: (BuildContext context) => MainPage(),
    landing: (BuildContext context) => LandingPage(),
    logIn: (BuildContext context) => LogInPage(),
    signUp: (BuildContext context) => SignUpPage(),
    forgotPassword: (BuildContext context) => ForgotPasswordPage(),
    settings: (BuildContext context) => SettingsPage(),
    accountSettings: (BuildContext context) => AccountSettingsPage(),
    updateEmailAddress: (BuildContext context) => UpdateEmailAddressPage(),
    changePassword: (BuildContext context) => ChangePasswordPage(),
    updateMyInformation: (BuildContext context) => UpdateMyInformationPage(),
    search: (BuildContext context) => SearchPage(),
  };
}
