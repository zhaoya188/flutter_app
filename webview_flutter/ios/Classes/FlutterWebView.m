#import "FlutterWebView.h"

@implementation FLTWebViewFactory {
  NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  self = [super init];
  if (self) {
    _messenger = messenger;
  }
  return self;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
  return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
  FLTWebViewController* webviewController =
      [[FLTWebViewController alloc] initWithWithFrame:frame
                                       viewIdentifier:viewId
                                            arguments:args
                                      binaryMessenger:_messenger];
  return webviewController;
}

@end

@implementation FLTWebViewController {
  WKWebView* _webView;
  int64_t _viewId;
  FlutterMethodChannel* _channel;
}

- (instancetype)initWithWithFrame:(CGRect)frame
                   viewIdentifier:(int64_t)viewId
                        arguments:(id _Nullable)args
                  binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  if ([super init]) {
    _viewId = viewId;
    _webView = [[WKWebView alloc] initWithFrame:frame];
    NSString* channelName = [NSString stringWithFormat:@"plugins.flutter.io/webview_%lld", viewId];
    _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
    __weak __typeof__(self) weakSelf = self;
    [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
      [weakSelf onMethodCall:call result:result];
    }];
    NSDictionary<NSString*, id>* settings = args[@"settings"];
    [self applySettings:settings];
    NSString* initialUrl = args[@"initialUrl"];
      NSString* initialData = args[@"initialData"];
    if (initialUrl) {
      [self loadUrl:initialUrl];
    } else if (initialData) {
        [_webView loadHTMLString:initialData baseURL:nil];
    }
  }
  return self;
}

- (UIView*)view {
  return _webView;
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([[call method] isEqualToString:@"updateSettings"]) {
    [self onUpdateSettings:call result:result];
  } else if ([[call method] isEqualToString:@"loadUrl"]) {
    [self onLoadUrl:call result:result];
  } else if ([[call method] isEqualToString:@"loadDataWithBaseURL"]) {
    [self loadDataWithBaseURL:call result:result];
  } else if ([[call method] isEqualToString:@"screenshot"]) {
      [self screenshot:call result:result];
  }  else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)onUpdateSettings:(FlutterMethodCall*)call result:(FlutterResult)result {
  [self applySettings:[call arguments]];
  result(nil);
}

- (void)onLoadUrl:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSString* url = [call arguments];
  if (![self loadUrl:url]) {
    result([FlutterError errorWithCode:@"loadUrl_failed"
                               message:@"Failed parsing the URL"
                               details:[NSString stringWithFormat:@"URL was: '%@'", url]]);
  } else {
    result(nil);
  }
}

- (void)loadDataWithBaseURL:(FlutterMethodCall*)call result:(FlutterResult)result {
   NSString* htmlStr = [call arguments];
    [_webView loadHTMLString:htmlStr baseURL:nil];
    result(nil);
}

- (void)screenshot:(FlutterMethodCall*)call result:(FlutterResult)result {
    UIImage *image = [self screenShotView:_webView];
    if (!image) {
        result([FlutterError errorWithCode:@"screenshot_failed"
                                   message:@"Screenshot failed"
                                   details:@"Screenshot failed"]);
    } else {
        NSData *imgData = UIImagePNGRepresentation(image);
        if (!imgData) {
            result([FlutterError errorWithCode:@"screenshot_failed"
                                       message:@"Screenshot failed"
                                       details:@"Screenshot failed"]);
        } else {
            result(imgData);
        }
    }
}

- (void)applySettings:(NSDictionary<NSString*, id>*)settings {
  for (NSString* key in settings) {
    if ([key isEqualToString:@"jsMode"]) {
      NSNumber* mode = settings[key];
      [self updateJsMode:mode];
    } else {
      NSLog(@"webview_flutter: unknown setting key: %@", key);
    }
  }
}

- (void)updateJsMode:(NSNumber*)mode {
  WKPreferences* preferences = [[_webView configuration] preferences];
  switch ([mode integerValue]) {
    case 0:  // disabled
      [preferences setJavaScriptEnabled:NO];
      break;
    case 1:  // unrestricted
      [preferences setJavaScriptEnabled:YES];
      break;
    default:
      NSLog(@"webview_flutter: unknown javascript mode: %@", mode);
  }
}

- (bool)loadUrl:(NSString*)url {
  NSURL* nsUrl = [NSURL URLWithString:url];
  if (!nsUrl) {
    return false;
  }
  NSURLRequest* req = [NSURLRequest requestWithURL:nsUrl];
  [_webView loadRequest:req];
  return true;
}
    
- (UIImage *)screenShotView:(UIView *)view {
    UIImage *imageRet = nil;
    
    if (view) {
        if(UIGraphicsBeginImageContextWithOptions) {
            UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
        } else {
            UIGraphicsBeginImageContext(view.frame.size);
        }
        
        //获取图像
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        imageRet = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return imageRet;
}

@end
