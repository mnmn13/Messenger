//
//  OpenAIChatViewModel.swift
//  Messenger
//
//  Created by MN on 02.04.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit
import MessageKit

protocol OpenAIChatViewModelType {
    var onReload: EmptyClosure? { get set }
    
    func getSelfSender() -> SenderKitModel
    
    func numberOfSections() -> Int
    func messageForItem(indexPath: IndexPath) -> MessageType
    
    func didPressSendButton(text: String)
    
}

class OpenAIChatViewModel: OpenAIChatViewModelType {
    var onReload: EmptyClosure?
    fileprivate let coordinator: OpenAIChatCoordinatorType
    private var userService: UserService
    private var chatService: ChatService
    private var openAIService: OpenAIService
    private let currentUser: UserInfo = UserDefaults.standard.getUserData()
    private var messages: [MessageKitModel] = []
    
    init(coordinator: OpenAIChatCoordinatorType, serviceHolder: ServiceHolder) {
        self.coordinator = coordinator
        self.userService = serviceHolder.get()
        self.chatService = serviceHolder.get()
        self.openAIService = serviceHolder.get()
        bindForData()
    }
    
    func bindForData() {
        openAIService.openAiResponseCallback = { [weak self] text in
            guard let self = self else { return }
            let trimmedString = text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).filter{!$0.isEmpty}.joined(separator: "\n")
            let newMessage = MessageKitModel(sender: self.getBotSender(), kind: .text(trimmedString))
            self.messages.append(newMessage)
            self.onReload?()
        }
    }
    
    func getSelfSender() -> SenderKitModel {
         SenderKitModel(senderId: self.currentUser.uid, displayName: "\(self.currentUser.firstName) \(self.currentUser.lastName)")
    }
    
    func getBotSender() -> SenderKitModel {
        SenderKitModel(senderId: "123456789", displayName: "GPT3")
    }
    
    
    func didPressSendButton(text: String) {
        guard !text.isEmpty else { return }
        openAIService.getResponse(text: text)
        let newMessage = MessageKitModel(sender: getSelfSender(), kind: .text(text))
        messages.append(newMessage)
        onReload?()
    }
    
    func messageForItem(indexPath: IndexPath) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections() -> Int {
        return messages.count
    }
}
