//
//  Enums.swift
//  Messenger
//
//  Created by MN on 24.01.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation


public enum StorageError: Error {
    case failedToUpload
    case failedToDownloadUrl
    
}

public enum DatabaseError: Error {
    case failedToUpload
    case failedToFetch
}

