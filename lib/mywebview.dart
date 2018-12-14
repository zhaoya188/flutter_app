import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'screenshot.dart';

//void main() => runApp(MaterialApp(home: WebViewExample()));

class SampleMenu extends StatelessWidget {
  const SampleMenu();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('You selected: $value'),
            duration: Duration(seconds: 2),
          ),
        );
        if (value == "loadUrl") {
          print("flutter: =====> loadUrl");
          if (_WebViewState.controller != null) {
            _WebViewState.controller.loadUrl("https://flutter.io");
          }
        } else if (value == "loadData") {
          print("flutter: =====> loadData");
          _WebViewState.controller.loadDataWithBaseURL(_WebViewState.htmlText);
        } else if (value == "screenshot") {
          print("flutter: =====> screenshot");
          ScreenState.showScreenShotDialog(context, _WebViewState.key);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
            const PopupMenuItem<String>(
              value: 'loadUrl',
              child: Text('在线数据'),
            ),
            const PopupMenuItem<String>(
              value: 'loadData',
              child: Text('HTML数据'),
            ),
            const PopupMenuItem<String>(
              value: 'screenshot',
              child: Icon(Icons.print),
            ),
          ],
    );
  }
}

class WebViewExample extends StatefulWidget {
  @override
  State createState() => _WebViewState();
}

class _WebViewState extends State<WebViewExample>{
  static GlobalKey key = new GlobalKey();
  static bool _loading = false;
  static WebViewController controller;
  static const String htmlText = "<html>\n" +
      "<head>\n" +
      "<meta name=\"viewport\" content=\"initial-scale=1.0, user-scalable=no\" />\n" +
      "<style type=\"text/css\"> img{vertical-align:middle;}</style>     <style type=\"text/css\">     .MathJye{border: 0 none;direction: ltr;line-height: normal;display:inline-block;float: none;font-family:'Times New Roman','宋体';font-size:15px;font-style: normal;font-weight: normal;letter-spacing:1px;line-height: normal;margin: 0;padding: 0;text-align: left;text-indent: 0;text-transform: none;white-space: nowrap;word-spacing: normal;word-wrap: normal;-webkit-text-size-adjust:none;}\n" +
      "     .MathJye div,.MathJye span{border: 0 none;margin: 0;padding: 0;line-height: normal;text-align: left;height:auto;_height:auto;white-space:normal}\n" +
      "     .MathJye table{border-collapse:collapse;margin: 0;padding: 0;text-align: center;vertical-align: middle;line-height: normal;font-size: inherit;*font-size: 100%;_font-size: 100%;font-style: normal;font-weight: normal;border: 0;float: none;display: inline-block;*display: inline;zoom: 0;}\n" +
      "     .MathJye table td{padding:0;font-size:inherit;line-height:normal;white-space: nowrap; border:0 none;width:auto;_height:auto}</style>     <style type=\"text/css\">     .FEBox{\" + \"    display: inline;\" + \"    width: 80px;\" +\"    height: 25px;\" +\"    line-height: 25px;\" +\"    border: none;\" +\"    border-bottom: 1px solid #30b4f2;\" +\"    font-size: 14px;\" +\"    padding: 0 20px;\" +\"}</style><style type=\"text/css\"> body{ border-collapse:collapse;} table,th, td{  border: 1px solid #ddd;  border-collapse: collapse;}</style>\n" +
      "</body>\n" +
      "</head>\n" +
      "&emsp;&emsp;&ensp;<p>综合题</p><p>只有一道多选题</p>" +

      "<p><img src=\"http://jximg07.yimifudao.com/JX_System/question/2018-06-25/01fd5c93-0ce5-5ed4-aea4-7a3ea39c513b/01fd5c93-0ce5-5ed4-aea4-7a3ea39c513b.png\">" +
      "</p><img src=\"http://jximg07.yimifudao.com/JX_System/question/2018-06-25/01fd5c93-0ce5-5ed4-aea4-7a3ea39c513b/01fd5c93-0ce5-5ed4-aea4-7a3ea39c513b.png\">" +
      "<img src=\"http://jximg07.yimifudao.com/JX_System/question/2018-06-25/01fd5c93-0ce5-5ed4-aea4-7a3ea39c513b/01fd5c93-0ce5-5ed4-aea4-7a3ea39c513b.png\">" +
      "<img src=\"http://jximg07.yimifudao.com/JX_System/question/2018-06-25/01fd5c93-0ce5-5ed4-aea4-7a3ea39c513b/01fd5c93-0ce5-5ed4-aea4-7a3ea39c513b.png\">" +

      "<p><img src=\"data:image/jpg;base64,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\">" +
      "</p><img src=\"data:image/jpg;base64,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\">" +
      "<img src=\"data:image/jpg;base64,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\">" +
      "<img src=\"data:image/jpg;base64,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\">" +

      "</body>\n" +
      "</html>";

  @override
  void initState() {
    super.initState();
    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: key,
      child: Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView example'),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        actions: <Widget>[const SampleMenu()],
      ),
      body: _getBody(),
    ),);
  }

  _getBody() {
    return _loading
        ? Center(
        child: CircularProgressIndicator(
          semanticsLabel: "lebal",
          semanticsValue: "value",
          backgroundColor: Colors.yellow,
        ))
        : const WebView(
      initialUrl: 'https://flutter.io',
//      initialData: htmlText,
      onWebViewCreated: _webViewCreatedCallback,
      javaScriptMode: JavaScriptMode.unrestricted,
    );
  }

  static _webViewCreatedCallback(WebViewController controller) {
    print("YIMI flutter =====> _webViewCreatedCallback in...");
    _loading = false;
    _WebViewState.controller = controller;
    //controller.loadDataWithBaseURL(htmlText);
  }

}



