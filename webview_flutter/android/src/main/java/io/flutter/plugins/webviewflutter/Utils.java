package io.flutter.plugins.webviewflutter;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.view.View;

import java.io.ByteArrayOutputStream;

public class Utils {

    private Utils() {
    }

    /***
     * require view like: View rootView = context.getWindow().getDecorView();
     */
    public static Bitmap createViewBitmap(View view) {
        Bitmap bitmap = Bitmap.createBitmap(view.getWidth(), view.getHeight(), Bitmap.Config.RGB_565);
        Canvas canvas = new Canvas(bitmap);
        view.draw(canvas);
        return bitmap;
    }

    public static byte[] takeScreenShot(View view) {
        Bitmap bitmap = createViewBitmap(view);
        ByteArrayOutputStream stream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.PNG, 80, stream);
        byte[] byteArray = stream.toByteArray();
        bitmap.recycle();
        return byteArray;
    }

}
