//
//  ConversationsTabbarCoordinator.swift
//  Messenger
//
//  Created by MN on 05.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

protocol ConversationsTabbarCoordinatorTransitions: AnyObject {
    func logOut()
}

protocol ConversationsTabbarCoordinatorType {
    func logOut()
}

class ConversationsTabbarCoordinator: TabbarItemsCoordinatorType {
    
    let rootController = UINavigationController()
    let tabBarItem = UITabBarItem(title: "Chats", image: UIImage(systemName: "message.circle"), tag: 0)
    private weak var transitions: ConversationsTabbarCoordinatorTransitions?
    private var serviceHodler: ServiceHolder
    
    init(transitions: ConversationsTabbarCoordinatorTransitions, serviceHodler: ServiceHolder) {
        self.transitions = transitions
        self.serviceHodler = serviceHodler
    }
    
    func start() {
        rootController.tabBarItem = tabBarItem
        
        let coordinator = ConversationsCoordinator(serviceHolder: serviceHodler, navigationController: rootController, transitions: self)
        coordinator.start()
    }
}

extension ConversationsTabbarCoordinator: ConversationsCoordinatorTransitions {
    func logOut() {
        transitions?.logOut()
    }
}
