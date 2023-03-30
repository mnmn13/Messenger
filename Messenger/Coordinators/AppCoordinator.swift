//
//  AppCoordinator.swift
//  Messenger
//
//  Created by MN on 03.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

class AppCoordinator {
    private let window: UIWindow
    private let serviceHolder = ServiceHolder()
    
    private var authCoordinator: AuthFlowCoordinator?
    private var tabBarCoordinator: TabBarCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        startLocationServices()
        startServices()
        start()
    }
    
    private func start() {
        
        if UserDefaults.standard.isLoggedIn {
            enterApp()
        } else {
            startAuthFlow()
        }
    }
    
    private func startAuthFlow() {
        authCoordinator = AuthFlowCoordinator(window: window, transitions: self, serviceHolder: serviceHolder)
        authCoordinator?.start()
        tabBarCoordinator = nil
    }
    private func enterApp() {
        
        tabBarCoordinator = TabBarCoordinator(window: window, transitions: self, serviceHolder: serviceHolder)
        tabBarCoordinator?.start()
        authCoordinator = nil
    }
    
    private func startUserServices() {
        
    }
}

extension AppCoordinator: AuthFlowCoordinatorTransitions {
    func userDidLogin() {
        
        enterApp()
    }
    func startWithoutLogin() {
        enterApp()
    }
}
extension AppCoordinator: TabbarCoordinatorTransitions {
    func logout() {
        startAuthFlow()
    }
}
//MARK: - Services routine
extension AppCoordinator {
    
    private func startServices() {
//        serviceHolder.add(NetworkService.self, for: NetworkService())
        serviceHolder.add(UserService.self, for: UserService())
        serviceHolder.add(ProgressHudService.self, for: ProgressHudService())
        serviceHolder.add(ChatService.self, for: ChatService())
//        serviceHolder.add(LocalSearchService.self, for: LocalSearchService())

    }
    
    private func startLocationServices() {
        
//        serviceHolder.add(UserLocationService.self, for: UserLocationService())
        
    }
    
}

