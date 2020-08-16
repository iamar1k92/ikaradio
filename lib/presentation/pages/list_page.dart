import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ListPage extends StatelessWidget {
  final String title;
  final String description;
  final Widget body;

  const ListPage({Key key, @required this.title, this.description, @required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (description != null)
              Card(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Html(data: description),
                ),
              ),
            body,
          ],
        ),
      ),
    );
  }
}
