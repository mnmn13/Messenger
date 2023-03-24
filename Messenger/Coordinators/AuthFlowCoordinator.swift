//
//  AuthFlowCoordinator.swift
//  Messenger
//
//  Created by MN on 03.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

protocol AuthFlowCoordinatorTransitions: AnyObject {
    func userDidLogin()
    func startWithoutLogin()
}

class AuthFlowCoordinator {
    
    private let window: UIWindow
    private let rootNav: UINavigationController = UINavigationController()
    private weak var transitions: AuthFlowCoordinatorTransitions?
    private let serviceHolder: ServiceHolder
    
    init(window: UIWindow, transitions: AuthFlowCoordinatorTransitions, serviceHolder: ServiceHolder) {
        self.window = window
        self.transitions = transitions
        self.serviceHolder = serviceHolder
    }
    
    func start() {
        
        let coordinator = SignInCoordinator(navigationController: rootNav, transitions: self, serviceHolder: serviceHolder)
        coordinator.start()
        
        window.rootViewController = rootNav
        window.makeKeyAndVisible()
    }
    
    deinit {
        print("\(type(of: self)) \(#function)")
    }
}

extension AuthFlowCoordinator: SignInCoordinatorTransitions {
    func userDidLogin() {
        transitions?.userDidLogin()
    }
    
    func signUp() {
        let coordinator = SignUpCoordinator(navigationController: rootNav, transitions: self, serviceHolder: serviceHolder)
        coordinator.start()
        
//        if let controller: SignUpViewController = Storyboard.auth.instantiateViewController() {
//            rootNav.pushViewController(controller, animated: true)
        }
    
    
    func startWithoutLogin() {
        transitions?.startWithoutLogin()
    }
}

extension AuthFlowCoordinator: SignUpCoordinatorTransitions {
    func userDidRegister() {
        transitions?.userDidLogin()
    }
    
    func signIn() {
        
    }
}
