import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  final String title;
  final int itemCount;
  final Function(BuildContext, int) itemBuilder;
  final Function(BuildContext, int) separatorBuilder;
  final ScrollPhysics physics;

  const ItemList({Key key, this.title, @required this.itemCount, @required this.itemBuilder, @required this.separatorBuilder, this.physics = const NeverScrollableScrollPhysics()}) : super(key: key);

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
            if (title?.isNotEmpty ?? false) Text(title, style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold)),
            if (title?.isNotEmpty ?? false) Divider(),
            Container(
              child: ListView.separated(
                shrinkWrap: true,
                physics: physics,
                separatorBuilder: separatorBuilder,
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
