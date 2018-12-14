package com.yimi.addflutter2app;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.Switch;

import io.flutter.facade.Flutter;
import io.flutter.facade.FlutterFragment;

public class MainActivity extends AppCompatActivity {
    static final String PAGE_URL_MAIN = "/";
    static final String PAGE_URL_DEF = "/def";
    static final String PAGE_URL_LIST = "/list";
    static final String PAGE_URL_GESTURE = "/gesture";
    static final String PAGE_URL_HTTP = "/http";
    static final String PAGE_URL_RELATIVE = "/relative";
    static final String PAGE_URL_WEBVIEW = "/Webview";
    static final String PAGE_URL_HTML = "/html";
    static final String PAGE_URL_WEBVIEW2 = "/Webview2";

    Switch switchView;
    boolean embeddedFlutterViewAdded;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        initView();
        initData();
    }

    private void initData() {
        embeddedFlutterViewAdded = false;
    }

    private void initView() {
        switchView = (Switch) findViewById(R.id.switchview);
    }

    void openFlutterPage(String route) {
        Class clazz = switchView.isChecked()
                ? FlutterContainerActivity.class // Pure Flutter View
                : FlutterNativeActivity.class; // Hybrid View
        Intent intent = new Intent(this, clazz);
        intent.putExtra(FlutterFragment.ARG_ROUTE, route);
        startActivity(intent);
    }

    public void main(View view) {
        openFlutterPage(PAGE_URL_MAIN);
    }

    public void http(View view) {
        openFlutterPage(PAGE_URL_HTTP);
    }

    public void relative(View view) {
        openFlutterPage(PAGE_URL_RELATIVE);
    }

    public void gesture(View view) {
        openFlutterPage(PAGE_URL_GESTURE);
    }

    public void webview(View view) {
        openFlutterPage(PAGE_URL_WEBVIEW2);
    }

    public void addMain2Curr(View view) {
        if (embeddedFlutterViewAdded) {
            return;
        }
        View flutterView = Flutter.createView(
                MainActivity.this, getLifecycle(), null); // main view (null or '/')
        FrameLayout.LayoutParams layout = new FrameLayout.LayoutParams(600, 1000);
        layout.leftMargin = 100;
        layout.topMargin = 200;
        addContentView(flutterView, layout);

        Utils.addScreenShotView(this);

        embeddedFlutterViewAdded = true;
    }

    public void hybrid(View view) {
        Intent intent = new Intent(this, HybridActivity.class);
        startActivity(intent);
    }
}
