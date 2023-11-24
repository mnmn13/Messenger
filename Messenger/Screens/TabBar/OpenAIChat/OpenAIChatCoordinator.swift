//
//  OpenAIChatCoordinator.swift
//  Messenger
//
//  Created by MN on 02.04.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

protocol OpenAIChatCoordinatorTransitions: AnyObject {}

protocol OpenAIChatCoordinatorType {}

class OpenAIChatCoordinator: OpenAIChatCoordinatorType {
    
    private let serviceHolder: ServiceHolder
    private weak var navigationController: UINavigationController?
    private weak var transitions: OpenAIChatCoordinatorTransitions?
    private weak var controller = Storyboard.openAI.controller(withClass: OpenAIChatViewController.self)
    
    init(serviceHolder: ServiceHolder, navigationController: UINavigationController?, transitions: OpenAIChatCoordinatorTransitions?) {
        self.serviceHolder = serviceHolder
        self.navigationController = navigationController
        self.transitions = transitions
    }
    
    deinit {
        print("\(type(of: self)) \(#function)")
    }
    
    func start() {
        if let controller = controller {
            controller.viewModel = OpenAIChatViewModel(coordinator: self, serviceHolder: serviceHolder)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
