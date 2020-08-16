import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FeaturedItemShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(right: 5.0),
      child: Container(
        width: 125.0,
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                child: Container(width: 125, height: 65, color: Colors.white),
              ),
              SizedBox(height: 5.0),
              Container(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(width: double.infinity, height: 12.0, color: Colors.white),
                    SizedBox(height: 5.0),
                    Container(width: 80, height: 12.0, color: Colors.white),
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
