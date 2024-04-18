import UIKit
import Flutter
import GoogleMaps
// import FirebaseCore

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyBeXmfS_J09cX3frhZTzOHu1iw5YWDOM08")
    // FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    //Change
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    //Change

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
