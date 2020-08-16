import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoryListItemShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: GridView.builder(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:  2,
          childAspectRatio:  1,
        ),
        padding: EdgeInsets.all(10.0),
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.all(5.0),
            child:  Container(width: 100, height: 100, color: Colors.white),
          );
        },
      ),
    );
  }
}
