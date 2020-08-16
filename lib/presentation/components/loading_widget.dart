import 'package:flutter/material.dart';

class LoadingWidget extends StatefulWidget {
  @override
  _Loadingcomponentstate createState() => _Loadingcomponentstate();
}

class _Loadingcomponentstate extends State<LoadingWidget> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: AnimatedBuilder(
        animation: CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _buildContainer(150 * _controller.value),
              _buildContainer(200 * _controller.value),
              _buildContainer(250 * _controller.value),
              _buildContainer(300 * _controller.value),
              _buildContainer(350 * _controller.value),
              Align(
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                  child: Center(child: Image.asset('assets/images/logo.jpg')),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(1 - _controller.value),
      ),
    );
  }
}
