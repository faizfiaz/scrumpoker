import UIKit
import Flutter
import Firebase
import Smartech
import UserNotifications
import UserNotificationsUI
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, SmartechDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GMSServices.provideAPIKey("AIzaSyBQpxzoazAtNWrrsxafEWaAw3Zqn47aWFc")
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
        }
        Smartech.sharedInstance().initSDK(with: self, withLaunchOptions: launchOptions)
        Smartech.sharedInstance().registerForPushNotificationWithDefaultAuthorizationOptions()
        Smartech.sharedInstance().setDebugLevel(.verbose)
        Smartech.sharedInstance().trackAppInstallUpdateBySmartech()
        Smartech.sharedInstance().registerForPushNotificationWithDefaultAuthorizationOptions()
        
        GeneratedPluginRegistrant.register(with: self)
        application.registerForRemoteNotifications()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        Smartech.sharedInstance().didRegisterForRemoteNotifications(withDeviceToken: deviceToken)
        super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Smartech.sharedInstance().didFailToRegisterForRemoteNotificationsWithError(error)
    }
    
    override init() {
        FirebaseApp.configure()
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      Smartech.sharedInstance().willPresentForegroundNotification(notification)
      completionHandler([.alert, .badge, .sound])
    }
        
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      Smartech.sharedInstance().didReceive(response)
      completionHandler()
    }
    
}


