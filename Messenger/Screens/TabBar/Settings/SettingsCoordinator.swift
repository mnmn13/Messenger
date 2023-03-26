//
//  SettingsCoordinator.swift
//  Messenger
//
//  Created by MN on 06.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

protocol SettingsCoordinatorTransitions: AnyObject {
    func logOut()
}

protocol SettingsCoordinatorType {
    func logOut()
}

class SettingsCoordinator: SettingsCoordinatorType {
    
    private let serviceHolder: ServiceHolder
    private weak var navigationController: UINavigationController?
    private weak var transitions: SettingsCoordinatorTransitions?
    
    init(serviceHolder: ServiceHolder, navigationController: UINavigationController?, transitions: SettingsCoordinatorTransitions?) {
        self.serviceHolder = serviceHolder
        self.navigationController = navigationController
        self.transitions = transitions
    }
    
    deinit {
        print("\(type(of: self)) \(#function)")
    }
    
    func start() {
        
        if let controller = Storyboard.settings.controller(withClass: SettingsViewController.self) {
            let viewModel = SettingsViewModel(coordinator: self, serviceHolder: serviceHolder)
            controller.viewModel = viewModel
            navigationController?.setViewControllers([controller], animated: true)
        }
    }
    
    func logOut() {
        transitions?.logOut()
    }
    
}
