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
    
    //CollectionView
    func currentSender() -> SenderType
    func messageForItem(indexPath: IndexPath) -> MessageType
    func numberOfSections() -> Int
    
    //InputBar
    func didPressSendButton(with text: String)
    
    func getTitle() -> String
    
    func configureAvatarView(indexPath: IndexPath) -> String
    
    
    
}

class ChatViewModel: ChatViewModelType {
    var onReload: EmptyClosure?
    
    
    fileprivate let coordinator: ChatCoordinatorType
    private var userService: UserService
    private var chatService: ChatService
    private let companion: User
    private let currentUser: User?
    private var readyToUseMessages: [MessageKitModel] = []
    private var conversation: Conversation?
    private var didChatExists: Bool = false
    private var conversationID: String = ""
    private var messages: [Message] = []
    
    init(coordinator: ChatCoordinatorType, serviceHolder: ServiceHolder, companion: User) {
        
        self.coordinator = coordinator
        self.userService = serviceHolder.get()
        self.chatService = serviceHolder.get()
        self.companion = companion
        self.currentUser = userService.currentUser
    }
    
    deinit {
        print("\(type(of: self)) \(#function)")
        guard let conversation = conversation else { return }
        chatService.stopFetchingNewMessages(conversationID: conversation.id)
        
    }
    
    func loadInfo(conversationID: String?) {
        guard let conversationID = conversationID else { return }
        chatService.fetchChat(conversationID: conversationID) { [weak self] conversation in
            guard let self = self else { return }
            self.conversation = conversation
            self.validateMessagesages(conversation: conversation)
        }
    }
    
    func validateMessagesages(conversation: Conversation) {
        conversationID = conversation.id
        let rawMessages = conversation.messages.map { $0.value }

        let ready = rawMessages.map { MessageKitModel(sender: SenderKitModel(senderId: $0.senderID, displayName: getSenderName(message: $0)), messageId: $0.messageID, sentDate: Time.stringToDate(string: $0.time), kind: .text($0.text)) }
        let goMessage = ready.sorted(by: { $0.sentDate < $1.sentDate } )
        self.readyToUseMessages = goMessage

        self.onReload?()
        self.conversation = conversation
        
        self.didChatExists = true
        
        let messageToSave = conversation.messages.map { $0.value }
        messages = messageToSave
        validateNewMessage()
        readMessages(conversation: conversation)
        
    }
    
    
    func validateNewMessage(){//rawMessage: Set<Message>) {
        chatService.startFetchingNewMessages(conversationID: conversationID) { [weak self] rawMessage in
            guard let self = self else { return }
            
            let setOld = Set(self.messages)
            let setNew = rawMessage
            let new = setNew.symmetricDifference(setOld)
            self.messages.append(contentsOf: new)
            let ready = new.map { MessageKitModel(sender: SenderKitModel(senderId: $0.senderID, displayName: self.getSenderName(message: $0)), messageId: $0.messageID, sentDate: Time.stringToDate(string: $0.time), kind: .text($0.text)) }
            guard let ready = ready.first else { return }
            self.readyToUseMessages.append(ready)
            self.onReload?()
        }
    }
    
    
    func getSenderName(message: Message) -> String {
        guard let currentUser = currentUser else { return ""}
        
        if message.senderID == currentUser.userInfo.uid {
            return "\(currentUser.userInfo.firstName) \(currentUser.userInfo.lastName)"
        } else {
            return "\(companion.userInfo.firstName) \(companion.userInfo.lastName)"
        }
    }
    
    func getSenderInitials(message: Message) -> String {
        guard let currentUser = currentUser else { return ""}
        
        if message.senderID == currentUser.userInfo.uid {
            print("\"\(String(describing: currentUser.userInfo.firstName.first))\"")
            return "\"\(String(describing: currentUser.userInfo.firstName.first))\""
        } else {
            return "\"\(String(describing: currentUser.userInfo.firstName.first))\""
        }
    }
    
    func configureAvatarView(indexPath: IndexPath) -> String {
        
        let firstName = getSenderInitials(message: messages[indexPath.section])
        return firstName
    }
    
    func getTitle() -> String { "\(companion.userInfo.firstName) \(companion.userInfo.lastName)" }
    
    func readMessages(conversation: Conversation) {
        let messageToSave = conversation.messages.map { $0.value }
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
                self?.userService.startFethingUsers()
                self?.chatService.fetchChat(conversationID: conversationID, completion: { conversation in
                    self?.validateMessagesages(conversation: conversation)
                })
            }
        } else {
            guard let conversation = conversation else { return }
            let time = Time.dateToString(date: Date())
            chatService.sendMessage(conversationID: conversation.id, text: text, sender: currentUser.userInfo.uid, time: time) {}
        }
    }
}