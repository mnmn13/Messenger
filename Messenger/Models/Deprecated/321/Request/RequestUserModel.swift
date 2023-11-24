//
//  RequestUserModel.swift
//  Messenger
//
//  Created by MN on 17.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation

struct RequestUserModel: Codable, Hashable {
    
    var email: String
    var name: String
    
    
//    enum CodingKeys: String, CodingKey {
//        case email = "email"
//        case name = "name"
//    }
    
    
}
