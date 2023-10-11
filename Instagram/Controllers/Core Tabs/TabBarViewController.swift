//
//  TabBarViewController.swift
//  Instagram
//
//  Created by Michael Kan on 2023/08/27.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let email = UserDefaults.standard.string(forKey: "email"),
              let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        let currentUser = User(
            username: username,
            email: email
        )
        
        // Define VCs
        let home = NewHomeViewController()
        let explore = ExploreViewController()
        let camera = CameraViewController()
        let activity = NotificationsViewController()
        let profile = ProfileViewController(user: currentUser)
        
        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: explore)
        let nav3 = UINavigationController(rootViewController: camera)
        let nav4 = UINavigationController(rootViewController: activity)
        let nav5 = UINavigationController(rootViewController: profile)
        
        nav1.navigationBar.tintColor = .label
        nav2.navigationBar.tintColor = .label
        nav3.navigationBar.tintColor = .label
        nav4.navigationBar.tintColor = .label
        nav5.navigationBar.tintColor = .label
        
        if #available(iOS 14.0, *) {            
            home.navigationItem.backButtonDisplayMode = .minimal
            explore.navigationItem.backButtonDisplayMode = .minimal
            camera.navigationItem.backButtonDisplayMode = .minimal
            activity.navigationItem.backButtonDisplayMode = .minimal
            profile.navigationItem.backButtonDisplayMode = .minimal
            
        } else {
            nav1.navigationItem.backButtonTitle = ""
            nav2.navigationItem.backButtonTitle = ""
            nav3.navigationItem.backButtonTitle = ""
            nav4.navigationItem.backButtonTitle = ""
            nav5.navigationItem.backButtonTitle = ""

        }
        
        // Define tab items
        nav1.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "house"),
            tag: 1
        )
        nav2.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "magnifyingglass"),
            tag: 1
        )
        nav3.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "plus.app"),
            tag: 1
        )
        nav4.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "heart"),
            tag: 1
        )
        nav5.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "person.crop.circle"),
            tag: 1
        )
        
        // Set controllers
        self.setViewControllers([nav1, nav2, nav3, nav4, nav5], animated: false)
        tabBar.tintColor = .label
    }
    
}
