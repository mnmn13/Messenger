//
//  FirebaseStorageManager.swift
//  Messenger
//
//  Created by MN on 24.01.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation
import FirebaseStorage

final class FirebaseStorageManager {
    
    static let shared = FirebaseStorageManager()
    
    private init() {}
    
    private let storage = Storage.storage().reference()
    
     func uploadProfilePicture(with data: Data, and filename: String, compltion: @escaping UploadPictureCompletion) {
         storage.child("images/\(filename)").putData(data) { metadata, error in
             guard error == nil else {
                 compltion(.failure(StorageError.failedToUpload))
                 return
             }
             self.storage.child("images/\(filename)").downloadURL { url, error in
                 guard let url = url else {
                     print("Failed to get download Url")
                     compltion(.failure(StorageError.failedToDownloadUrl))
                     return
                 }
                 let urlString = url.absoluteString
                 print("Url return: \(urlString)")
                 compltion(.success(urlString))
             }
         }
    }
}


