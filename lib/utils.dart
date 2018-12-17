import 'dart:ui' as ui;
import 'dart:typed_data';

const String TAG = "YIMI-flutter";

Future<ui.Image> loadImage(Uint8List data) async {
  var codec = await ui.instantiateImageCodec(data);
  // add additional checking for number of frames etc here
  var frame = await codec.getNextFrame();
  return frame.image;
}

void logd(String msg) {
  print("$TAG $msg");
}
