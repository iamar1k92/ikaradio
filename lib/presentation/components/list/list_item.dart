import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final Function onPressed;
  final String imageUrl;
  final String title;
  final String subTitle;
  final Widget trailing;

  const ListItem({Key key, @required this.onPressed, @required this.imageUrl, @required this.title, @required this.subTitle, @required this.trailing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
      dense: true,
      onTap: onPressed,
      leading: Container(
        width: 75.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: CachedNetworkImage(
            width: 75.0,
            height: 75.0,
            imageUrl: imageUrl,
            placeholder: (context, url) => Container(width: 25.0, child: Center(child: CircularProgressIndicator())),
          ),
        ),
      ),
      title: Text(title, style: Theme.of(context).textTheme.subtitle2),
      subtitle: Text(subTitle, style: Theme.of(context).textTheme.caption),
      trailing: trailing,
    );
  }
}
