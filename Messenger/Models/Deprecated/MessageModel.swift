//
//  Message.swift
//  Messenger
//
//  Created by MN on 24.01.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation
import MessageKit

struct MessageKitModel: MessageType {

    
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
}

