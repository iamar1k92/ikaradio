import 'dart:convert';
import 'dart:io';

import 'package:base/core/network/network_helper.dart';
import 'package:base/core/sharedpref/shared_preference_helper.dart';
import 'package:base/core/utils/exceptions/network_exceptions.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/injection_container.dart';
import 'package:base/presentation/blocs/user/bloc.dart';
import 'package:base/presentation/components/loading_widget.dart';
import 'package:base/routes.dart';
import 'package:dio/dio.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    loadSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: BlocListener<UserBloc, UserState>(
        listener: (BuildContext context, UserState state) async {
          if (state is CompletedUserState) {
            //redirect to login page if user is empty and requires authentication
            //or redirect to the login page if it is the first login.
            if ((BlocProvider.of<UserBloc>(context).user == null && sl<DotEnv>().env['MOBILE_AUTHENTICATION_REQUIRED'] == '1') || (await sl<SharedPreferenceHelper>().isFirstLogin())) {
              //set first login
              await sl<SharedPreferenceHelper>().setFirstLogin(false);

              Navigator.of(context).pushReplacementNamed(Routes.logIn);
            } else {
              Navigator.of(context).pushReplacementNamed(Routes.mainPage);
            }
          } else if (state is ErrorUserState) {
            FlushbarHelper.createError(
              message: state.error,
              title: S.of(context).error,
              duration: Duration(seconds: 5),
            )..show(context);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 350.0,
              child: LoadingWidget(),
            ),
            SizedBox(height: 25.0),
            Text(sl<DotEnv>().env['APP_NAME'], style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white, fontFamily: 'Pacifico')),
          ],
        ),
      ),
    );
  }

  loadSettings() async {
    try {
      NetworkHelper _networkHelper = sl<NetworkHelper>();
      Response response = await _networkHelper.provideDio().get('/setting');
      dynamic parsedData = jsonDecode(response.data);
      if (parsedData['success'] == true) {
        //load variables from server
        (parsedData['data'] as List).forEach((setting) {
          sl<DotEnv>().env[setting['setting_key']] = setting['setting_value'] ?? "";
        });

        sl<SharedPreferenceHelper>().setAudioAdMinute(int.parse(sl<DotEnv>().env['SHOW_AUDIO_AD_X_MINUTE'].toString()));

        if (await checkMinimumVersion()) {
          BlocProvider.of<UserBloc>(context).add(CurrentUser());
        } else {
          showVersionDialog();
        }
      } else {
        showError(parsedData['error'] ?? "");
      }
    } on NetworkException catch (e) {
      showError(e.message.toString());
    } catch (e) {
      showError(S.current.an_unexpected_problem_has_occurred);
    }
  }

  showError(String error) {
    FlushbarHelper.createError(
      title: S.of(context).error,
      message: error,
      duration: Duration(seconds: 5),
    )..show(context);
  }

  Future<bool> checkMinimumVersion() async {
    int minimumVersion = 1;
    if (Platform.isAndroid) {
      minimumVersion = int.parse(sl<DotEnv>().env['MINIMUM_ANDROID_VERSION'] ?? 1);
    } else {
      minimumVersion = int.parse(sl<DotEnv>().env['MINIMUM_IOS_VERSION'] ?? 1);
    }

    PackageInfo _packageInfo = await PackageInfo.fromPlatform();

    if (minimumVersion > int.parse(_packageInfo.buildNumber)) {
      return false;
    } else {
      return true;
    }
  }

  void showVersionDialog() {
    String marketUrl = Platform.isAndroid ? sl<DotEnv>().env['GOOGLE_PLAY_URL'] : sl<DotEnv>().env['APPLE_STORE_URL'];
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(S.of(context).new_version_title),
            content: Text(S.of(context).new_version_description),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  exit(0);
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: Text(
                  S.of(context).close_application,
                  style: TextStyle(color: Colors.red),
                ),
              ),
              FlatButton(
                onPressed: () async => await canLaunch(marketUrl) ? launch(marketUrl) : exit(0),
                child: Text(
                  S.of(context).update_now,
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          );
        });
  }
}
