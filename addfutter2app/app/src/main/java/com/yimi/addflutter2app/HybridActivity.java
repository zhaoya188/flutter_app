package com.yimi.addflutter2app;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.Gravity;
import android.view.View;
import android.widget.FrameLayout;

import io.flutter.facade.Flutter;

public class HybridActivity extends AppCompatActivity {

    FrameLayout layout;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_hybrid);
        initView();
    }

    private void initView() {
        layout = (FrameLayout) findViewById(R.id.rl_flutter_container);

        View flutterView = Flutter.createView(
                HybridActivity.this, getLifecycle(), null); // main view (null or '/')
        FrameLayout.LayoutParams lp = new FrameLayout.LayoutParams(600, 1000);
        lp.gravity = Gravity.CENTER;
        layout.addView(flutterView, lp);

        Utils.addScreenShotView(this);
    }

}
