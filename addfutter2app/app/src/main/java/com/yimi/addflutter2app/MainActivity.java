package com.yimi.addflutter2app;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.FrameLayout;

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

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    void openFlutterPage(String route) {
        Intent intent = new Intent(this, FlutterContainerActivity.class);
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
        View flutterView = Flutter.createView(
                MainActivity.this, getLifecycle(), null); // main view (null or '/')
        FrameLayout.LayoutParams layout = new FrameLayout.LayoutParams(600, 1000);
        layout.leftMargin = 100;
        layout.topMargin = 200;
        addContentView(flutterView, layout);
    }
}
