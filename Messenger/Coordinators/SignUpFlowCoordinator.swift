//
//  SignUpFlowCoordinator.swift
//  Messenger
//
//  Created by MN on 30.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

protocol BaseSignUpCoordinatorProtocol {
    func nextClicked(email: String, password: String, firstName: String?, lastName: String?)
}

protocol SignUpFlowCoordinatorTransitions: AnyObject {
    func userDidSignUp()
}

class SignUpFlowCoordinator {
    
    private let navigationController: UINavigationController?
    private weak var transitions: SignUpFlowCoordinatorTransitions?
    private let serviceHolder: ServiceHolder
    
    init(navigationController: UINavigationController, transitions: SignUpFlowCoordinatorTransitions, serviceHolder: ServiceHolder) {
        self.navigationController = navigationController
        self.transitions = transitions
        self.serviceHolder = serviceHolder
    }
    
    deinit {
        print("\(type(of: self)) \(#function)")
    }
    
    func start() {
        if let navigationController = navigationController {
            let coordinator = SignUp1Coordinator(navigationController: navigationController, transitions: self, serviceHolder: serviceHolder)
            coordinator.start()
        }
    }
}

extension SignUpFlowCoordinator: SignUp1CoordinatorTransitions, SignUp2CoordinatorTransitions {
    
    func userWasCreated() {
        transitions?.userDidSignUp()
    }
    
    func nextClicked(_ from: BaseSignUpCoordinatorProtocol, with email: String, password: String) {
        if from is SignUp1Coordinator {
            let coordinator = SignUp2Coordinator(navigationController: navigationController, transitions: self, serviceHolder: serviceHolder)
            coordinator.start(email: email, password: password)
        }
    }
}
