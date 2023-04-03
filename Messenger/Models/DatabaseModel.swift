//
//  DatabaseModel.swift
//  Messenger
//
//  Created by MN on 22.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation

struct Database: HashCoded {
    var conversations: [String: Conversation]
    var users: [String: User]
}
