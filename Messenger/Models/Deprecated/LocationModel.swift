//
//  LocationModel.swift
//  Messenger
//
//  Created by MN on 14.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import MessageKit
import CoreLocation

struct Location: LocationItem {
    var location: CLLocation
    var size: CGSize
}
