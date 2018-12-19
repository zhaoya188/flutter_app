package com.yimi.addflutter2app;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.app.AppCompatActivity;

import io.flutter.facade.Flutter;
import io.flutter.facade.FlutterFragment;

public class FlutterFragmentActivity extends AppCompatActivity {

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_fragment);

        String route = getIntent().getStringExtra(FlutterFragment.ARG_ROUTE);
        FragmentTransaction tx = getSupportFragmentManager().beginTransaction();
        tx.add(R.id.flutter_fragment, Flutter.createFragment(route));
        tx.commit();
    }
}
