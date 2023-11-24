//
//  RequestConversationModel.swift
//  Messenger
//
//  Created by MN on 17.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation

struct RequestConversationModel: Codable, Hashable {
    
    var messages: RequestMessages
    var participates: [RequestUserModel]
    
//    enum CodingKeys: String, CodingKey {
//        case messages = "messages"
//        case participates = "participates"
//        
//    }
}

struct RequestMessages: Codable, Hashable {
    
    var key: RequestMessageModel
    
//    enum CodingKeys: String, CodingKey {
//        case key = "BCE99DDE-2BBF-4014-AC7C-DD8F64320E77"
//    }
    
}
