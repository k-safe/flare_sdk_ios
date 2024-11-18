//
//  AppDelegate.swift
//  SideEngineSample
//
//  Created by Phoenix on 12/07/2021.
//

import UIKit
import BBSideEngine
import IQKeyboardManager
//import UserNotifications
import BBSideEngine
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Setup the audio session to allow background playback
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up AVAudioSession: \(error)")
        }
        
        // Request authorization for local notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
//            Manage the success or failure response here.
        }
        UNUserNotificationCenter.current().delegate = self
        IQKeyboardManager.shared().isEnabled = true // manage keyboard behaviour
       
        swiftLoaderConfig()
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }

        return true
    }
    func swiftLoaderConfig() {
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 150
        config.spinnerColor = .systemPink
        config.foregroundColor = .black
        config.foregroundAlpha = 0.5
        SwiftLoader.setConfig(config)
        
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    //If the notification comes from the Flare SDK, you need to call the 'performNotificationAction' method below and pass the notification response. This will display a popup asking user if they are okay or not. Based on the user's response, the Flare SDK will send notifications to their partners via Webhook, Slack, Email, and SMS.
    // Handle the tap on the notification when the app is in the foreground or background
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        if response.notification.request.identifier.contains(BBNotifier.flareSDK.rawValue)  {
            BBSideEngineManager.shared.performNotificationAction(notification: response.notification)
        }
        completionHandler()
    }
}
