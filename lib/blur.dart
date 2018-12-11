import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'myhtttp.dart' as list;

///
/// 一个BackdropFilter高斯模糊的例子
/// Refs: https://gist.github.com/collinjackson/4318255c6390f080f91011329a068d62
///

void main() {
  runApp(new MaterialApp(
    home: new BlurWidget(),
  ));
}

class BlurWidget extends StatefulWidget {
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<BlurWidget> {
  double _sigma = 3.0;
  double _opacity = 0.5;
  bool _showText = true;
  BoxShape _innerClip;
  BoxShape _outerClip;

  @override
  Widget build(BuildContext context) {
    Widget test = new BackdropFilter(
      filter: new ui.ImageFilter.blur(sigmaX: _sigma, sigmaY: _sigma),
      child: new Container(
        color: Colors.blue.withOpacity(_opacity),
        padding: const EdgeInsets.all(30.0),
        // decoration: BoxDecoration(
        //   color: Colors.blue.withOpacity(_opacity),
        //   shape: BoxShape.circle,
        // ),
        width: 200.0,
        height: 200.0,
        child: new Center(
          child: _showText ? new Text('Test') : null,
        ),
      ),
    );
    switch (_innerClip) {
      case BoxShape.circle:
        test = new ClipOval(child: test);
        break;
      case BoxShape.rectangle:
        test = new ClipRRect(
          borderRadius: new BorderRadius.all(new Radius.circular(4.0)),
          child: test,
        );
        break;
    }
    test = new Container(
      decoration: new BoxDecoration(
        color: Colors.grey.shade200.withOpacity(_opacity),
      ),
      padding: new EdgeInsets.all(30.0),
      child: test,
    );
    switch (_outerClip) {
      case BoxShape.circle:
        test = new ClipOval(child: test);
        break;
      case BoxShape.rectangle:
        test = new ClipRect(child: test);
        break;
    }

    Widget background = new Container(
      height: 180.0,
      margin: new EdgeInsets.all(10.0),
      decoration: new BoxDecoration(
          image: new DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("images/blurbg.jpg"),
            //image: new NetworkImage(
            //    'https://github.com/zhaoya188/res/raw/master/img/blurbg.jpg'),
          )),
      child: new Center(
        child: null,
      ),
    );

    background = Container(
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          background,
          Expanded(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child:
                list.HttpPage()), //MaterialButton(color: Colors.green,),)
          ),
        ],
      ),
    );

    test = Container(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          background,
          test,
        ],
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('BackdropFilter Test'),
      ),
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          test,
          new Expanded(
            child: new ListView(
              children: <Widget>[
                new ListTile(
                  title: new Text('Sigma'),
                  subtitle: new Slider(
                    min: 0.0,
                    max: 10.0,
                    value: _sigma,
                    onChanged: (double value) {
                      setState(() {
                        _sigma = value;
                      });
                    },
                  ),
                ),
                new ListTile(
                  title: new Text('Opacity'),
                  subtitle: new Slider(
                    min: 0.0,
                    max: 1.0,
                    value: _opacity,
                    onChanged: (double value) {
                      setState(() {
                        _opacity = value;
                      });
                    },
                  ),
                ),
                new CheckboxListTile(
                  value: _showText,
                  onChanged: (bool value) {
                    setState(() {
                      _showText = value;
                    });
                  },
                  title: new Text('Show text'),
                ),
                new ListTile(
                  title: new Text('Inner clip'),
                  subtitle: new DropdownButton<BoxShape>(
                    onChanged: (BoxShape value) {
                      setState(() {
                        _innerClip = value;
                      });
                    },
                    value: _innerClip,
                    items: <DropdownMenuItem<BoxShape>>[
                      new DropdownMenuItem(
                        value: null,
                        child: new Text('None'),
                      ),
                      new DropdownMenuItem(
                        value: BoxShape.circle,
                        child: new Text('ClipOval'),
                      ),
                      new DropdownMenuItem(
                        value: BoxShape.rectangle,
                        child: new Text('ClipRect'),
                      ),
                    ],
                  ),
                ),
                new ListTile(
                  title: new Text('Outer clip'),
                  subtitle: new DropdownButton<BoxShape>(
                    onChanged: (BoxShape value) {
                      setState(() {
                        _outerClip = value;
                      });
                    },
                    value: _outerClip,
                    items: <DropdownMenuItem<BoxShape>>[
                      new DropdownMenuItem(
                        value: null,
                        child: new Text('None'),
                      ),
                      new DropdownMenuItem(
                        value: BoxShape.circle,
                        child: new Text('ClipOval'),
                      ),
                      new DropdownMenuItem(
                        value: BoxShape.rectangle,
                        child: new Text('ClipRect'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
