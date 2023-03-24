//
//  RequestMessageModel.swift
//  Messenger
//
//  Created by MN on 17.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation

struct RequestMessageModel: Codable, Hashable {
    
    var senderID: String
    var isRead: Bool
    var messageID: String
    var time: String
    var text: String
//    var dateString: String
//    var date: Date { Time.stringToDate(string: dateString) }
   
    
    
    
    
    enum CodingKeys: String, CodingKey {
        
        case messageID = "message_id"
        case isRead = "is_read"
        case senderID = "sender_id"
        case text = "text"
//        case dateString = "date_string"
        case time = "time"
        
        
        
        
    }
    
    
}

//struct RequestMessagesModel: Codable, Hashable {
//    
//    var messages: [RequestMessageModel]
//    
//    enum CodingKeys: String, CodingKey {
//        case messages = "messages"
//    }
//    
//}
