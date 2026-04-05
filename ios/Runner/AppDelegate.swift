import Flutter
import UIKit
import GoogleMaps
import SCSDKAdvertisingKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyCTr1Bm3IWC4blGfGWbPmNOVj3Auz_zedE")
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let snapchatChannel = FlutterMethodChannel(name: "com.hawiah.plus/snapchat_ads",
                                              binaryMessenger: controller.binaryMessenger)
    
    snapchatChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "trackEvent" {
        if let args = call.arguments as? [String: Any],
           let eventName = args["eventName"] as? String {
          SCSDKAdvertising.track(eventName)
          result(nil)
        } else {
          result(FlutterError(code: "INVALID_ARGUMENT", message: "Event name is missing", details: nil))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
