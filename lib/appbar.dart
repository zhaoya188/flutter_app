import 'package:flutter/material.dart';

/// 自定义AppBar
/// https://sergiandreplace.com/planets-flutter-from-design-to-app/
class GradientAppBar extends StatelessWidget {
  final String title;
  final double barHeight = 56.0;

  GradientAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return new Container(
      padding: new EdgeInsets.only(top: statusBarHeight),
      height: statusBarHeight + barHeight,
      child: new Center(
        child: new Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 28.0)),
      ),
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
            colors: [const Color(0xFF3366FF), const Color(0xFF00CCFF)],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
    );
  }
}


/// test for GradientAppBar
class CustomAppBar extends StatefulWidget {

  @override
  State createState() => _CustomAppBarStatus();
}

class _CustomAppBarStatus extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: ,  // disable original appBar
      body: GradientAppBar("AppBar"),
    );
  }
}