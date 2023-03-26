//
//  ConversationsViewModel.swift
//  Messenger
//
//  Created by MN on 06.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation

protocol ConversationsViewModelType {
    var onReload: EmptyClosure? { get set }
    
//    func loadInfo()
    
    func numberOfRowsInSection() -> Int
    func cellForRowAt(with indexPath: IndexPath) -> (Conversation, User)
    func verifyData(chat: Conversation) -> String
    
    func didSelectRowAt(indexPath: IndexPath)
    
    func refreshData()
    func logOut()
    
}

class ConversationsViewModel: ConversationsViewModelType {
    var onReload: EmptyClosure?
    
    fileprivate let coordinator: ConversationsCoordinatorType
    private let userService: UserService
    private let chatService: ChatService
    private var conversations: [Conversation] = []
    private var users: [User] = []
    private var currentUser: UserInfo?
    
    init(coordinator: ConversationsCoordinatorType, serviceholder: ServiceHolder) {
        FirebaseRealtimeDatabaseManager.shared.fetchMessages(conversationID: "2B641AF2-A998-42BC-9B28-E0E460127E33", limit: 20) { messages in
            
        }
        self.coordinator = coordinator
        self.userService = serviceholder.get()
        self.chatService = serviceholder.get()
        bindForDatabaseCallback()
//        bindForUserConversationsData()
//        bindForUsers()
        chatService.startFetchingAllDatabase()
        userService.startFethingUsers()
        
//        chatService.startFetchingAllConversations()
    }

    
    func bindForUserConversationsData() {
//        chatService.callBackConversations = { [weak self] conversations in
//            guard let self = self else { return }
//            self.conversations = conversations.filter { $0.id == self.filterConversations(conversation: $0) }
//            self.onReload?()
//        }

    }
    
    func bindForUsers() {
//        userService.filteredUsersCallback = { [weak self] users in
//            guard let self = self else { return }
//            self.users = users
//            self.onReload?()
//        }
    }
    
    func bindForDatabaseCallback() {
        chatService.callBackDatabase = { [weak self] conversations, users in
            guard let self = self else { return }
            self.conversations = conversations.filter { $0.id == self.filterConversations(conversation: $0) }
//            self.conversations = conversations.sorted(by: { Time.stringToDate(string: $0.lastMessage.time) > Time.stringToDate(string: $1.lastMessage.time) })
            self.users = users.filter { $0.userInfo.email != UserDefaults.standard.getUserData().email }
            self.onReload?()
        }
    }
    
    func refreshData() {
        chatService.stopFetchingAllChats()
        chatService.startFetchingAllConversations()
    }
    
    func filterConversations(conversation: Conversation) -> String {
        guard let currentUser = userService.currentUser else { return "" }//.init(lastActivity: "", lastMessage: Message(senderID: "", text: "", time: ""), messages: ["String" : Message(senderID: "", text: "", time: "")], participates: [Participates(email: "", name: "")])}
            guard let userConversation = currentUser.conversations else { return "" }//.init(lastActivity: "", lastMessage: Message(senderID: "", text: "", time: ""), messages: ["String" : Message(senderID: "", text: "", time: "")], participates: [Participates(email: "", name: "")]) }
        let conv = userConversation.filter { $0 == conversation.id }
        guard let conv = conv.first else { return "" }
        return conv
    }
    
    func logOut() {
        userService.logout { bool in
            if bool {
                userService.stopFetchingMessages()
                chatService.stopFetchingAllChats()
                coordinator.logOut()
            }
        }
    }
    
    func numberOfRowsInSection() -> Int {
        conversations.count
    }
    
    func cellForRowAt(with indexPath: IndexPath) -> (Conversation, User) {
        
        if conversations.isEmpty {
             return (Conversation(lastActivity: 1, lastMessage: Message(senderID: "", text: "", time: 1), messages: ["String" : Message(senderID: "", text: "", time: 1)], participates: [Participates(email: "", name: "")]), User(conversations: nil, userInfo: UserInfo(email: "", firstName: "", lastName: "", uid: ""), isOnline: false))
        } else {
            let companionFromConversation = conversations[indexPath.row].participates.filter { $0.email != UserDefaults.standard.getUserData().email }
            
            guard let comp = companionFromConversation.first else { return (Conversation(lastActivity: 1, lastMessage: Message(senderID: "", text: "", time: 1), messages: ["String" : Message(senderID: "", text: "", time: 1)], participates: [Participates(email: "", name: "")]), User(conversations: nil, userInfo: UserInfo(email: "", firstName: "", lastName: "", uid: ""), isOnline: false))}
            
            let companion = users.filter { $0.userInfo.email == comp.email }
            
            guard let companion = companion.first else { return (Conversation(lastActivity: 1, lastMessage: Message(senderID: "", text: "", time: 1), messages: ["String" : Message(senderID: "", text: "", time: 1)], participates: [Participates(email: "", name: "")]), User(conversations: nil, userInfo: UserInfo(email: "", firstName: "", lastName: "", uid: ""), isOnline: false))}
            
            return (conversations[indexPath.row], companion)
        }
        
    }
    
    func verifyData(chat: Conversation) -> String {
        let currentUser = UserDefaults.standard.getUserData()
        let currentUserName = "\(currentUser.firstName) \(currentUser.lastName)"

        if chat.participates.first?.name != currentUserName {
            return chat.participates.first?.name ?? ""
        } else {
            return chat.participates.last?.name ?? ""
        }
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        
        guard conversations.indices.contains(indexPath.item) else { return }
        let companion = conversations[indexPath.item].participates.filter { $0.email != UserDefaults.standard.getUserData().email }
        guard let companion = companion.first else { return }
        let comp = users.filter { $0.userInfo.email == companion.email }
        guard let comp = comp.first else { return }
        coordinator.openChatWithConversationIDPagination(with: comp, conversationID: conversations[indexPath.item].id)
    }
}
