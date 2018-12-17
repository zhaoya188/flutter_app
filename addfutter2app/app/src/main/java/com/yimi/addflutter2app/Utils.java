package com.yimi.addflutter2app;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;

public class Utils {

    private static final String TAG = "YIMI-Utils";

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

    public static Bitmap takeScreenShot(Activity activity) {
        View rootView = activity.getWindow().getDecorView();
        return createViewBitmap(rootView);
    }

    private static Bitmap mergeScreenShot(
            Activity activity, byte[] data, int left, int top, int height, int width) {
        Log.d(TAG, "mergeScreenShot: " + left + ", " + top + ", " + height + ", " + width);
        // flutterBitmap
        Bitmap flutterBitmap = BitmapFactory.decodeByteArray(data, 0, data.length, null);
        /* todo: Remove me if the flutter's bug was fixed.
         * cut off 1px bottom of the flutter view, because of flutter's bug:
         * "take screenshot for flutter view inside normal android Activity (non-FlutterActivity),
         * will get a black line in the bottom of it."
         */
        flutterBitmap = Bitmap.createBitmap(flutterBitmap,
                0, 0, flutterBitmap.getWidth(), flutterBitmap.getHeight() - 1);

        flutterBitmap = Bitmap.createScaledBitmap(flutterBitmap, width, height, false);

        // nativeBitmap
        Bitmap nativeBitmap = takeScreenShot(activity);
        // mergeBitmap
        Bitmap mergeBitmap = Bitmap.createBitmap(
                nativeBitmap.getWidth(), nativeBitmap.getHeight(), Bitmap.Config.RGB_565);
        Canvas sumCanvas = new Canvas(mergeBitmap);
        sumCanvas.drawBitmap(nativeBitmap, 0, 0, null);
        sumCanvas.drawBitmap(flutterBitmap, left, top, null);

        return mergeBitmap;
    }

    public static void addScreenShotView(final Activity activity) {
        addScreenShotView(activity, null);
    }

    public static void addScreenShotView(
            final Activity activity, final FlutterScreenShot flutterScreenShot) {
        final ImageView screenshotImg = new ImageView(activity);

        FrameLayout.LayoutParams imgLp = new FrameLayout.LayoutParams(600, 1000);
        imgLp.leftMargin = 20;
        imgLp.topMargin = 20;
        imgLp.gravity = Gravity.CENTER;

        FrameLayout.LayoutParams btnLp = new FrameLayout.LayoutParams(250, 150);
        btnLp.leftMargin = 20;
        btnLp.topMargin = 200;
        btnLp.gravity = Gravity.RIGHT;

        Button screenshotBtn = new Button(activity);
        screenshotBtn.setTextSize(10);
        screenshotBtn.setAllCaps(false);
        screenshotBtn.setText("screenshot/clear");
        screenshotBtn.setAlpha(0.5F);
        screenshotBtn.setOnClickListener(new View.OnClickListener() {
            boolean clear = true;

            @Override
            public void onClick(View v) {
                if (clear) {
                    if (flutterScreenShot != null) {
                        // native view + flutter view
                        flutterScreenShot.takeScreenShot(new NativeScreenShot() {
                            @Override
                            public void takeScreenShot(
                                    byte[] data, int left, int top, int height, int width) {
                                screenshotImg.setImageBitmap(
                                        mergeScreenShot(activity, data, left, top, height, width));
                            }
                        });
                    } else {
                        // only native view
                        screenshotImg.setImageBitmap(Utils.takeScreenShot(activity));
                    }
                    clear = false;
                } else {
                    screenshotImg.setImageBitmap(null);
                    clear = true;
                }
            }
        });

        activity.addContentView(screenshotBtn, btnLp);
        activity.addContentView(screenshotImg, imgLp);
    }

    interface FlutterScreenShot {
        void takeScreenShot(NativeScreenShot nativeScreenShot);
    }

    interface NativeScreenShot {
        void takeScreenShot(byte[] data, int left, int top, int height, int width);
    }

}
