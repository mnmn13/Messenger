//
//  SignUp1Coordinator.swift
//  Messenger
//
//  Created by MN on 30.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

protocol SignUp1CoordinatorTransitions: AnyObject {
    func nextClicked(_ from: BaseSignUpCoordinatorProtocol, with email: String, password: String)
}

protocol SignUp1CoordinatorType: BaseSignUpCoordinatorProtocol {
    func backClicked()
}

class SignUp1Coordinator: SignUp1CoordinatorType {
    
    private let navigationController: UINavigationController?
    private var transitions: SignUp1CoordinatorTransitions?
    private weak var controller = Storyboard.signUp.controller(withClass: SignUp1ViewController.self)
    private var serviceHolder: ServiceHolder
    
    init(navigationController: UINavigationController?, transitions: SignUp1CoordinatorTransitions, serviceHolder: ServiceHolder) {
        self.navigationController = navigationController
        self.transitions = transitions
        self.serviceHolder = serviceHolder
    }
    
    deinit {
        print("\(type(of: self)) \(#function)")
    }
    
    func start() {
        if let controller = controller {
            controller.viewModel = SignUp1ViewModel(coordinator: self, serviceHolder: serviceHolder)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func backClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    func nextClicked(email: String, password: String, firstName: String?, lastName: String?) {
        transitions?.nextClicked(self, with: email, password: password)
    }
}
