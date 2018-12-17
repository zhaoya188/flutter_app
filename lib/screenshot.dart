import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'mywebview.dart';

import 'package:image/image.dart' as gimage;
import 'utils.dart' as utils;

const String TAG = "YIMI-flutter";

class ScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenWidget();
  }
}

class ScreenWidget extends StatefulWidget {
  ScreenState createState() => new ScreenState();
}

class ScreenState extends State<ScreenWidget> {
  GlobalKey globalKey = new GlobalKey();
  Uint8List screenShotBytes;

  /// 截图boundary，并且返回图片的二进制数据。
  /// @deprecated
  ///
  /*Future<Uint8List> _capturePng() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    // 注意：png是压缩后格式，如果需要图片的原始像素数据，请使用rawRgba
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    return pngBytes;
  }*/

  /// 优化后的版本
  /// @return Uint8List of JPG
  static Future<Uint8List> captureJpgOptimized(GlobalKey globalKey) async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();

    // 先缩放, 使得后继处理速度更快
    ui.Image image = await boundary.toImage(pixelRatio: 0.9);

    // 提高清晰度, 后继处理速度较慢
    //ui.Image image = await boundary.toImage(pixelRatio: 1.5);

    /// 转成rawRgba格式 - 如果只需要PNG格式, 可直接使用ImageByteFormat.png转码成
    /// 不需要下面的 image 库了 (gimage.encodeJpg)
    var pixelsData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    //var pixelsData = await image.toByteData(format: ui.ImageByteFormat.png);
    var pixels = pixelsData.buffer.asUint8List();

    // 高斯模糊 - 使用  StackBlur 算法 (50-60ms)
    //processImageDataRGBA(pixels, 0, 0, image.width, image.height, 4);

    // 把pixels转回Image并且编码成JPG (200ms左右)
    gimage.Image newImage =
        new gimage.Image.fromBytes(image.width, image.height, pixels);
    Uint8List screenShotBytes = gimage.encodeJpg(newImage);

    if (screenShotBytes != null) {
      print("YIMI-flutter: ===> " + screenShotBytes.toString());
    }

    return screenShotBytes;
  }

  static Future<Uint8List> capturePng(GlobalKey globalKey) async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();

    // 先缩放, 使得后继处理速度更快
    //ui.Image image = await boundary.toImage(pixelRatio: 0.9);

    // 提高清晰度, 后继处理速度较慢
    ui.Image image = await boundary.toImage(pixelRatio: 1.5);

    //var pixelsData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    var pixelsData = await image.toByteData(format: ui.ImageByteFormat.png);
    var pixels = pixelsData.buffer.asUint8List();
    Uint8List screenShotBytes = pixels;

    if (screenShotBytes != null) {
      print("YIMI-flutter: ===> " + screenShotBytes.toString());
    }

    return screenShotBytes;
  }

  static showScreenShotDialog(BuildContext context, GlobalKey globalKey) async {
    Uint8List screenBytes = await ScreenState.captureJpgOptimized(globalKey);
    if (screenBytes != null) {
      showDialog(
        context: context,
        builder: (context) {
          return new SimpleDialog(
            title: Text("ScreenShot"),
            children: <Widget>[Image.memory(screenBytes)],
          );
        },
      );
    }
  }

  /// Take a screenshot for a Flutter View which embedded a Native View.
  ///
  /// <strong> Notice: Only for [WebViewExample] </strong>
  ///
  /// Merge bytes of flutterView and nativeView into a merged image,
  /// and then show mergeImage with a dialog.
  static showScreenShotDialogWithNativeBytes(
      BuildContext context,
      GlobalKey globalKey,
      Future<dynamic> nativeScreenBytes,
      double statusBarHeight) async {
    /// flutter view screenshot bytes
    Uint8List screenBytes = await ScreenState.capturePng(globalKey);
    if (screenBytes == null || screenBytes.length <= 0) {
      print("$TAG error: flutter view screenshot bytes null");
      return;
    }
    ui.Image flutterImage = await utils.loadImage(screenBytes);

    /// native view screenshot bytes
    Uint8List nativeBytes = await nativeScreenBytes;
    if (nativeBytes == null || nativeBytes.length <= 0) {
      print("$TAG error: native view screenshot bytes null");
      return;
    }
    ui.Image nativeImage = await utils.loadImage(nativeBytes);

    /// prepare canvas
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);

    /// prepare location data
    double ratioNative2Flutter =
        nativeImage.width.toDouble() / flutterImage.width.toDouble();
    double appBarHeight =
        Scaffold.of(context).widget.appBar.preferredSize.height;
    double screenHeight = MediaQuery.of(context).size.height;
    double flutterViewTitleBottom =
        (appBarHeight + statusBarHeight) * (flutterImage.height / screenHeight);
    double nativeViewTop = flutterViewTitleBottom * ratioNative2Flutter;
    utils.logd("height: appbar=$appBarHeight, statusBar=$statusBarHeight");

    /// draw flutter view
    //canvas.drawImage(flutterImage, Offset(0, 0), Paint());
    // scaled to adapt for native view, because the native view is more bigger.
    canvas.drawImageRect(
        flutterImage,
        Rect.fromLTRB(0, 0, flutterImage.width.toDouble(),
            flutterImage.height.toDouble()),
        Rect.fromLTRB(0, 0, flutterImage.width.toDouble() * ratioNative2Flutter,
            flutterImage.height.toDouble() * ratioNative2Flutter),
        Paint()..isAntiAlias = true);

    /// draw native view
    // draw from the bottom of the flutter view.
    canvas.drawImage(nativeImage, Offset(0, nativeViewTop), Paint());

    /// show mergeImage with a dialog
    ui.Image mergeImage = recorder.endRecording().toImage(
        nativeImage.width, (nativeImage.height + nativeViewTop).toInt());
    if (screenBytes != null) {
      showDialog(
        context: context,
        builder: (context) {
          return new SimpleDialog(
            title: Text("ScreenShot"),
            children: <Widget>[
              Container(
                child: RawImage(image: mergeImage),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.green)),
              ),
            ],
          );
        },
      );
    }
  }

  ///
  /// UI
  ///
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
        //globalKey用于识别
        key: globalKey,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Screen Shot"),
          ),
          body: RepaintBoundary(
            /// open this to capture the Body only!
            //key: globalKey,
            child: _getBody(),
          ),
        ));
  }

  _getBody() {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.only(top: 20.0),
      child: Center(
        child: ListView(
          children: <Widget>[
            Align(
                alignment: Alignment.center,
                child: RaisedButton(
                  child: Text("截屏", textDirection: TextDirection.ltr),
                  onPressed: _onPressed,
                )),
            Align(
              alignment: Alignment.center,
              child: screenShotBytes != null
                  ? Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)),
                      height: 300,
                      child: Image(image: MemoryImage(screenShotBytes)))
                  : Text("No Screen Shot"),
            )
          ],
        ),
      ),
    );
  }

  _onPressed() async {
    screenShotBytes = await captureJpgOptimized(globalKey);
    if (screenShotBytes != null) {
      setState(() {});
    }
  }
}
