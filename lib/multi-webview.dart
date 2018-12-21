import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'screenshot.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future main() async {
  runApp(new MultiWebViewApp());
}

///
/// Multiple WebViews coexist with NativeViews, the root view is FlutterView.
///
class MultiWebViewApp extends StatefulWidget {
  @override
  _MultiWebViewAppState createState() => new _MultiWebViewAppState();
}

class _MultiWebViewAppState extends State<MultiWebViewApp> {
  InAppWebViewController webView;
  String url = "";
  double progress = 0;

  // for screenshot
  GlobalKey key = new GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RepaintBoundary(
        key: key,
        child: _getHome(),
      ),
    );
  }

  _getHome() {
    return Scaffold(
      appBar: _getAppBar(),
      body: Container(
        child: Column(
//        child: ListView(
          children: <Widget>[
            _getUrlView(),
            (progress != 1.0) ? LinearProgressIndicator(value: progress) : null,
            _getWebView("https://flutter.io/", 200, double.infinity),
            _getButtonBar(),
            _getWebView("https://github.com/zhaoya188", 100, double.infinity),
            Row(
              children: <Widget>[
                _getWebView("https://baidu.com/", 150, 180),
                _getWebView("https://yq.aliyun.com/articles/", 150, 180),
              ],
            ),
          ].where((Object o) => o != null).toList(),
        ),
      ),
      //bottomNavigationBar: _getBottomNavigationBar(),
    );
  }

  _getAppBar() {
    return AppBar(
      title: const Text('Multiple WebViews'),
      actions: <Widget>[
        Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.print),
              onPressed: () {
                ScreenState.showScreenShotDialog(context, key);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _getWebView(String url, double height, double width) {
    return SizedBox(
      height: height,
      width: width,
      child: Container(
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
        //child: _getOriginWebView(url),
        child: _getInAppWebView(url),
      ),
    );
  }

  _getOriginWebView(final String url) {
    return const WebView(
      initialUrl: "https://flutter.io/", //url
      onWebViewCreated: _webViewCreatedCallback,
      javaScriptMode: JavaScriptMode.unrestricted,
    );
  }

  static _webViewCreatedCallback(WebViewController controller) {
    print("YIMI flutter: _webViewCreatedCallback in...");
    //_loading = false;
    //_WebViewState.controller = controller;
    //controller.loadDataWithBaseURL(htmlText);
  }

  _getInAppWebView(String url) {
    print("_getInAppWebView: $url");
    return InAppWebView(
      initialUrl: url,
      initialHeaders: {},
      initialOptions: {},
      onWebViewCreated: (InAppWebViewController controller) {
        webView = controller;
      },
      onLoadStart: (InAppWebViewController controller, String url) {
        print("started $url");
        setState(() {
          this.url = url;
        });
      },
      onProgressChanged: (InAppWebViewController controller, int progress) {
        print("progress $url: $progress");
//        setState(() {
//          this.progress = progress / 100;
//        });
      },
    );
  }

  _getButtonBar() {
    return SizedBox(
      height: 25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          RaisedButton(
            child: Icon(Icons.arrow_back),
            onPressed: () {
              if (webView != null) {
                webView.goBack();
              }
            },
          ),
          RaisedButton(
            child: Icon(Icons.arrow_forward),
            onPressed: () {
              if (webView != null) {
                webView.goForward();
              }
            },
          ),
          RaisedButton(
            child: Icon(Icons.refresh),
            onPressed: () {
              if (webView != null) {
                webView.reload();
              }
            },
          ),
        ],
      ),
    );
  }

  _getUrlView() {
    return Container(
      //padding: EdgeInsets.all(5.0),
      child: Text(
          "CURRENT URL: ${(url.length > 50) ? url.substring(0, 35) + "..." : url}"),
    );
  }

  _getBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.mail),
          title: Text('Item 2'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text('Item 3'),
        ),
      ],
    );
  }
}
