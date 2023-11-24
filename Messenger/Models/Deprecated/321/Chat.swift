//
//  Struct30001000.swift
//  Messenger
//
//  Created by MN on 19.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation

//struct Conversation: Codable, Hashable {
//    var chats: [String: Chat]
//}

struct Chat: Codable, Hashable {
    var id: String
    var lastActivity: String
    var messages: [String: ChatMessage]
    var participates: [ChatUserModel]
}
 
struct ChatMessage: Codable, Hashable {
    
    var senderID: String
    var isRead: Bool
    var messageID: String
    var time: String
    var text: String
    
}

struct ChatUserModel: Codable, Hashable {
    
    var email: String
    var name: String
    
}

