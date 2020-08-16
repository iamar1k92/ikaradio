import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FeaturedItem extends StatelessWidget {
  final Function onPressed;
  final String imageUrl;
  final String title;
  final String subTitle;

  const FeaturedItem({Key key, @required this.onPressed, @required this.imageUrl, @required this.title, @required this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(right: 5.0),
      child: FlatButton(
        padding: EdgeInsets.all(0),
        onPressed: onPressed,
        child: Container(
          width: 125.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: imageUrl,
                width: double.infinity,
                height: 65,
                placeholder: (context, url) => Container(
                  width: double.infinity,
                  height: 65,
                  child: Center(child: CircularProgressIndicator()),
                ),
                fit: BoxFit.contain,
              ),
              SizedBox(height: 5.0),
              Container(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: Theme.of(context).textTheme.subtitle2),
                    Text(subTitle, style: Theme.of(context).textTheme.caption),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
