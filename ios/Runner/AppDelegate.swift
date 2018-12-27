import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
        ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController;
        let batteryChannel = FlutterMethodChannel.init(name: "app.channel.shared.data",
                                                       binaryMessenger: controller);
        batteryChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            if ("getBatteryLevel" == call.method) {
                self.receiveBatteryLevel(result: result);
            } else if ("getSharedText"  == call.method) {
                result("aaaa");
            } else {
                result(FlutterMethodNotImplemented);
            }
        });
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func receiveBatteryLevel(result: FlutterResult) {
        let device = UIDevice.current;
        device.isBatteryMonitoringEnabled = true;
        if (device.batteryState == UIDeviceBatteryState.unknown) {
            result(FlutterError.init(code: "UNAVAILABLE",
                                     message: "电池信息不可用",
                                     details: nil));
        } else {
            result(Int(device.batteryLevel * 100));
        }
    }

}
