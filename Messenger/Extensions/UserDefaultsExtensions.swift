//
//  UserDefaultsExtensions.swift
//  Messenger
//
//  Created by MN on 05.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation

extension UserDefaults {
    var isLoggedIn: Bool {
        get {
            bool(forKey: Key.isLoggedIn)
        } set {
            setValue(newValue, forKey: Key.isLoggedIn)
        }
    }
}

extension UserDefaults {
    func getUserData() -> UserInfo {
        
        guard let fName = UserDefaults.standard.string(forKey: Key.firstName), let lName = UserDefaults.standard.string(forKey: Key.lastName), let uid = UserDefaults.standard.string(forKey: Key.uid), let email = UserDefaults.standard.string(forKey: Key.email) else { return UserInfo(email: "", firstName: "", lastName: "", uid: "") }
        return .init(email: email, firstName: fName, lastName: lName, uid: uid)
    }
    
    func saveUserData(firstName: String, lastName: String, email: String, uid: String) {
        UserDefaults.standard.set(firstName, forKey: Key.firstName)
        UserDefaults.standard.set(lastName, forKey: Key.lastName)
        UserDefaults.standard.set(email, forKey: Key.email)
        UserDefaults.standard.set(uid, forKey: Key.uid)
        print("UserDefaults - user saved ")
    }
    
    func saveUserData(user: User) {
        UserDefaults.standard.set(user.userInfo.firstName, forKey: Key.firstName)
        UserDefaults.standard.set(user.userInfo.lastName, forKey: Key.lastName)
        UserDefaults.standard.set(user.userInfo.email, forKey: Key.email)
        UserDefaults.standard.set(user.userInfo.uid, forKey: Key.uid)
        UserDefaults.standard.isLoggedIn = true
        print("UserDefaults - user saved ")
    }
    
    func deleteUserData() {
        UserDefaults.standard.removeObject(forKey: Key.firstName)
        UserDefaults.standard.removeObject(forKey: Key.lastName)
        UserDefaults.standard.removeObject(forKey: Key.email)
        UserDefaults.standard.removeObject(forKey: Key.uid)
        UserDefaults.standard.isLoggedIn = false
        print("UserDefaults - user zeroed")
    }
}
