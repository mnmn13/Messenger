//
//  Sender.swift
//  Messenger
//
//  Created by MN on 24.01.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation
import MessageKit

struct SenderKitModel: SenderType, Codable, Hashable {
    var senderId: String
    var displayName: String
}
