//
//  TabbarCoordinator.swift
//  Messenger
//
//  Created by MN on 05.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

enum TabBarItems: Int {
    case conversations
    case contacts
    case settings
}

protocol TabbarCoordinatorTransitions: AnyObject {
    
    func logout()
    
}

protocol TabbarItemsCoordinatorType: AnyObject {
    var rootController: UINavigationController { get }
    var tabBarItem: UITabBarItem { get }
    
}

class TabBarCoordinator {
    
    
    private weak var window: UIWindow?
    private weak var transitions: TabbarCoordinatorTransitions?
    private let serviceHolder: ServiceHolder
    
    private let tabBarController = UITabBarController()
//    private var tabCoordinators: [TabbarItemsCoordinatorType] = []
    private var tabCoordinators: [TabbarItemsCoordinatorType] = []
    
    init(window: UIWindow, transitions: TabbarCoordinatorTransitions, serviceHolder: ServiceHolder) {
        self.window = window
        self.transitions = transitions
        self.serviceHolder = serviceHolder
        
        tabBarController.tabBar.barTintColor = RGBColor(240, 240, 240)
        tabBarController.tabBar.tintColor = RGBColor(20, 20, 20)
        
        //tab bar items coordinator init
//        let firstTabCoord = NewsTabCoordinator(serviceHolder: serviceHolder, transitions: self)
//        firstTabCoord.start()
//
//        let secondTabCoord = ReadingListTabCoordinator(serviceHolder: serviceHolder, transitions: self)
//        secondTabCoord.start()
//
//        let thirdTabCoordinator = ProfileTabCoordinator(serviceHolder: serviceHolder, transitions: self)
//        thirdTabCoordinator.start()
        
        let firstTabCoordinator = ConversationsTabbarCoordinator(transitions: self, serviceHodler: serviceHolder)
        firstTabCoordinator.start()
        
        let secondTabCoordinator = ContactsTabbarCoordinator(transitions: self, serviceHodler: serviceHolder)
        secondTabCoordinator.start()
        
        let thirdTabCoordinator = SettingsTabbarCoordinator(transitions: self, serviceHodler: serviceHolder)
        thirdTabCoordinator.start()
        
        
        
        tabCoordinators = [firstTabCoordinator, secondTabCoordinator, thirdTabCoordinator]
        tabBarController.viewControllers = [firstTabCoordinator.rootController, secondTabCoordinator.rootController, thirdTabCoordinator.rootController]
        
//        let firstTabBarCoordinator = ConversationsTabbarCoordinator
        
    }
    
    
    
    func start(animated: Bool = false) {
        guard let window = window else { return }
        
        if (animated) { // from login
            UIView.transition(with: window, duration: 0.5, options: UIView.AnimationOptions.transitionCrossDissolve, animations: { [weak self] in
                window.rootViewController = self?.tabBarController
            }, completion: nil)
        } else {
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
        }
    }
    
}

//MARK: TabBarCoordinator {
extension TabBarCoordinator {
    
    func getTabCoordinator<T>(index: Int) -> T? {
        if index < tabCoordinators.count {
            return tabCoordinators[index] as? T
        }
        return nil
    }
    
    func selectTab(index: TabBarItems) {
        let tabIndex = index.rawValue
        tabBarController.selectedIndex = tabIndex
        let root = getTabCoordinatorRootNavigation(index: index)
        root?.popViewController(animated: false)
    }
    
    private func getTabCoordinatorRootNavigation(index: TabBarItems) -> UINavigationController? {
        let tabIndex = index.rawValue
        if tabIndex < tabCoordinators.count {
            let tabItem = tabCoordinators[tabIndex]
            return tabItem.rootController
        }
        return nil
    }
}

extension TabBarCoordinator: ConversationsTabbarCoordinatorTransitions {
    
}

extension TabBarCoordinator: ContactsTabbarCoordinatorTransitions {
    func logOut() {
        transitions?.logout()
    }
    
    
}

extension TabBarCoordinator: SettingsTabbarCoordinatorTransitions {
    
}
