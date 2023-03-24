//
//  ConversationsCoordinator.swift
//  Messenger
//
//  Created by MN on 06.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

protocol ConversationsCoordinatorTransitions: AnyObject {
    
    func logOut()
    
}

protocol ConversationsCoordinatorType {
    
    func logOut()
    func openChat(with companion: User, messages: [Message])
    func openChatWithConversation(with companion: User, conversation: Conversation)
    
}

class ConversationsCoordinator: ConversationsCoordinatorType {
    
    private let serviceHolder: ServiceHolder
    private weak var navigationController: UINavigationController?
    private weak var transitions: ConversationsCoordinatorTransitions?
    private weak var conversationsController = Storyboard.conversations.controller(withClass: ConversationsViewController.self)
    
    init(serviceHolder: ServiceHolder, navigationController: UINavigationController?, transitions: ConversationsCoordinatorTransitions) {
        self.serviceHolder = serviceHolder
        self.navigationController = navigationController
        self.transitions = transitions
    }
    
    deinit {
        print("\(type(of: self)) \(#function)")
    }
    
    func start() {
        if let controller = Storyboard.conversations.controller(withClass: ConversationsViewController.self) {
            let viewModel = ConversationsViewModel(coordinator: self, serviceholder: serviceHolder)
            controller.viewModel = viewModel
            navigationController?.setViewControllers([controller], animated: true)
        }
    }
    
    func logOut() {
        transitions?.logOut()
    }
    
    func openChat(with companion: User, messages: [Message]) {
        let coordinator = ChatCoordinator(serviceHolder: serviceHolder, navigationController: navigationController, transitions: self)
            coordinator.start(with: companion)
            
        
    }
    
    func openChatWithConversation(with companion: User, conversation: Conversation) {
        let coordinator = ChatCoordinator(serviceHolder: serviceHolder, navigationController: navigationController, transitions: self)
        coordinator.startWithConversation(with: companion, conversation: conversation)
    }
    
    
}

extension ConversationsCoordinator: ChatCoordinatorTransitions {}
