//
//  ConversationModel.swift
//  Messenger
//
//  Created by MN on 20.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation

struct Conversations: HashCoded {
    var conversations: [String: Conversation]
}

struct Conversation: HashCoded {
    var id: String = UUID().uuidString
    var lastActivity: String
//    var lastActivity: Double = Date().timeIntervalSince1970
    var lastMessage: Message
    var messages: [String: Message]
    var participates: [Participates]
}

struct Message: HashCoded {
    var messageID: String = UUID().uuidString
    var isRead: Bool = false
    var senderID: String
    var text: String
    var time: String
//    var time: Double = Date().timeIntervalSince1970
}

struct Participates: HashCoded {
    var email: String
    var name: String
}
