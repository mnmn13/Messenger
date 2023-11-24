//
//  UsersModel.swift
//  Messenger
//
//  Created by MN on 19.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation

struct UsersModel: Codable {
    
    var conversations: [String]?
    var user_info: UserInfoModel
    
    
    
}

struct UserInfoModel: Codable {
    
    var email: String
    var first_name: String
    var last_name: String
    var uid: String
    
}
