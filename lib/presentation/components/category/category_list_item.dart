import 'package:flutter/material.dart';

class CategoryListItem extends StatelessWidget {
  final String title;
  final Function onPressed;

  const CategoryListItem({Key key, @required this.title, @required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(5.0),
      child: FlatButton(
        padding: EdgeInsets.all(0),
        onPressed: onPressed,
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 5,
                left: 5,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    border: Border.all(color: Colors.grey)
                  ),
                  child: Icon(Icons.category,size: 30.0),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(top: 20.0, left: 10.0, bottom: 10.0, right: 10.0),
                  child: Text(title, style: Theme.of(context).textTheme.subtitle1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
