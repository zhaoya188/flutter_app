import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

import 'package:image/image.dart' as gimage;

class ScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenWidget();
  }
}

class ScreenWidget extends StatefulWidget {
  _ScreenState createState() => new _ScreenState();
}

class _ScreenState extends State<ScreenWidget> {
  GlobalKey globalKey = new GlobalKey();
  List<int> screenShotBytes;

  /// 截图boundary，并且返回图片的二进制数据。
  /// @deprecated
  ///
  Future<Uint8List> _capturePng() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    // 注意：png是压缩后格式，如果需要图片的原始像素数据，请使用rawRgba
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    return pngBytes;
  }

  /// 优化后的版本
  Future<Uint8List> _capturePngOptimized() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();

    // 先缩放
    ui.Image image = await boundary.toImage(pixelRatio: 0.9);

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
    screenShotBytes = gimage.encodeJpg(newImage);

    if (screenShotBytes != null) {
      setState(() {});
      print("YIMI-flutter: ===> " + screenShotBytes.toString());
    }

    return screenShotBytes;
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
                  onPressed: _capturePngOptimized,
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
}
