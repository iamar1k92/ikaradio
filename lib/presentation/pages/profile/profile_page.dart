import 'package:base/generated/l10n.dart';
import 'package:base/injection_container.dart';
import 'package:base/presentation/blocs/user/bloc.dart';
import 'package:base/presentation/pages/profile/notification_list_page.dart';
import 'package:base/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin<ProfilePage>, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(150.0),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: AppBar(
              automaticallyImplyLeading: false,
              title: _buildProfileArea(context),
              actions: <Widget>[
                IconButton(
                  icon: Icon(FontAwesomeIcons.cog),
                  onPressed: () => Navigator.of(context).pushNamed(Routes.settings),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    isScrollable: true,
                    indicatorWeight: 3.0,
                    tabs: [
                      Tab(child: Text(S.of(context).notifications)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            NotificationListPage(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileArea(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (BuildContext context, UserState state) {
        if (sl<DotEnv>().env['MOBILE_AUTHENTICATION_REQUIRED'] == '1') {
          if (BlocProvider.of<UserBloc>(context).user == null) {
            Navigator.of(context).pushReplacementNamed(Routes.logIn);
          }
        }
      },
      child: BlocBuilder<UserBloc, UserState>(
        builder: (BuildContext context, UserState state) {
          if (BlocProvider.of<UserBloc>(context).user != null) {
            return Row(
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(color: Theme.of(context).accentColor), borderRadius: BorderRadius.all(Radius.circular(50.0))),
                  child: Center(
                    child: Icon(
                      FontAwesomeIcons.user,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(BlocProvider.of<UserBloc>(context).user.fullName()),
                    ),
                    Container(
                      height: 30.0,
                      child: Row(
                        children: <Widget>[
                          FlatButton(
                            onPressed: () => Navigator.of(context).pushNamed(Routes.accountSettings),
                            child: Text(
                              S.of(context).account_settings,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                          Container(margin: EdgeInsets.symmetric(horizontal: 5.0), width: 1, height: 10.0, color: Theme.of(context).accentColor),
                          FlatButton(
                            onPressed: () => BlocProvider.of<UserBloc>(context).add(LogOut()),
                            child: Text(
                              S.of(context).log_out,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            );
          } else {
            return FlatButton.icon(
              padding: EdgeInsets.all(0),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              icon: Container(
                width: 35.0,
                height: 35.0,
                padding: EdgeInsets.only(left: 3.0),
                decoration: BoxDecoration(color: Theme.of(context).accentColor, borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Icon(
                  FontAwesomeIcons.chevronRight,
                  color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
                  size: 20.0,
                ),
              ),
              label: Text(
                S.of(context).log_in,
                style: Theme.of(context).textTheme.headline1.copyWith(fontWeight: FontWeight.bold),
              ),
              onPressed: () => Navigator.of(context).pushNamed(Routes.logIn),
            );
          }
        },
      ),
    );
  }
}
