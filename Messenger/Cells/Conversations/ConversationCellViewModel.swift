//
//  ConversationCellViewModel.swift
//  Messenger
//
//  Created by MN on 21.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation

struct ConversationCellViewModel {
    
    var conversationModel: Conversation
    var currentUser: UserInfo
    var companion: User
    
    init(conversationModel: Conversation, companion: User) {
        self.conversationModel = conversationModel
        self.currentUser = UserDefaults.standard.getUserData()
        self.companion = companion
    }
    
    func getNumberOfMessages() -> Int {
        let bool = conversationModel.messages.map { $0.value.isRead }
        let ifBool = bool.filter { $0 == false }
        return ifBool.count
    }
    
    var name: String {
        let filteredName = conversationModel.participates.filter { $0.email == companion.userInfo.email }
        let name = filteredName.map { $0.name }.first ?? ""
        
        if companion.isOnline {
            return "\(name) 🟢"
        } else {
            return name
        }
    }
    
    var message : String {
        return conversationModel.lastMessage.text
    }
    
    var unreadedMessages: Int {
        
        let conversationMessages = conversationModel.messages.map {$0.value}
        let messages = conversationMessages.filter { $0.senderID != UserDefaults.standard.getUserData().uid }
        let mes = messages.filter { $0.isRead == false }
        
        return mes.count
    }
    
    var lastActionTime: String {
        let date = Time.stringToDate(string: conversationModel.lastMessage.time)
        let stringDate = Time.dateToStringLastActivity(date: date)
        return stringDate
    }
    
    
}
