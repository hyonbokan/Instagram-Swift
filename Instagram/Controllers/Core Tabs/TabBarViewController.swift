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
        
        // Define VCs
        let home = HomeViewController()
        let explore = ExploreViewController()
        let camera = CameraViewController()
        let activity = NotificationsViewController()
        let profile = ProfileViewController()
        
        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: explore)
        let nav3 = UINavigationController(rootViewController: camera)
        let nav4 = UINavigationController(rootViewController: activity)
        let nav5 = UINavigationController(rootViewController: profile)
        
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
    }
    
}
