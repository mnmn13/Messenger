//
//  SettingsTabbarCoordinator.swift
//  Messenger
//
//  Created by MN on 05.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

protocol SettingsTabbarCoordinatorTransitions: AnyObject {
    func logOut()
}

protocol SettingsTabbarCoordinatorType {
    func logOut()
}

class SettingsTabbarCoordinator: TabbarItemsCoordinatorType {
    
    let rootController = UINavigationController()
    let tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear.circle"), tag: 0)
    private weak var transitions: SettingsTabbarCoordinatorTransitions?
    private var serviceHodler: ServiceHolder
    
    init(transitions: SettingsTabbarCoordinatorTransitions, serviceHodler: ServiceHolder) {
        self.transitions = transitions
        self.serviceHodler = serviceHodler
    }
    
    deinit {
        print("\(type(of: self)) \(#function)")
    }
    
    func start() {
        rootController.tabBarItem = tabBarItem
        let coordinator = SettingsCoordinator(serviceHolder: serviceHodler, navigationController: rootController, transitions: self)
        coordinator.start()
    }
}

extension SettingsTabbarCoordinator: SettingsCoordinatorTransitions {
    func logOut() {
        transitions?.logOut()
    }
}


