import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'def.dart';
import 'list.dart';
import 'gesture.dart';
import 'myhtttp.dart';
import 'relative-layout.dart';
import 'mywebview.dart';
import 'html.dart';
import 'mywebview2.dart';
import 'dart:ui';
import 'blur.dart';
import 'screenshot.dart';

const String PAGE_MAIN = "Main";
const String PAGE_DEF = "默认页面";
const String PAGE_LIST = "列表";
const String PAGE_GESTURE = "画板";
const String PAGE_HTTP = "HTTP";
const String PAGE_RELATIVE = "Relative布局";
const String PAGE_WEBVIEW = "Webview";
const String PAGE_HTML = "HTML";
const String PAGE_WEBVIEW2 = "WebView2"; // use flutter_inappbrowser
const String PAGE_BLUR_BACK_DROP = "高斯模糊";
const String PAGE_SCREENSHOT = "Screenshot";

const String PAGE_URL_MAIN = "/";
const String PAGE_URL_DEF = "/def";
const String PAGE_URL_LIST = "/list";
const String PAGE_URL_GESTURE = "/gesture";
const String PAGE_URL_HTTP = "/http";
const String PAGE_URL_RELATIVE = "/relative";
const String PAGE_URL_WEBVIEW = "/Webview";
const String PAGE_URL_HTML = "/html";
const String PAGE_URL_WEBVIEW2 = "/Webview2";
const String PAGE_URL_BLUR_BACK_DROP = "/blur_backdrop";
const String PAGE_URL_SCREENSHOT = "/Screenshot";

//void main() => runApp(mainApp); // route: null or "/"

void main() => runApp(_widgetForRoute(window.defaultRouteName));

Widget mainApp = MaterialApp(
  title: "Vali Test",
  theme: ThemeData(primaryColor: Colors.green),
  home: ValiHomePage(),
  routes: <String, WidgetBuilder>{
    PAGE_URL_DEF: (BuildContext context) => DefPage(title: 'Default Page'),
    PAGE_URL_LIST: (BuildContext context) => RandomWords(),
    PAGE_URL_GESTURE: (BuildContext context) => SignatureApp(),
    PAGE_URL_HTTP: (BuildContext context) => HttpPage(),
    PAGE_URL_RELATIVE: (BuildContext context) => RelativeView(),
    PAGE_URL_WEBVIEW: (BuildContext context) => WebViewExample(),
    PAGE_URL_HTML: (BuildContext context) => HtmlExample(),
    PAGE_URL_WEBVIEW2: (BuildContext context) => WebView2App(),
    PAGE_URL_BLUR_BACK_DROP: (BuildContext context) => BlurWidget(),
    PAGE_URL_SCREENSHOT: (BuildContext context) => ScreenPage(),
  },
);

Widget _widgetForRoute(String route) {
  switch (route) {
    case PAGE_URL_MAIN: return mainApp;
    case PAGE_URL_DEF: return DefPage(title: 'Default Page');
    case PAGE_URL_LIST: return RandomWords();
    case PAGE_URL_GESTURE: return signaturePage;
    case PAGE_URL_HTTP: return httpWidget;
    case PAGE_URL_RELATIVE: return RelativeView();
    case PAGE_URL_WEBVIEW: return WebViewExample();
    case PAGE_URL_HTML: return HtmlExample();
    case PAGE_URL_WEBVIEW2: return WebView2App();
    case PAGE_URL_BLUR_BACK_DROP: return BlurWidget();
    case PAGE_URL_SCREENSHOT: return ScreenPage();
    default:
      return Center(
        child: Text('Unknown route: $route', textDirection: TextDirection.ltr),
      );
  }
}

class ValiHomePage extends StatefulWidget {
  @override
  State createState() => HomeState();
}

class _LifeSate with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state.toString());
    Fluttertoast.showToast(
        msg: state.toString(),);
  }
}

class HomeState extends State<ValiHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(_LifeSate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main page"),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            CustomButton(PAGE_DEF,
                pressed: () => _startForResult(context, PAGE_URL_DEF)),
            CustomButton(PAGE_LIST,
                pressed: () => _gotoPage(context, PAGE_URL_LIST)),
            CustomButton(PAGE_GESTURE,
                pressed: () => _gotoPage(context, PAGE_URL_GESTURE)),
            CustomButton(PAGE_HTTP,
                pressed: () => _gotoPage(context, PAGE_URL_HTTP)),
            CustomButton(PAGE_RELATIVE,
                pressed: () => _gotoPage(context, PAGE_URL_RELATIVE)),
            CustomButton(PAGE_WEBVIEW,
                pressed: () => _gotoPage(context, PAGE_URL_WEBVIEW)),
            CustomButton(PAGE_HTML,
                pressed: () => _gotoPage(context, PAGE_URL_HTML)),
            CustomButton(PAGE_WEBVIEW2,
                pressed: () => _gotoPage(context, PAGE_URL_WEBVIEW2)),
            CustomButton(PAGE_BLUR_BACK_DROP,
                pressed: () => _gotoPage(context, PAGE_URL_BLUR_BACK_DROP)),
            CustomButton(PAGE_SCREENSHOT,
                pressed: () => _gotoPage(context, PAGE_URL_SCREENSHOT)),
          ],
        ),
      ),
    );
  }

  void _gotoPage(BuildContext context, String page) {
    Navigator.of(context).pushNamed(page);
  }

  void _startForResult(BuildContext context, String page) async {
    var _msg = await Navigator.of(context).pushNamed(page);
    Fluttertoast.showToast(
        msg: "返回数据：$_msg",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1 // ios
    );
  }
}
