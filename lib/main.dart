import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:audio_service/audio_service.dart';
import 'package:base/core/services/ad_service.dart';
import 'package:base/core/services/notification_service.dart';
import 'package:base/core/sharedpref/shared_preference_helper.dart';
import 'package:base/core/services/navigation_service.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/injection_container.dart';
import 'package:base/presentation/blocs/favorite_podcast/favorite_podcast_bloc.dart';
import 'package:base/presentation/blocs/favorite_radio/bloc.dart';
import 'package:base/presentation/blocs/language/bloc.dart';
import 'package:base/presentation/blocs/theme/bloc.dart';
import 'package:base/presentation/blocs/user/bloc.dart';
import 'package:base/presentation/pages/landing_page.dart';
import 'package:base/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  await sl<DotEnv>().load('.env');
  await sl<AdService>().init();
  //get theme
  bool _isDarkTheme = await sl<SharedPreferenceHelper>().isDarkTheme() ?? false;

  await AndroidAlarmManager.initialize();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(create: (BuildContext context) => ThemeBloc(isDarkTheme: _isDarkTheme)),
        BlocProvider<LanguageBloc>(create: (BuildContext context) => LanguageBloc()),
        BlocProvider<UserBloc>(create: (BuildContext context) => UserBloc()),
        BlocProvider<FavoriteRadioBloc>(create: (BuildContext context) => FavoriteRadioBloc()),
        BlocProvider<FavoritePodcastBloc>(create: (BuildContext context) => FavoritePodcastBloc()),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (BuildContext context, LanguageState languageState) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (BuildContext context, ThemeState themeState) {
              return BlocBuilder<UserBloc, UserState>(
                builder: (BuildContext context, UserState userState) {
                  return MyApp();
                },
              );
            },
          );
        },
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    NotificationService().initializeFCMNotification(context);
  }

  @override
  Widget build(BuildContext context) {
    return AudioServiceWidget(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: sl<NavigationService>().navigatorKey,
        title: sl<DotEnv>().env['APP_NAME'],
        theme: BlocProvider.of<ThemeBloc>(context).state.themeData,
        routes: Routes.routes,
        home: LandingPage(),
        locale: Locale(BlocProvider.of<LanguageBloc>(context).state.locale),
        supportedLocales: S.delegate.supportedLocales.map((language) => Locale(language.languageCode, language.countryCode)).toList(),
        localizationsDelegates: [
          // Built-in localization of basic text for Material widgets
          GlobalMaterialLocalizations.delegate,

          // Built-in localization for text direction LTR/RTL
          GlobalWidgetsLocalizations.delegate,

          // Built-in localization of basic text for Cupertino widgets
          GlobalCupertinoLocalizations.delegate,

          S.delegate
        ],
        // Returns a locale which will be used by the app
        localeResolutionCallback: (locale, supportedLocales) => S.delegate.supportedLocales.firstWhere(
          (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
          orElse: () => supportedLocales.first,
        ),
        // Check if the current device locale is supported
      ),
    );
  }
}
