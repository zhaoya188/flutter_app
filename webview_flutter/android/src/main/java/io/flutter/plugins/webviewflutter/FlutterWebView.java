package io.flutter.plugins.webviewflutter;

import android.content.Context;
import android.util.Log;
import android.view.View;
import android.webkit.WebView;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.platform.PlatformView;

public class FlutterWebView implements PlatformView, MethodCallHandler {

  private static final String TAG = "YIMI-FlutterWebView";

  private final WebView webView;
  private final MethodChannel methodChannel;

  @SuppressWarnings("unchecked")
  FlutterWebView(Context context, BinaryMessenger messenger, int id, Map<String, Object> params) {
    webView = new WebView(context);
    Log.d(TAG, "FlutterWebView: init params =======> " + params.toString());
    String url = null; // -- Vali add
    if (params.containsKey("initialUrl")) {
      url = (String) params.get("initialUrl");
      webView.loadUrl(url);
    }
    // -- Vali add
    if (url == null && params.containsKey("initialData")) {
      String htmlString = (String) params.get("initialData");
      Log.d(TAG, "FlutterWebView: init loadDataWithBaseURL...=======> " + htmlString);
      webView.loadDataWithBaseURL(null, htmlString, "text/html; charset=UTF-8", null, null);
    }
    applySettings((Map<String, Object>) params.get("settings"));
    methodChannel = new MethodChannel(messenger, "plugins.flutter.io/webview_" + id);
    methodChannel.setMethodCallHandler(this);
  }

  @Override
  public View getView() {
    return webView;
  }

  @Override
  public void onMethodCall(MethodCall methodCall, Result result) {
    switch (methodCall.method) {
      case "loadUrl":
        loadUrl(methodCall, result);
        break;
      case "updateSettings":
        updateSettings(methodCall, result);
        break;
      case "loadDataWithBaseURL":  // Vali Add
        loadDataWithBaseURL(methodCall, result);
        break;
      case "screenshot":  // Vali Add
        screenshot(methodCall, result);
        break;
      default:
        result.notImplemented();
    }
  }

  private void loadUrl(MethodCall methodCall, Result result) {
    String url = (String) methodCall.arguments;
    webView.loadUrl(url);
    result.success(null);
  }

  // Vali add
  private void loadDataWithBaseURL(MethodCall methodCall, Result result) {
    String htmlText = (String) methodCall.arguments;
    Log.d(TAG, "loadDataWithBaseURL: " + htmlText);
    webView.loadDataWithBaseURL(null, htmlText, "text/html; charset=UTF-8", null, null);
    result.success(null);
  }

  // Vali add
  private void screenshot(MethodCall methodCall, Result result) {
    byte[] data = Utils.takeScreenShot(webView.getRootView());
    if (data == null || data.length <= 0) {
      String errorMsg = "screenshot: error: got null.";
      Log.e(TAG, errorMsg);
      result.error(errorMsg, null, data);
    } else {
      /*
      StringBuilder msg = new StringBuilder("[");
      for (int i = 0; i < data.length; i++) {
        msg.append(data[i]).append(", ");
      }
      Log.d(TAG, "screenshot: data: " + msg.toString());
      */
      result.success(data);
    }
  }

  @SuppressWarnings("unchecked")
  private void updateSettings(MethodCall methodCall, Result result) {
    applySettings((Map<String, Object>) methodCall.arguments);
    result.success(null);
  }

  private void applySettings(Map<String, Object> settings) {
    for (String key : settings.keySet()) {
      switch (key) {
        case "jsMode":
          updateJsMode((Integer) settings.get(key));
          break;
        default:
          throw new IllegalArgumentException("Unknown WebView setting: " + key);
      }
    }
  }

  private void updateJsMode(int mode) {
    switch (mode) {
      case 0: // disabled
        webView.getSettings().setJavaScriptEnabled(false);
        break;
      case 1: //unrestricted
        webView.getSettings().setJavaScriptEnabled(true);
        break;
      default:
        throw new IllegalArgumentException("Trying to set unknown Javascript mode: " + mode);
    }
  }

  @Override
  public void dispose() {}
}
