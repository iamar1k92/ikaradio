import 'package:base/generated/l10n.dart';
import 'package:flutter/material.dart';

class WhoopsWidget extends StatelessWidget {
  final String message;
  final Function onPressed;

  const WhoopsWidget({Key key, @required this.message, @required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 25.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Image.asset('assets/images/whoops.png'),
                ),
                SizedBox(height: 10.0),
                Text(S.of(context).whoops, style: Theme.of(context).textTheme.headline1.copyWith(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold)),
                SizedBox(height: 5.0),
                Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: 10.0),
                RaisedButton(
                  onPressed: onPressed,
                  padding: EdgeInsets.all(10.0),
                  child: Text(S.of(context).refresh, style: TextStyle(color: Colors.white)),
                  color: Theme.of(context).primaryColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
