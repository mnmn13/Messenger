//
//  MessageService.swift
//  Messenger
//
//  Created by MN on 16.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation

protocol ChatServiceType: Service {}

class ChatService: Service {
    
    private let userService: UserService = UserService()
    var callBackNewMessage: SimpleClosure<Set<Message>>?
    var callBackConversations: SimpleClosure<[Conversation]>?
    var callBackDatabase: DoubleSimpleClosure<[Conversation], [User]>?
    
    var transformCommonChats: SimpleClosure<Set<Chat>>?
    var commotChats = Set<Chat>()
    
    ///Creates conversation by Conversation model with first message
    func createConversation(usersIsFetching: Bool, currentUser: User, companion: User, text: String, completion: @escaping SimpleClosure<String>) {
        
//        let message = Message(senderID: currentUser.userInfo.uid, text: text, time: Time.dateToString(date: Date()))
        let message = Message(senderID: currentUser.userInfo.uid, text: text, time: Date().timeIntervalSince1970)
        
        FirebaseRealtimeDatabaseManager.shared.createConversation(usersIsFetching: usersIsFetching, currentUser: currentUser, companion: companion, message: message) { conversationID in
            completion(conversationID)
        }
    }
    /// Checking if the conversation is already exists
    func didChatExists(currentUser: User, companion: User, completion: SimpleClosure<String>) -> Bool {

        guard let currentUserConversations = currentUser.conversations, !currentUserConversations.isEmpty else { return false }
        
        guard let companionConversations = companion.conversations, !companionConversations.isEmpty else { return false }

        let commonConversation: Set<String> = currentUserConversations.mapToSet { $0 }.intersection(companionConversations.mapToSet { $0 })
        guard let commonConversation = commonConversation.first else { return false }
        completion(commonConversation)
        return true
    }
    /// Starts observing conversation for new messages by Conversation model
    func fetchChat(conversationID: String, completion: @escaping SimpleClosure<Conversation>) {
        
        FirebaseRealtimeDatabaseManager.shared.fetchChat(conversationID: conversationID) { conversation in
            completion(conversation)
        }
    }
    /// Sends message to firebase
    func sendMessage(conversationID: String, text: String, sender: String, completion: @escaping EmptyClosure) {
        
//        let message = Message(senderID: sender, text: text, time: Time.dateToString(date: Date()))
        let message = Message(senderID: sender, text: text, time: Date().timeIntervalSince1970)
        
        FirebaseRealtimeDatabaseManager.shared.sendMessage(conversationID: conversationID, message: message) {
//            completion()
        }
    }
    /// Start fetching new messages
    @available(*, deprecated, message: "No More Available")
    func startFetchingNewMessages(conversationID: String, completion: @escaping SimpleClosure<Set<Message>>) {
//        FirebaseRealtimeDatabaseManager.shared.startFetchingNewMessages(conversationID: conversationID) { messages in
////            self?.callBackNewMessage?(messages)
//            completion(messages)
//        }
    }
    ///  Stop fetching new messages
    func stopFetchingNewMessages(conversationID: String) {
        FirebaseRealtimeDatabaseManager.shared.stopFetchingNewMessages(conversationID: conversationID)
    }
    /// Fetch All chats with completion
    func startFetchingAllChats(completion: @escaping SimpleClosure<[Conversation]>) {
        FirebaseRealtimeDatabaseManager.shared.startFetchingAllChats { conversations in
            completion(conversations)
        }
    }
    /// Stop fetching all chats
    func stopFetchingAllChats() {
        FirebaseRealtimeDatabaseManager.shared.stopFetchingAllChats()
    }
    ///Start fetching all chats with callback
    func startFetchingAllConversations() {
        FirebaseRealtimeDatabaseManager.shared.startFetchingAllChats { [weak self] conversations in
            self?.callBackConversations?(conversations)
        }
    }
    /// Starts fetching conversations and users in database
    func startFetchingAllDatabase() {
        print("Fetching All database started")
        FirebaseRealtimeDatabaseManager.shared.startFetchingAllChats { [weak self] conversations in
            FirebaseRealtimeDatabaseManager.shared.startFetchUsersFromDatabase { users in
                self?.callBackDatabase?(conversations, users)
            }
        }
    }
    
    func readMessages(conversationID: String, messagesID: [String]) {
        for message in messagesID {
            FirebaseRealtimeDatabaseManager.shared.readMessage(conversationID: conversationID, messageID: message)
        }
    }
    /// Fetching existing messages with limit
    func fetchExistingMessages(conversationID: String, limit: UInt, completion: @escaping SimpleClosure<[Message]>) {
        FirebaseRealtimeDatabaseManager.shared.fetchMessages(conversationID: conversationID, limit: limit) { messages in
            completion(messages)
        }
    }
    /// Fetching new messages with limit - 1
    func startFetchingNewMessage(conversationID: String, completion: @escaping SimpleClosure<Set<Message>>) {
        FirebaseRealtimeDatabaseManager.shared.startFetchingNewMessage(conversationID: conversationID) { message in
            completion(message)
        }
    }
    /// Stop fetching new messages with limit - 1
    func stopFetchingNewMessageslimit(conversationID: String) {
        FirebaseRealtimeDatabaseManager.shared.stopFetchingNewMessagesLimit(conversationID: conversationID)
    }
    
    
}
