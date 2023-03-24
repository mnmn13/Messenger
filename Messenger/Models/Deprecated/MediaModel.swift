//
//  MediaModel.swift
//  Messenger
//
//  Created by MN on 14.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import MessageKit

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}
