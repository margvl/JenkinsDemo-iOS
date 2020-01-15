//
//  AppDelegate.swift
//  JenkinsDemo
//
//  Created by Martynas Gavelis on 2019-12-17.
//  Copyright © 2019 Martynas Gavelis. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let unusedVariable = 2
        // Override point for customization after application launch.
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

    static func duplicateFuncValue() -> String {
        print("We are adding more text so we could consider it as a duplicate1")
        print("We are adding more text so we could consider it as a duplicate2")
        print("We are adding more text so we could consider it as a duplicate3")
        print("We are adding more text so we could consider it as a duplicate4")
        print("We are adding more text so we could consider it as a duplicate5")
        return "Duplicate"
    }
}

