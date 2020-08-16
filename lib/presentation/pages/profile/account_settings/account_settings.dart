import 'package:base/generated/l10n.dart';
import 'package:base/presentation/blocs/user/user_bloc.dart';
import 'package:base/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AccountSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(120.0),
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(border: Border.all(color: Theme.of(context).accentColor), borderRadius: BorderRadius.all(Radius.circular(50.0))),
                  child: Center(
                    child: Icon(
                      FontAwesomeIcons.user,
                      color: Theme.of(context).accentColor,
                      size: 30.0,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Text(BlocProvider.of<UserBloc>(context).user.fullName(), style: Theme.of(context).textTheme.subtitle1),
                SizedBox(height: 5.0),
                Text("@" + BlocProvider.of<UserBloc>(context).user.username, style: Theme.of(context).textTheme.subtitle1),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 25.0, left: 5.0, bottom: 5.0),
              child: Text(S.of(context).account_settings, style: Theme.of(context).textTheme.caption),
            ),
            SizedBox(height: 5.0),
            Card(
              margin: EdgeInsets.symmetric(vertical: 5.0),
              child: ListTile(
                leading: Container(width: 30.0, child: Center(child: Icon(FontAwesomeIcons.envelope, size: 18.0))),
                title: Text(S.of(context).update_email_address),
                trailing: Icon(FontAwesomeIcons.angleRight),
                onTap: () => Navigator.of(context).pushNamed(Routes.updateEmailAddress),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 5.0),
              child: ListTile(
                leading: Container(width: 30.0, child: Center(child: Icon(FontAwesomeIcons.key, size: 18.0))),
                title: Text(S.of(context).change_password),
                trailing: Icon(FontAwesomeIcons.angleRight),
                onTap: () => Navigator.of(context).pushNamed(Routes.changePassword),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 5.0),
              child: ListTile(
                leading: Container(width: 30.0, child: Center(child: Icon(FontAwesomeIcons.info, size: 18.0))),
                title: Text(S.of(context).update_my_information),
                trailing: Icon(FontAwesomeIcons.angleRight),
                onTap: () => Navigator.of(context).pushNamed(Routes.updateMyInformation),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
