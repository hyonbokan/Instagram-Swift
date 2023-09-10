//
//  AppDelegate.swift
//  Instagram
//
//  Created by Michael Kan on 2023/08/15.
//

import UIKit
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        // Add dummy notification for current user
//        let id = NotificationManager.newIdentifier()
//        let model = IGNotification(
//            identifier: id,
//            notificationType: 1,
//            profilePictureUrl: "https://avatars.githubusercontent.com/u/107212320?v=4",
//            username: "RyanKan",
//            dateString: String.date(from: Date()) ?? "Now",
//            isFollowing: nil,
//            postId: "123",
//            postUrl: "https://avatars.githubusercontent.com/u/107212320?v=4"
//        )
//        NotificationManager.shared.create(notification: model, for: "KhenBo")
        
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


}

