import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
    //Aqui agrego la interpretacion del FlutterMethodChannel para resolver cosas de forma nativa
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let batteryChannel = FlutterMethodChannel(name: "samples.flutter.dev/tokbox",
                                                binaryMessenger: controller.binaryMessenger)
      batteryChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      // This method is invoked on the UI thread.
      switch call.method {
          case "beginVideoCall":
            print("beginVideoCall")
            let values = call.arguments as! Dictionary<String, String>
            let apiKey = values["apiKey"]
            let sessionId = values["sessionId"]
            let sessionToken = values["sessionToken"]
            let oneViewController = UIStoryboard(name: "VideoCallStoryboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "VideoCall") as? VideoCallViewController
            oneViewController?.setVideoCallValues(apikey: apiKey, sessionId: sessionId, sessionToken: sessionToken)
            self.window?.rootViewController = oneViewController;
            result("OK")
          default:
            result(FlutterMethodNotImplemented)
      }
    //result.success("OK")
    //result.notImplemented()
      })
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
