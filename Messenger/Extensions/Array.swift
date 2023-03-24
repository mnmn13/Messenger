//
//  Array.swift
//  Messenger
//
//  Created by MN on 20.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation

extension Array {

    func mapToSet<T: Hashable>(_ transform: (Element) -> T) -> Set<T> {
        var result = Set<T>()
        for item in self {
            result.insert(transform(item))
        }
        return result
    }

}
