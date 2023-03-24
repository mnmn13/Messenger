//
//  Encodable.swift
//  Messenger
//
//  Created by MN on 20.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
