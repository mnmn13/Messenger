//
//  TabbarController.swift
//  Messenger
//
//  Created by MN on 23.01.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation
import UIKit

class TabbarController: UITabBarController {
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkGray

        tabBar.isTranslucent = false

        tabBar.tintColor = .systemPurple
        tabBar.unselectedItemTintColor = .lightGray
    
        // PageWithChats
        let mainStoryboard = UIStoryboard(name: "PageWithChats", bundle: .main)
        let mainVC = mainStoryboard.instantiateViewController(withIdentifier: "pageWithChats")
        let mainNavController = UINavigationController(rootViewController: mainVC)
        
        // Settings
        let settingsStoryboard = UIStoryboard(name: "Settings", bundle: .main)
        let settingsVC = settingsStoryboard.instantiateViewController(withIdentifier: "settings")
        let settingsNavController = UINavigationController(rootViewController: settingsVC)
        
        
        mainNavController.title = "Main"
        settingsVC.title = "Settings"
        self.setViewControllers([mainNavController,settingsNavController], animated: true)
        
        let titles = ["Chats", "Settings"]
        
        guard var items = self.tabBar.items else { return }
        
        let images = ["message.circle", "gear.circle"]
        
        for i in 0...1 {
            items[i].image = UIImage(systemName: images[i], withConfiguration: UIImage.SymbolConfiguration(scale: .large))
            items[i] = UITabBarItem(title: titles[i], image:  UIImage(systemName: images[i], withConfiguration: UIImage.SymbolConfiguration(scale: .large)), selectedImage:  UIImage(systemName: images[i], withConfiguration: UIImage.SymbolConfiguration(scale: .large)))
        }
    }
}



