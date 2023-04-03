//
//  SignUp2Coordinator.swift
//  Messenger
//
//  Created by MN on 30.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

protocol SignUp2CoordinatorTransitions: AnyObject {
    func userWasCreated()
}

protocol SignUp2CoordinatorType: BaseSignUpCoordinatorProtocol {
    func backClicked()
}

class SignUp2Coordinator: SignUp2CoordinatorType {
    
    private let navigationController: UINavigationController?
    private weak var transitions: SignUp2CoordinatorTransitions?
    private weak var controller = Storyboard.signUp.controller(withClass: SignUp2ViewController.self)
    private var serviceHolder: ServiceHolder
    
    init(navigationController: UINavigationController?, transitions: SignUp2CoordinatorTransitions?, serviceHolder: ServiceHolder) {
        self.navigationController = navigationController
        self.transitions = transitions
        self.serviceHolder = serviceHolder
    }
    
    deinit {
        print("\(type(of: self)) \(#function)")
    }
    
    func start(email: String, password: String) {
        if let controller = controller {
            controller.viewModel = SignUp2ViewModel(coordinator: self, serviceHolder: serviceHolder, email: email, password: password)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func backClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    func nextClicked(email: String, password: String, firstName: String?, lastName: String?) {
        transitions?.userWasCreated()
    }
}
