//
//  UserModel.swift
//  Messenger
//
//  Created by MN on 20.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation

struct User: HashCoded {
    var conversations: [String]?
    var userInfo: UserInfo
    var isOnline: Bool
}

struct UserInfo: HashCoded {
    var email: String
    var firstName: String
    var lastName: String
    var uid: String
}
