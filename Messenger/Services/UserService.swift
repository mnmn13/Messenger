//
//  UserService.swift
//  Messenger
//
//  Created by MN on 05.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation
//import FirebaseAuth

protocol UserServiceType: Service {}

class UserService: Service {
    
//    var allUsers: [User] = []
    var allUsers: [User] = []
    var filteredUsers: [User] = []
    var currentUser: User? {
        didSet {
            guard let currentUser = currentUser else { return }
            UserDefaults.standard.saveUserData(user: currentUser)
        }
    }
    var filteredUsersCallback: SimpleClosure<[User]>?
    
    var usr: UsersModel?
    var userIsFetching: Bool = false
    
    func signIn(email: String, password: String, completion: @escaping EmptyClosure) {
        FirebaseAuthManager.shared.signIn(email: email, password: password) { [weak self] user in
            guard let self = self else { return }
            FirebaseRealtimeDatabaseManager.shared.fetchUserFromDatabase(uid: user.uid) { user in
                self.currentUser = user
                UserDefaults.standard.saveUserData(user: user)
                FirebaseRealtimeDatabaseManager.shared.goOnline()
                completion()
            }
        }
    }
    
    func signUp(email: String, password: String, firstName: String, lastName: String, completion: @escaping EmptyClosure) {
        
        FirebaseAuthManager.shared.signUp(email: email, password: password) { [weak self] user in
//            guard let self = self else { return }
            let userInfo = UserInfo(email: email, firstName: firstName, lastName: lastName, uid: user.uid)
            let userToDatabase = User(conversations: nil, userInfo: userInfo, isOnline: true)
//            let userToDatabase = User(conversations: nil, userInfo: userInfo, lastActionTime: Time.dateToString(date: Date()))
            FirebaseRealtimeDatabaseManager.shared.createUserInDatabase(user: userToDatabase) {
                completion()
            }
            UserDefaults.standard.saveUserData(user: userToDatabase)
            FirebaseRealtimeDatabaseManager.shared.goOnline()
        }
    }
    
    func startFethingUsers() {
        let curUser = UserDefaults.standard.getUserData()
        print("Fetching users data started")
        FirebaseRealtimeDatabaseManager.shared.startFetchUsersFromDatabase { [weak self] users in
            guard let self = self else { return }
            self.allUsers = users
            self.filteredUsers = users.filter { $0.userInfo.uid != curUser.uid }
            let curUs = users.filter { $0.userInfo.uid == curUser.uid }
            guard let curUs = curUs.first else { return }
            self.currentUser = curUs
            self.filteredUsersCallback?(self.filteredUsers)
            self.userIsFetching = true
        }
    }
    
    func stopFetchingMessages() {
        FirebaseRealtimeDatabaseManager.shared.stopFetchingUsersFromDatabase()
    }

    ///Logout
    func logout(completion: SimpleClosure<Bool>) {
        
        FirebaseAuthManager.shared.logout { bool in
            if bool {
                UserDefaults.standard.isLoggedIn = false
                UserDefaults.standard.deleteUserData()
                FirebaseRealtimeDatabaseManager.shared.goOffline()
                completion(true)
            } else {
            // logout error alert
                completion(false)
            }
        }
        
    }
}
