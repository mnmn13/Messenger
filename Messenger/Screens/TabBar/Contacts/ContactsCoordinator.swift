//
//  ContactsCoordinator.swift
//  Messenger
//
//  Created by MN on 06.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

protocol ContactsCoordinatorTransitions: AnyObject {
    
}

protocol ContactsCoordinatorType {
    
    func openChat(with user: User)
    func openChatWithConversationPagination(with companion: User, conversationID: String)
    
}

class ContactsCoordinator: ContactsCoordinatorType {
    
    private let serviceHolder: ServiceHolder
    private weak var navigationController: UINavigationController?
    private weak var transitions: ContactsCoordinatorTransitions?
    private weak var controller = Storyboard.contacts.controller(withClass: ContactsTableViewController.self)
    
    init(serviceHolder: ServiceHolder, navigationController: UINavigationController?, transitions: ContactsCoordinatorTransitions?) {
        self.serviceHolder = serviceHolder
        self.navigationController = navigationController
        self.transitions = transitions
        controller?.viewModel = ContactsViewModel(coordinator: self, serviceHolder: serviceHolder)
    }
    
    deinit {
        print("\(type(of: self)) \(#function)")
    }
    
    func start() {
        if let controller = controller {
//            controller.viewModel = ContactsViewModel(coordinator: self, serviceHolder: serviceHolder)
            navigationController?.setViewControllers([controller], animated: true)
            
        }
        
    }
    
    func openChat(with user: User) {
        let coordinator = ChatCoordinator(serviceHolder: serviceHolder, navigationController: navigationController, transitions: self)
            coordinator.start(with: user)


    }
    
    func openChatWithConversationPagination(with companion: User, conversationID: String) {
        let coordinator = ChatCoordinator(serviceHolder: serviceHolder, navigationController: navigationController, transitions: self)
        coordinator.startWithConversationsPagination(with: companion, withExistingConversationID: conversationID)
    }
    
    
    
}

extension ContactsCoordinator: ChatCoordinatorTransitions {
    
}
