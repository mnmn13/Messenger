//
//  Keys.swift
//  Messenger
//
//  Created by MN on 20.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation

enum Key {
    static let conversations = "conversations"
    static let users = "users"
    static let messages = "messages"
    /// users last activity (checks when was the last time user was online)
    static let isOnline = "isOnline"
    static let isRead = "isRead"
    static let messageID = "messageID"
    static let senderID = "senderID"
    static let text = "text"
    static let time = "time"
    static let name = "name"
    static let participates = "participates"
    static let userInfo = "userInfo"
    static let email = "email"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let uid = "uid"
    static let lastMessage = "lastMessage"
    
    static let lastActivity = "lastActivity" // chats
    
    //UserDefaults
    static let isLoggedIn = "isLoggedIn"
    static let startUpdatingUserStatus = "startUpdatingUserStatus"
}
