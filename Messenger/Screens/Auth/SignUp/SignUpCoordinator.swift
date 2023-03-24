//
//  SignUpCoordinator.swift
//  Messenger
//
//  Created by MN on 06.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation
import UIKit

protocol SignUpCoordinatorTransitions: AnyObject {
    func userDidRegister()
    func signIn()
}

protocol SignUpCoordinatorType {
    func userDidRegister()
    func signIn()
}


class SignUpCoordinator {
    private weak var navigationController: UINavigationController?
    private weak var transitions: SignUpCoordinatorTransitions?
    private weak var controller = Storyboard.auth.controller(withClass: SignUpViewController.self)
    private var serviceHolder: ServiceHolder
    
    init(navigationController: UINavigationController?, transitions: SignUpCoordinatorTransitions?, serviceHolder: ServiceHolder) {
        self.navigationController = navigationController
        self.transitions = transitions
        self.serviceHolder = serviceHolder
        controller?.viewModel = SignUpViewModel(coordinator: self, serviceHolder: serviceHolder)
        
    }
    
    deinit {
        print("\(type(of: self)) \(#function)")
    }

    func start() {
        if let controller = controller {
//            controller.viewModel = SignUpViewModel(coordinator: self, serviceHolder: serviceHolder)
            navigationController?.pushViewController(controller, animated: true)
//            navigationController?.setViewControllers([controller], animated: false)
        }
    }
}

extension SignUpCoordinator: SignUpCoordinatorType {
    func userDidRegister() {
        transitions?.userDidRegister()
    }
    
    func signIn() {
        transitions?.signIn()
    }
}
