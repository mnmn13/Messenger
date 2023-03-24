//
//  UserDatabaseModel.swift
//  Messenger
//
//  Created by MN on 18.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation

struct UserDatabaseModel: Codable, Hashable {
    
    var conversations: [String]?
    
    var userInfo: UserDatabaseUserInfoModel
    
    enum CodingKeys: String, CodingKey {
        
        case conversations = "conversations"
    
        case userInfo = "user_info"
    
        }
    
}

struct UserDatabaseConversationsModel: Codable, Hashable {
    
    var conversation: String
}

struct UserDatabaseUserInfoModel: Codable, Hashable {
    
    var email: String
    var firstName: String
    var lastName: String
    var uid: String
    
    enum CodingKeys: String, CodingKey {
    
        case email = "email"
        case firstName = "first_name"
        case lastName = "last_name"
        case uid = "uid"
        }
}
