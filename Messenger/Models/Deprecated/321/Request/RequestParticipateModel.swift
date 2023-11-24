//
//  RequestParticipateModel.swift
//  Messenger
//
//  Created by MN on 17.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation

struct RequestParticipateModel: Codable, Hashable {
    
    var user1: RequestUserModel
    var user2: RequestUserModel
    
//    enum CodingKeys: Int, CodingKey {
//        case user1 = 0
//        case user2 = 1
//        
//    }
    
    
}
