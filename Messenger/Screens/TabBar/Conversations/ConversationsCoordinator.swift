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
    func openChatWithConversationIDPagination(with companion: User, conversationID: String)
    func openOpenAIChat()
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
    
    func openChatWithConversationIDPagination(with companion: User, conversationID: String) {
        let coordinator = ChatCoordinator(serviceHolder: serviceHolder, navigationController: navigationController, transitions: self)
        coordinator.startWithConversationsPagination(with: companion, withExistingConversationID: conversationID)
    }
    
    func openOpenAIChat() {
        let coordinator = OpenAIChatCoordinator(serviceHolder: serviceHolder, navigationController: navigationController, transitions: self)
        coordinator.start()
    }
}

extension ConversationsCoordinator: ChatCoordinatorTransitions {}
extension ConversationsCoordinator: OpenAIChatCoordinatorTransitions {}
