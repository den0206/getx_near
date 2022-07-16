import UIKit
import Flutter
import flutter_config
import GoogleMaps


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    if let iosMapKey = FlutterConfigPlugin.env(for: "GOOGLE_MAPS_IOS_KEY") {
        print(iosMapKey)
        GMSServices.provideAPIKey(iosMapKey)
    }


    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
