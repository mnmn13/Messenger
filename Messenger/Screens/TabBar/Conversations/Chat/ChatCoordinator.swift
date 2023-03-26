//
//  ChatCoordinator.swift
//  Messenger
//
//  Created by MN on 06.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

protocol ChatCoordinatorTransitions: AnyObject {
    
}

protocol ChatCoordinatorType {
    
}

class ChatCoordinator: ChatCoordinatorType {
    
    private let serviceHolder: ServiceHolder
    private weak var navigationController: UINavigationController?
    private weak var transitions: ChatCoordinatorTransitions?
    private weak var controller = Storyboard.chat.controller(withClass: ChatTableViewController.self)
    
    init(serviceHolder: ServiceHolder, navigationController: UINavigationController?, transitions: ChatCoordinatorTransitions) {
        self.serviceHolder = serviceHolder
        self.navigationController = navigationController
        self.transitions = transitions
    }
    
    deinit {
        print("\(type(of: self)) \(#function)")
    }
    
    func start(with companion: User) {
        if let controller = controller {
            let viewModel = ChatViewModel(coordinator: self, serviceHolder: serviceHolder, companion: companion)
            controller.viewModel = viewModel
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func startWithConversation(with companion: User, conversation: Conversation) {
        if let controller = controller {
            let viewModel = ChatViewModel(coordinator: self, serviceHolder: serviceHolder, companion: companion)
            viewModel.validateMessagesages(conversation: conversation)
            controller.viewModel = viewModel
            navigationController?.pushViewController(controller, animated: true)
            
        }
    }
    
    func startWithConversationsPagination(with companion: User, withExistingConversationID: String) {
        if let controller = controller {
            let viewModel = ChatViewModel(coordinator: self, serviceHolder: serviceHolder, companion: companion)
            viewModel.loadExistingConversation(conversationID: withExistingConversationID)
            controller.viewModel = viewModel
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
