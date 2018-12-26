package com.yimi.addflutter2app;

import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class FlutterContainerActivity extends FlutterActivity {

    private static final String TAG = "YIMI-Flutter";
    private static final String CHANNEL_ID_HYBRID = "com.yimi.flutter_app/hybrid";

    String sharedText;
    Context context;
    SurfaceViewHelper surfaceViewHelper;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        context = this;
        registerMethodChannel();
        Utils.addScreenShotView(this);
    } // onCreate

    void registerMethodChannel() {
        new MethodChannel(getFlutterView(), "app.channel.shared.data")
                .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                        if (methodCall.method.contentEquals("getSharedText")) {
                            String received = "Activity Received: " + methodCall.method;
                            Toast.makeText(FlutterContainerActivity.this,
                                    received, Toast.LENGTH_SHORT).show();
                            sharedText = TextUtils.isEmpty(sharedText)
                                    ? "Hello , I'm Activity!" : sharedText;
                            result.success(sharedText);
                            sharedText = null;
                        } else if (methodCall.method.contentEquals("getBatteryLevel")) {
                            int batteryLevel = getBatteryLevel();
                            if (batteryLevel != -1) {
                                result.success(batteryLevel);
                            } else {
                                result.error("UNAVAILABLE", "Battery level not available.", null);
                            }
                        } else {
                            result.notImplemented();
                        }
                    }
                });

        new MethodChannel(getFlutterView(), CHANNEL_ID_HYBRID)
                .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                        if (methodCall.method.contentEquals("showSurfaceView")) {
                            showSurfaceView();
                            result.success(null);
                        } else {
                            result.notImplemented();
                        }
                    }
                });
    }

    private int getBatteryLevel() {
        int batteryLevel = -1;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
        } else {
            Intent intent = new ContextWrapper(getApplicationContext()).
                    registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
            batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
                    intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
        }
        Log.d(TAG, "getBatteryLevel: " + batteryLevel);
        return batteryLevel;
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (surfaceViewHelper != null) {
            surfaceViewHelper.close();
        }
    }

    private void showSurfaceView() {
        if (surfaceViewHelper == null) {
            surfaceViewHelper = new SurfaceViewHelper(context);
        }
        surfaceViewHelper.open();
    }
}
