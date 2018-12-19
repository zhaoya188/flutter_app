package com.yimi.addflutter2app;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.FrameLayout;
import android.widget.Spinner;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.List;

import io.flutter.facade.Flutter;
import io.flutter.facade.FlutterFragment;

public class MainActivity extends AppCompatActivity {

    private static final String TAG = "YIMI-Flutter-Demo";

    static final String PAGE_URL_MAIN = "/";
    static final String PAGE_URL_DEF = "/def";
    static final String PAGE_URL_LIST = "/list";
    static final String PAGE_URL_GESTURE = "/gesture";
    static final String PAGE_URL_HTTP = "/http";
    static final String PAGE_URL_RELATIVE = "/relative";
    static final String PAGE_URL_WEBVIEW = "/Webview";
    static final String PAGE_URL_HTML = "/html";
    static final String PAGE_URL_WEBVIEW2 = "/Webview2";

    static final String FLUTTER_VIEW_TYPE_PURE = "Pure FlutterView";
    static final String FLUTTER_VIEW_TYPE_NATIVE = "Native nested FlutterView";
    static final String FLUTTER_VIEW_TYPE_FRAGMENT = "Native nested FlutterFragment";

    static final int FLUTTER_VIEW_TYPE_ID_PURE = 0;
    static final int FLUTTER_VIEW_TYPE_ID_NATIVE = 1;
    static final int FLUTTER_VIEW_TYPE_ID_FRAGMENT = 2;

    boolean embeddedFlutterViewAdded;

    private Spinner spinner;
    private List<String> data_list;
    private ArrayAdapter<String> arr_adapter;

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
        spinner = (Spinner) findViewById(R.id.spinner);
        data_list = new ArrayList<String>();
        data_list.add(FLUTTER_VIEW_TYPE_PURE);
        data_list.add(FLUTTER_VIEW_TYPE_NATIVE);
        data_list.add(FLUTTER_VIEW_TYPE_FRAGMENT);
        arr_adapter = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, data_list);
        //设置样式
        arr_adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        //加载适配器
        spinner.setAdapter(arr_adapter);
        spinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {
            }
        });
    }

    void openFlutterPage(String route) {
        Class clazz = null;
        switch ((int) spinner.getSelectedItemId()) {
            case FLUTTER_VIEW_TYPE_ID_PURE:
                clazz = FlutterContainerActivity.class;
                break;
            case FLUTTER_VIEW_TYPE_ID_NATIVE:
                clazz = FlutterNativeActivity.class;
                break;
            case FLUTTER_VIEW_TYPE_ID_FRAGMENT:
                clazz = FlutterFragmentActivity.class;
                break;
            default:
                Toast.makeText(this, "error choice: " + spinner.getSelectedItemId(),
                        Toast.LENGTH_SHORT).show();
                break;
        }
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
