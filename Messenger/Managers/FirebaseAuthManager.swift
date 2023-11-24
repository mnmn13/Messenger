//
//  FirebaseAuthManager.swift
//  Messenger
//
//  Created by MN on 25.01.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

final class FirebaseAuthManager {
    
    static let shared = FirebaseAuthManager()
    
    private init() {}
    
    private let auth = Auth.auth()
    
    func signIn(email: String, password: String, completion: @escaping FirebaseRequestUserClosure<FirebaseAuth.User>) {
        
        auth.signIn(withEmail: email, password: password) { authResult, error in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            guard let result = authResult else { return }
            completion(result.user)
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping FirebaseRequestUserClosure<FirebaseAuth.User>) {
        
        auth.createUser(withEmail: email, password: password) { authResult, error in
            
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            guard let result = authResult else { return }
            completion(result.user)
        }
    }
    
    func logout(completion: SimpleClosure<Bool>) {
        do {
            try auth.signOut()
            completion(true)
        } catch {
            print("Error logout/ user is already logged out")
            completion(false)
        }
    }
}
