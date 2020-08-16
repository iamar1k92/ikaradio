import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ListItemShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
        dense: true,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(width: 75.0, height: 75.0, color: Colors.white),
        ),
        title: Container(width: double.infinity, height: 8.0, color: Colors.white),
        subtitle: Container(width: double.infinity, height: 8.0, color: Colors.white),
        trailing: Padding(
          padding: EdgeInsets.all(10.0),
          child: Icon(Icons.favorite),
        ),
      ),
    );
  }
}
