package com.yimi.addflutter2app;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.view.Gravity;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;

public class Utils {
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

    public static void addScreenShotView(final Activity activity) {
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
                    screenshotImg.setImageBitmap(Utils.takeScreenShot(activity));
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

}
