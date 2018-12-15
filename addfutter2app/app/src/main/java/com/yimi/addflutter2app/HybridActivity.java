package com.yimi.addflutter2app;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.Gravity;
import android.widget.FrameLayout;

import io.flutter.facade.Flutter;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.view.FlutterView;

public class HybridActivity extends AppCompatActivity {
    private static final String TAG = "YIMI-HybridActivity";

    public static final String CHANNEL_ID_HYBRID = "com.yimi.flutter_app/hybrid";
    public static final String CHANNEL_METHOD_SCREENSHOT = "screenshot";

    FrameLayout layout;
    FlutterView flutterView;
    MethodChannel methodChannel;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_hybrid);
        initView();
        initData();
    }

    private void initView() {
        layout = (FrameLayout) findViewById(R.id.rl_flutter_container);

        flutterView = Flutter.createView(
                HybridActivity.this, getLifecycle(), null); // main view (null or '/')
        FrameLayout.LayoutParams lp = new FrameLayout.LayoutParams(600, 1000);
        lp.gravity = Gravity.CENTER;
        layout.addView(flutterView, lp);

        Utils.addScreenShotView(this, new Utils.FlutterScreenShot() {
            @Override
            public void takeScreenShot(final Utils.NativeScreenShot nativeScreenShot) {
                if (methodChannel == null) {
                    return;
                }
                methodChannel.invokeMethod(
                        CHANNEL_METHOD_SCREENSHOT, null, new MethodChannel.Result() {
                            @Override
                            public void success(@Nullable Object o) {
                                int height = flutterView.getMeasuredHeight();
                                int width = flutterView.getMeasuredWidth();
                                int[] loc = new int[2];
                                flutterView.getLocationOnScreen(loc);
                                nativeScreenShot.takeScreenShot(
                                        (byte[]) o, loc[0], loc[1], height, width);
                            }

                            @Override
                            public void error(String s, @Nullable String s1, @Nullable Object o) {
                                Log.e(TAG, "error: " + s + ", " + s1 + ", " + o);
                            }

                            @Override
                            public void notImplemented() {
                                Log.d(TAG, "notImplemented: ");
                            }
                        }
                );
            }
        });
    }

    private void initData() {
        methodChannel = new MethodChannel(flutterView, CHANNEL_ID_HYBRID);
    }

}
