import UIKit
import Flutter
import flutter_config
import GoogleMaps


@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GMSServices.provideAPIKey(FlutterConfigPlugin.env(for:"GOOGLE_MAPS_IOS_KEY"))
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // NEW: This is where plugin registration lives now
    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    }
}
