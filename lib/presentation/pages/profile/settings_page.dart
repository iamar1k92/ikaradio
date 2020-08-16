import 'dart:io';

import 'package:base/core/constants/languages.dart';
import 'package:base/core/utils/network_helper.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/injection_container.dart';
import 'package:base/presentation/blocs/language/bloc.dart';
import 'package:base/presentation/blocs/theme/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  PackageInfo _packageInfo = PackageInfo();


  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  void _loadPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            Card(
              margin: EdgeInsets.symmetric(vertical: 5.0),
              child: ListTile(
                leading: Icon(FontAwesomeIcons.moon, color: Theme.of(context).textTheme.caption.color),
                title: Text(S.of(context).night_mode),
                trailing: Switch(
                  value: BlocProvider.of<ThemeBloc>(context).isDarkTheme,
                  onChanged: (value) => BlocProvider.of<ThemeBloc>(context).add(ChangeTheme()),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Text(S.of(context).application_settings, style: Theme.of(context).textTheme.caption),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 5.0),
              child: ListTile(
                title: Text(S.of(context).change_language),
                trailing: Text(supportedLanguages[BlocProvider.of<LanguageBloc>(context).locale]),
                onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text(S.of(context).change_language),
                    contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: S.delegate.supportedLocales
                          .map(
                            (Locale locale) => RadioListTile(
                              dense: true,
                              groupValue: BlocProvider.of<LanguageBloc>(context).locale,
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(supportedLanguages[locale.languageCode]),
                              value: locale.languageCode,
                              onChanged: (String languageCode) {
                                BlocProvider.of<LanguageBloc>(context).add(ChangeLanguage(locale: languageCode));
                                Navigator.of(context).pop();
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
            Offstage(
              offstage: sl<DotEnv>().env['CONTACT_EMAIL'].toString().isEmpty && (Platform.isIOS ? sl<DotEnv>().env['IOS_STORE_URL'] : sl<DotEnv>().env['GOOGLE_PLAY_URL']).isEmpty,
              child: Container(
                margin: EdgeInsets.only(top: 15),
                child: Text(S.of(context).evaluate, style: Theme.of(context).textTheme.caption),
              ),
            ),
            Offstage(
              offstage: (Platform.isIOS ? sl<DotEnv>().env['IOS_STORE_URL'] : sl<DotEnv>().env['GOOGLE_PLAY_URL']).isEmpty,
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                child: ListTile(
                  title: Text(S.of(context).rate),
                  onTap: () async => await launchUrl(Platform.isIOS ? sl<DotEnv>().env['IOS_STORE_URL'] : sl<DotEnv>().env['GOOGLE_PLAY_URL']),
                ),
              ),
            ),
            Offstage(
              offstage: sl<DotEnv>().env['CONTACT_EMAIL'].toString().isEmpty,
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                child: ListTile(
                  title: Text(S.of(context).leave_feedback),
                  onTap: () async => await launchUrl("mailto:${sl<DotEnv>().env['CONTACT_EMAIL']}?subject=${sl<DotEnv>().env['APP_NAME']}"),
                ),
              ),
            ),
            Offstage(
              offstage: (Platform.isIOS ? sl<DotEnv>().env['IOS_STORE_URL'] : sl<DotEnv>().env['GOOGLE_PLAY_URL']).isEmpty &&
                  sl<DotEnv>().env['WEBSITE_URL'].toString().isEmpty &&
                  sl<DotEnv>().env['TWITTER_URL'].toString().isEmpty &&
                  sl<DotEnv>().env['INSTAGRAM_URL'].toString().isEmpty &&
                  sl<DotEnv>().env['FACEBOOK_URL'].toString().isEmpty,
              child: Container(
                margin: EdgeInsets.only(top: 15),
                child: Text(S.of(context).follow, style: Theme.of(context).textTheme.caption),
              ),
            ),
            Offstage(
              offstage: (Platform.isIOS ? sl<DotEnv>().env['IOS_STORE_URL'] : sl<DotEnv>().env['GOOGLE_PLAY_URL']).isEmpty,
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                child: ListTile(
                  title: Text(S.of(context).share_application),
                  onTap: () => Share.share(Platform.isIOS ? sl<DotEnv>().env['IOS_STORE_URL'] : sl<DotEnv>().env['GOOGLE_PLAY_URL']),
                ),
              ),
            ),
            Offstage(
              offstage: sl<DotEnv>().env['WEBSITE_URL'].toString().isEmpty,
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                child: ListTile(
                  title: Text(S.of(context).visit_our_website),
                  onTap: () async => await launchUrl("${sl<DotEnv>().env['WEBSITE_URL']}"),
                ),
              ),
            ),
            Offstage(
              offstage: sl<DotEnv>().env['TWITTER_URL'].toString().isEmpty,
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                child: ListTile(
                  title: Text(S.of(context).follow_on_twitter),
                  onTap: () async => await launchUrl("${sl<DotEnv>().env['TWITTER_URL']}"),
                ),
              ),
            ),
            Offstage(
              offstage: sl<DotEnv>().env['INSTAGRAM_URL'].toString().isEmpty,
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                child: ListTile(
                  title: Text(S.of(context).follow_on_instagram),
                  onTap: () async => await launchUrl("${sl<DotEnv>().env['INSTAGRAM_URL']}"),
                ),
              ),
            ),
            Offstage(
              offstage: sl<DotEnv>().env['FACEBOOK_URL'].toString().isEmpty,
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                child: ListTile(
                  title: Text(S.of(context).like_on_facebook),
                  onTap: () async => await launchUrl("${sl<DotEnv>().env['FACEBOOK_URL']}"),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Text(S.of(context).about, style: Theme.of(context).textTheme.caption),
            ),
            Offstage(
              offstage: sl<DotEnv>().env['ABOUT_US_URL'].toString().isEmpty,
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                child: ListTile(
                  title: Text(S.of(context).about_us),
                  onTap: () async => await launchUrl("${sl<DotEnv>().env['ABOUT_US_URL']}?lang=${BlocProvider.of<LanguageBloc>(context).locale}"),
                ),
              ),
            ),
            Offstage(
              offstage: sl<DotEnv>().env['PRIVACY_POLICY_URL'].toString().isEmpty,
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                child: ListTile(
                  title: Text(S.of(context).privacy_policy),
                  onTap: () async => await launchUrl("${sl<DotEnv>().env['PRIVACY_POLICY_URL']}?lang=${BlocProvider.of<LanguageBloc>(context).locale}"),
                ),
              ),
            ),
            Offstage(
              offstage: sl<DotEnv>().env['TERMS_AND_CONDITIONS_URL'].toString().isEmpty,
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                child: ListTile(
                  title: Text(S.of(context).terms_and_conditions),
                  onTap: () async => await launchUrl("${sl<DotEnv>().env['TERMS_AND_CONDITIONS_URL']}?lang=${BlocProvider.of<LanguageBloc>(context).locale}"),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 5.0),
              child: ListTile(
                title: Text(S.of(context).version),
                trailing: Text(_packageInfo.version.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
