import UIKit
import Flutter
import Firebase // Add this import
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate  {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    Messaging.messaging().delegate = self
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
    } else {
        let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
    }
    application.registerForRemoteNotifications()

    registerForPushNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func registerForPushNotifications() {
      if #available(iOS 10.0, *) {
                 let center  = UNUserNotificationCenter.current()
                 let content = UNMutableNotificationContent()
                  content.sound = UNNotificationSound.default
                 center.delegate = self
                  UNUserNotificationCenter.current().delegate = self
                  center.requestAuthorization(options: [.sound, .alert, .badge])
       { (granted, error) in
                     if error == nil{
                         DispatchQueue.main.async {
                             UIApplication.shared.registerForRemoteNotifications()
                         }
                     }
                 }
             } else {

                 let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                 UIApplication.shared.registerUserNotificationSettings(settings)
                 UIApplication.shared.registerForRemoteNotifications()
             }
  }
}
