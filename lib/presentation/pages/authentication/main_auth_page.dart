import 'package:base/generated/l10n.dart';
import 'package:base/injection_container.dart';
import 'package:base/presentation/components/empty_app_bar_widget.dart';
import 'package:base/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MainAuthPage extends StatelessWidget {
  final String title;
  final String subTitle;
  final Widget child;

  MainAuthPage({@required this.child, @required this.title, @required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EmptyAppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Text(
                    sl<DotEnv>().env['APP_NAME'],
                    style: Theme.of(context).textTheme.headline2.copyWith(fontFamily: 'Pacifico', color: Theme.of(context).accentColor),
                  ),
                ),
                SizedBox(height: 20.0),
                Text(title, style: Theme.of(context).textTheme.headline1),
                Text(subTitle, style: Theme.of(context).textTheme.headline2),
                SizedBox(height: 10.0),
                child,
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: sl<DotEnv>().env['MOBILE_AUTHENTICATION_REQUIRED'] == '1'
          ? SizedBox(height: 0)
          : Container(
              child: FlatButton(onPressed: () => Navigator.of(context).pushReplacementNamed(Routes.mainPage), child: Text(S.of(context).continue_as_a_guest)),
            ),
    );
  }
}
