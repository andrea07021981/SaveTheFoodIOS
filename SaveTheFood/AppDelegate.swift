//
//  AppDelegate.swift
//  SaveTheFood
//
//  Created by Andrea Franco on 2020-05-26.
//  Copyright © 2020 Andrea Franco. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import RealmSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()

        
        do {
            let _ = try Realm()
        } catch {
            print("Error realm : \(error)")
        }
        IQKeyboardManager.shared.enable = true
        //Remove toolbar so the keyboard doesn't take too much space
        IQKeyboardManager.shared.enableAutoToolbar = false
        //Keyboard hide whent touching outside
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true;
        
        //Push
        registerForPushNotifications()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func registerForPushNotifications() {
      UNUserNotificationCenter.current() // 1
        .requestAuthorization(options: [.alert, .sound, .badge]) { // 2
          granted, error in
            if (error != nil) {
                print(error)
            } else {
                DispatchQueue.main.async() {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
            print("Permission granted: \(granted)") // 3
      }
    }
}

