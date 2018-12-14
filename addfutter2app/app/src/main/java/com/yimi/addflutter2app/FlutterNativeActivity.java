package com.yimi.addflutter2app;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;

import io.flutter.facade.Flutter;
import io.flutter.facade.FlutterFragment;
import io.flutter.view.FlutterView;

public class FlutterNativeActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        String route = getIntent().getStringExtra(FlutterFragment.ARG_ROUTE);

        FlutterView flutterView = Flutter.createView(
                this, getLifecycle(), route); // main view (null or '/')
        setContentView(flutterView);
        Utils.addScreenShotView(this);
    }

}
