import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final Color backgroundColor;
  final Function onPressed;
  final Widget child;
  final double size;

  const CircleButton({Key key, this.backgroundColor, this.onPressed, this.child, this.size = 40}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: FloatingActionButton(
        heroTag: key,
        backgroundColor: backgroundColor ?? Theme.of(context).primaryIconTheme.color,
        child: child,
        elevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        hoverElevation: 0,
        onPressed: onPressed,
      ),
    );
  }
}
