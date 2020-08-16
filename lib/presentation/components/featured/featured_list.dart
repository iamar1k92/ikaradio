import 'package:flutter/material.dart';

class FeaturedList extends StatelessWidget {
  final String title;
  final int itemCount;
  final Function(BuildContext, int) itemBuilder;

  const FeaturedList({Key key, @required this.title, @required this.itemCount, @required this.itemBuilder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold)),
            Divider(),
            Container(
              height: 150.0,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: itemCount,
                itemBuilder: itemBuilder,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
