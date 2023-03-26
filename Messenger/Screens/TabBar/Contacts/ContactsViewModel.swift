//
//  ContactsViewModel.swift
//  Messenger
//
//  Created by MN on 06.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

protocol ContactsViewModelType {
    var onReload: EmptyClosure? { get set }
    var viewDidLoadCallback: EmptyClosure? { get set }
    
    func loadInfo()
    
    //TableView
    func getNumberOfSections() -> Int
    func getNumberOfRowsInSection() -> Int
    func getCellForRowAt(indexPath: IndexPath) -> User
    
    func didSelectRowAt(indexPath: IndexPath)
    
}

class ContactsViewModel: ContactsViewModelType {
    
    
    var viewDidLoadCallback: EmptyClosure?
    var onReload: EmptyClosure?
    var users: [User] = []
    
    fileprivate let coordinator: ContactsCoordinatorType
    private var userService: UserService
    private var chatService: ChatService
    private var progressHudService: ProgressHudService
    
    init(coordinator: ContactsCoordinatorType, serviceHolder: ServiceHolder) {
        self.coordinator = coordinator
        self.userService = serviceHolder.get()
        self.chatService = serviceHolder.get()
        self.progressHudService = serviceHolder.get()
        callbackUsers()
    }
    
    func loadInfo() {
//        users = userService.filteredUsers
//        onReload?()
        
    }
    func callbackUsers() {
        userService.filteredUsersCallback = { [weak self] users in
            guard let self = self else { return }
            self.users = users
            self.onReload?()
        }
    }
    
    func getNumberOfSections() -> Int {
        if users.isEmpty {
            return 0
        } else {
            return 1
        }
    }
    
    func getNumberOfRowsInSection() -> Int {
        if users.isEmpty {
            return 0
        } else {
            return users.count
        }
    }
    
    func getCellForRowAt(indexPath: IndexPath) -> User {
        
        if users.isEmpty {
            return .init(userInfo: UserInfo(email: "", firstName: "", lastName: "", uid: ""), isOnline: false)
        } else {
            let userdataModel = users[indexPath.item]
            return userdataModel
        }
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        
        guard let currentUser = userService.currentUser else { return }
        let companion = users[indexPath.row]
        
        if !chatService.didChatExists(currentUser: currentUser, companion: companion, completion: { [weak self] chat in
            guard let self = self else { return }
            // Request for chat
            self.coordinator.openChatWithConversationPagination(with: companion, conversationID: chat)
//            chatService.fetchChat(conversationID: chat) { conversation in
//
//                self.coordinator.openChatWithConversations(with: companion, conversation: conversation)
//            }
            print("Common chat id - \(chat)")
        }) { coordinator.openChat(with: users[indexPath.item]) }
    }
}
