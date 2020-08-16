import 'package:base/core/utils/timeago.dart';
import 'package:base/data/models/notification_message.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/presentation/blocs/notification/bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:base/presentation/components/whoops_widget.dart';

class NotificationListPage extends StatefulWidget {
  @override
  _NotificationListPageState createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  final NotificationBloc _notificationBloc = NotificationBloc();

  @override
  void initState() {
    super.initState();
    _notificationBloc.add(LoadNotifications());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationBloc>(
      create: (BuildContext context) => _notificationBloc,
      child: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (BuildContext context, NotificationState state) {
          if (state is LoadingNotificationState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is LoadedNotificationState) {
            if (state.notifications.length > 0) {
              return ListView.separated(
                itemCount: state.notifications.length,
                separatorBuilder: (BuildContext context, int index) => Divider(height: 0),
                itemBuilder: (BuildContext context, int index) {
                  NotificationMessage _notification = state.notifications[index];
                  return ListTile(
                    leading: _notification.cover?.isNotEmpty ?? false
                        ? CachedNetworkImage(imageUrl: _notification.cover, placeholder: (context, url) => CircularProgressIndicator(), width: MediaQuery.of(context).size.width * 0.2)
                        : null,
                    title: Text(_notification.title, style: Theme.of(context).textTheme.subtitle2.copyWith(fontWeight: FontWeight.bold)),
                    subtitle: Container(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(_notification.message, style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.normal)),
                          SizedBox(height: 5.0),
                          Text(TimeAgo().format(_notification.sentAt), style: Theme.of(context).textTheme.caption),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return WhoopsWidget(
                message: S.of(context).no_data_found,
                onPressed: () => _notificationBloc.add(LoadNotifications()),
              );
            }
          } else if (state is ErrorNotificationState) {
            return WhoopsWidget(
              message: state.error,
              onPressed: () => _notificationBloc.add(LoadNotifications()),
            );
          } else {
            return WhoopsWidget(
              message: S.of(context).no_data_found,
              onPressed: () => _notificationBloc.add(LoadNotifications()),
            );
          }
        },
      ),
    );
  }
}
