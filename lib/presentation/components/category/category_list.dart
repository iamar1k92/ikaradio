import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  final int itemCount;
  final Function(BuildContext, int) itemBuilder;

  const CategoryList({Key key, @required this.itemCount, @required this.itemBuilder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
      ),
      padding: EdgeInsets.all(10.0),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}
