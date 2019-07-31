//
//  AppDelegate.swift
//  Swift Example App
//
//  Created by Tom Hammond on 4/24/19.
//  Copyright © 2019 theoremreach. All rights reserved.
//

import UIKit
import UserNotifications
import TheoremReachSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let TheoremReachAppID = "7a76253a97769269e470d4c66e2d"
    
    let TheoremReachUserID = "23344342252"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print ("**** didFinishLaunchingWithOptions")
        TheoremReachInit(appID: TheoremReachAppID, userID: TheoremReachUserID)

        // Register to receive Apple Push Notifications
        registerForPushNotifications()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: Remote notifications
    
    let apnDeviceTokenKey = "apnDeviceToken"

    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            if (granted) { print("Apple Push Notifications: Permission GRANTED") }
            else {
                print("Apple Push Notifications: Permission REFUSED")
                return
            }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Apple Push Notifications: Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async(execute: {() -> Void in
                UIApplication.shared.registerForRemoteNotifications()
            })
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Apple Push Notifications: Device Token: \(token)")
        // Save the APN device token in defaults file
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: apnDeviceTokenKey)
        
        // This is a good place to update the user's APNS DeviceToken on the remote server!
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Apple Push Notifications: Failed to register: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print ("**** didReceiveRemoteNotification")
        
        // Parse the acuid out of the userInfo dictionary from the notification
        if let surveyAcuid = userInfo["acuid"] as? String {
            let rvc = window!.rootViewController as! ViewController
            rvc.openHotSurvey(surveyAcuid)
        }
        completionHandler(.newData)
    }

}

extension AppDelegate: TheoremReachRewardDelegate, TheoremReachSurveyDelegate, TheoremReachSurveyAvailableDelegate {

    func TheoremReachInit(appID: String, userID: String) {
        TheoremReach.initWithApiKey(TheoremReachAppID, userId: userID)
        guard let theoremReachInstance = TheoremReach.getInstance() else { return }
            theoremReachInstance.rewardListenerDelegate = self
            theoremReachInstance.surveyAvailableDelegate = self
            theoremReachInstance.surveyListenerDelegate = self
            print("TheoremReach Initialized")
    }
    
    func onReward(_ quantity: NSNumber!) {
        print("TheoremReach onReward", quantity.intValue)
    }
    
    func onRewardCenterOpened() {
        print("TheoremReach onRewardCenterOpened")
    }
    
    func onRewardCenterClosed() {
        print("TheoremReach onRewardCenterClosed")
    }
    
    func theoremreachSurveyAvailable(_ surveyAvailable: Bool) {
        print("TheoremReach theoremreachSurveyAvailable", surveyAvailable)
    }
}

