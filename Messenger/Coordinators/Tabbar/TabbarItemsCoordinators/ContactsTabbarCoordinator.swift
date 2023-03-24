//
//  ContactsTabbarCoordinator.swift
//  Messenger
//
//  Created by MN on 05.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

protocol ContactsTabbarCoordinatorTransitions: AnyObject {
    
    func logOut()
    
}

protocol ContactsTabbarCoordinatorType {
    
    func logOut()
    
}

class ContactsTabbarCoordinator: TabbarItemsCoordinatorType {
    
    let rootController = UINavigationController()
    let tabBarItem = UITabBarItem(title: "Contacts", image: UIImage(systemName: "message.circle"), tag: 0)
    private weak var transitions: ContactsTabbarCoordinatorTransitions?
//    private weak var newCoordinator:
    private var serviceHodler: ServiceHolder
    
    init(transitions: ContactsTabbarCoordinatorTransitions, serviceHodler: ServiceHolder) {
        self.transitions = transitions
        self.serviceHodler = serviceHodler
    }
    
    deinit {
        print("\(type(of: self)) \(#function)")
    }
    
    func start() {
        rootController.tabBarItem = tabBarItem
        
        let coordinator = ContactsCoordinator(serviceHolder: serviceHodler, navigationController: rootController, transitions: self)
        coordinator.start()
    }
    
    
    
}

extension ContactsTabbarCoordinator: ContactsCoordinatorTransitions {
    
    func logOut() {
        transitions?.logOut()
    }
    
    
}



