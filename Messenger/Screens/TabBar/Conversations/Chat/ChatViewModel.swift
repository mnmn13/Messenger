//
//  ChatViewModel.swift
//  Messenger
//
//  Created by MN on 06.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation
import MessageKit

protocol ChatViewModelType {
    var onReload: EmptyClosure? { get set }
    var onReload2: EmptyClosure? { get set }
    var onReload3: EmptyClosure? { get set }
    
    //CollectionView
    func currentSender() -> SenderType
    func messageForItem(indexPath: IndexPath) -> MessageType
    func numberOfSections() -> Int
    
    func increaseLimit()
    
    //InputBar
    func didPressSendButton(with text: String)
    
    func getTitle() -> String
    
    func configureAvatarView(indexPath: IndexPath) -> String
}

class ChatViewModel: ChatViewModelType {
    var onReload: EmptyClosure?
    var onReload2: EmptyClosure?
    var onReload3: EmptyClosure?
    
    fileprivate let coordinator: ChatCoordinatorType
    private var userService: UserService
    private var chatService: ChatService
    private let companion: User
    private let currentUser: User?
    private var readyToUseMessages: [MessageKitModel] = []
    private var conversation: Conversation?
    private var didChatExists: Bool = false
    private var firstReload: Bool = true
    private var firstReload2: Bool = true
    private var conversationID: String = ""
    private var messages: [Message] = []
    private var messagesLimit: UInt = 20
    private var lastMessage: [Message] = []
    
    init(coordinator: ChatCoordinatorType, serviceHolder: ServiceHolder, companion: User) {
        
        self.coordinator = coordinator
        self.userService = serviceHolder.get()
        self.chatService = serviceHolder.get()
        self.companion = companion
        self.currentUser = userService.currentUser
    }
    
    deinit {
        print("\(type(of: self)) \(#function)")

        chatService.stopFetchingNewMessages(conversationID: conversationID)
        chatService.stopFetchingNewMessageslimit(conversationID: conversationID)
    }
    
    func getSenderName(message: Message) -> String {
        guard let currentUser = currentUser else { return ""}
        
        if message.senderID == currentUser.userInfo.uid {
            return "\(currentUser.userInfo.firstName) \(currentUser.userInfo.lastName)"
        } else {
            return "\(companion.userInfo.firstName) \(companion.userInfo.lastName)"
        }
    }
    
    func getSenderInitials(message: MessageKitModel) -> String {
        guard let currentUser = currentUser else { return ""}
        
        if message.sender.senderId == currentUser.userInfo.uid {
            guard let first = currentUser.userInfo.firstName.first else { return "" }
            guard let second = currentUser.userInfo.lastName.first else { return "" }
            return "\(first)\(second)"
        } else {
            guard let first = companion.userInfo.firstName.first else { return "" }
            guard let second = companion.userInfo.lastName.first else { return "" }
            return "\(first)\(second)"
        }
    }
    
    func configureAvatarView(indexPath: IndexPath) -> String {
        let message = getSenderInitials(message: readyToUseMessages[indexPath.section])
        return message
    }
    
    func getTitle() -> String { "\(companion.userInfo.firstName) \(companion.userInfo.lastName)" }
    
    func readMessages() {
        let messageToSave = messages
//        let messageToSave = conversation.messages.map { $0.value }
        let messagesToRead = messageToSave.filter { $0.isRead != true }
        let filteredMessages = messagesToRead.filter { $0.senderID != UserDefaults.standard.getUserData().uid }
        let messagesToReadFinal = filteredMessages.map { $0.messageID }
        chatService.readMessages(conversationID: conversationID, messagesID: messagesToReadFinal)
    }
    
    func getSelfSender() -> SenderKitModel {
        
        guard let currentUser = currentUser else { return .init(senderId: "", displayName: "")}
        
        return .init(senderId: currentUser.userInfo.uid, displayName: "\(currentUser.userInfo.uid) \(currentUser.userInfo.uid)")
    }
    
    //Message collectionView setup
    
    func currentSender() -> SenderType {
        return getSelfSender()
    }
    
    func messageForItem(indexPath: IndexPath) -> MessageType {
        return readyToUseMessages[indexPath.section]
    }
    
    func numberOfSections() -> Int {
        return readyToUseMessages.count
    }
    
    //Input bar actions
    
    func didPressSendButton(with text: String) {
        
        guard let currentUser = currentUser else { return }
        
        if !didChatExists {
            let userIsFetching = userService.userIsFetching
            chatService.createConversation(usersIsFetching: userIsFetching, currentUser: currentUser, companion: companion, text: text) { [weak self] conversationID in
                self?.conversationID = conversationID
                self?.loadFirstMessage(with: 1, conversationID: conversationID, completion: { self?.startFetchingNewMessage() })
            }
        } else {
            chatService.sendMessage(conversationID: conversationID, text: text, sender: currentUser.userInfo.uid) {}
        }
    }
    
    func startFetchingNewMessage() {
        chatService.startFetchingNewMessage(conversationID: conversationID) { [weak self] message in
            guard let self = self else { return }
            
            if self.firstReload2 {
                self.firstReload2 = false
                guard let message = message.first else { return }
                self.lastMessage = [message]
            } else {
                
                guard let messageToCheck = message.first else { return }
                
                if self.lastMessage.first?.messageID == messageToCheck.messageID {
                    return
                } else {
                    self.lastMessage = [messageToCheck]
                    self.messages.append(messageToCheck)
                    let messag = message.map { MessageKitModel(sender: SenderKitModel(senderId: $0.senderID, displayName: self.getSenderName(message: $0)), messageId: $0.messageID, sentDate: Time.timeIntervalToDate(time: $0.time), kind: .text($0.text)) }
                    guard let messag = messag.first else { return }
                    self.readyToUseMessages.append(messag)
//                    self.reload()
                    self.onReload?()
//                    self.onReload2?()
                    self.readMessages()
                }
            }
        }
    }
    
    func loadExistingConversation(conversationID: String) {
        self.conversationID = conversationID
        loadMessages(conversationID: conversationID) {
            self.startFetchingNewMessage()
        }
        didChatExists = true
    }
    
    func loadMessages(conversationID: String, completion: @escaping EmptyClosure) {
        chatService.fetchExistingMessages(conversationID: conversationID, limit: messagesLimit) { [weak self] messages in
            guard let self = self else { return }
            let oldMessages = Set(self.messages)
            let newMessages = Set(messages)
            let new = oldMessages.symmetricDifference(newMessages)
            self.messages.append(contentsOf: new)
            let ready = new.map { MessageKitModel(sender: SenderKitModel(senderId: $0.senderID, displayName: self.getSenderName(message: $0)), messageId: $0.messageID, sentDate: Time.timeIntervalToDate(time: $0.time), kind: .text($0.text)) }
            let readyReady = ready.sorted(by: { $0.sentDate < $1.sentDate })
            self.readyToUseMessages.insert(contentsOf: readyReady, at: 0)
            if self.firstReload {
                self.onReload?()
                self.firstReload = false
                completion()
            } else {
                self.onReload2?()
            }
            self.readMessages()
        }
    }
    /// Increase limit to +20 messages + load to chat
    func increaseLimit() {
        messagesLimit += 20
        loadMessages(conversationID: conversationID) {}
    }
    
    func reload() {
        if readyToUseMessages.count > 20 {
            onReload2?()
        } else {
            onReload3?()
        }
    }
    
    func loadFirstMessage(with limit: UInt, conversationID: String, completion: @escaping EmptyClosure) {
        chatService.fetchExistingMessages(conversationID: conversationID, limit: limit) { [weak self] message in
            guard let self = self else { return }
            if self.lastMessage.isEmpty {
                guard let messageToCheck = message.first else { return }
                self.lastMessage = [messageToCheck]
                self.messages.append(messageToCheck)
                let messag = message.map { MessageKitModel(sender: SenderKitModel(senderId: $0.senderID, displayName: self.getSenderName(message: $0)), messageId: $0.messageID, sentDate: Time.timeIntervalToDate(time: $0.time), kind: .text($0.text)) }
                guard let messag = messag.first else { return }
                self.readyToUseMessages.append(messag)
//                    self.reload()
                self.onReload?()
//                    self.onReload2?()
                self.readMessages()
                self.didChatExists = true
                self.firstReload2 = false
                completion()
            }
        }
    }
    
}
