//
//  FirebaseRealtimeDatabaseManager.swift
//  Messenger
//
//  Created by MN on 22.01.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation
import FirebaseDatabase
import MessageKit


final class FirebaseRealtimeDatabaseManager {
    
    static let shared = FirebaseRealtimeDatabaseManager()
    
    private init() {}

    private let database = FirebaseDatabase.Database.database().reference()
}
//MARK: - Account Management

extension FirebaseRealtimeDatabaseManager {
    
    //MARK: - REFACTOR
    
    ///Creates user in database by User model
    func createUserInDatabase(user: User, completion: @escaping EmptyClosure) {
        
        let userDict = user.dictionary
        
        DispatchQueue.global().async { [weak self] in
            
            self?.database.child(Key.users).child(user.userInfo.uid).setValue(userDict, withCompletionBlock: { error, databaseRef in
                if let error = error {
                    print("Data could not be saved: \(error).")
                    completion()
                    // Alert
                } else {
                    print("Data saved successfully!")
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            })
        }
    }
    ///Retrieves user data by User model
    func fetchUserFromDatabase(uid: String, completion: @escaping SimpleClosure<User>) {
        DispatchQueue.global().async { [weak self] in
            self?.database.child(Key.users).observeSingleEvent(of: .value, with: { snapshot in
                if let dict = snapshot.value as? [String: [String: Any]] {
                    let users = dict.map { try! User(from: $0.value) }
                    let user = users.filter { $0.userInfo.uid == uid }
                    guard let user = user.first else { return }
                    DispatchQueue.main.async {
                        completion(user)
                        print("Current user data recieved")
                    }
                }
            })
        }
    }
    /// Starts observing users data by user model and returns array
    func startFetchUsersFromDatabase(completion: @escaping SimpleClosure<[User]>) {
        DispatchQueue.global().async { [weak self] in
            self?.database.child(Key.users).observe(.value, with: { snapshot in
                if let dict = snapshot.value as? [String: [String: Any]] {
                    let users = dict.map { try! User(from: $0.value) }
                    DispatchQueue.main.async {
                        completion(users)
                        print("Users data updated")
                    }
                }
            })
        }
    }
    /// Stops observing users data
    func stopFetchingUsersFromDatabase() {
        DispatchQueue.global().async { [weak self] in
            self?.database.child(Key.users).removeAllObservers()
            print("Fetching users stopped")
        }
    }
    ///Creates conversation in database by Message model with first message
    func createConversation(usersIsFetching: Bool, currentUser: User, companion: User, message: Message, completion: @escaping SimpleClosure<String>) {
        
        let conversationID = UUID().uuidString
        let messageID = message.messageID
        
        let conversation = Conversation(id: conversationID, /*lastActivity: Time.dateToString(date: Date()) */ lastMessage: message, messages: [messageID: message], participates: [Participates(email: currentUser.userInfo.email, name: "\(currentUser.userInfo.firstName) \(currentUser.userInfo.lastName)"), Participates(email: companion.userInfo.email, name: "\(companion.userInfo.firstName) \(companion.userInfo.lastName)")])
        
        let dict = conversation.dictionary
        let group = DispatchGroup()
        
        DispatchQueue.global().async { [weak self] in
            group.enter()
            self?.database.child(Key.conversations).child(conversationID).setValue(dict, withCompletionBlock: { error, ref in
                if let error = error {
                    fatalError("CreateConversation error - 1.1 \(error.localizedDescription)")
                } else {
                    group.leave()
                }
            })
            group.enter()
            if var currentUserConversations = currentUser.conversations {
                currentUserConversations.append(conversationID)
                self?.database.child(Key.users).child(currentUser.userInfo.uid).child(Key.conversations).setValue(currentUserConversations, withCompletionBlock: { error, ref in
                    if let error = error {
                        fatalError("Creating conversation error - 2.1 \(error.localizedDescription)")
                    } else {
                        group.leave()
                    }
                })
            } else {
                self?.database.child(Key.users).child(currentUser.userInfo.uid).child(Key.conversations).setValue([conversationID], withCompletionBlock: { error, ref in
                    if let error = error {
                        fatalError("Creating conversation error - 2.2 \(error.localizedDescription)")
                    } else {
                        group.leave()
                    }
                })
            }
            group.enter()
            if var companionConversations = companion.conversations {
                companionConversations.append(conversationID)
                self?.database.child(Key.users).child(companion.userInfo.uid).child(Key.conversations).setValue(companionConversations, withCompletionBlock: { error, ref in
                    if let error = error {
                        fatalError("Creating conversation error - 3.1 \(error.localizedDescription)")
                    } else {
                        group.leave()
                    }
                })
            } else {
                self?.database.child(Key.users).child(companion.userInfo.uid).child(Key.conversations).setValue([conversationID], withCompletionBlock: { error, ref in
                    if let error = error {
                        fatalError("Creating conversation error - 3.2 \(error.localizedDescription)")
                    } else {
                        group.leave()
                    }
                })
            }
            group.notify(queue: .main) {
                completion(conversationID)
            }
        }
    }
    /// Retrieves conversation for new messages by Conversation model
    func fetchChat(conversationID: String, completion: @escaping SimpleClosure<Conversation>) {
        
        DispatchQueue.global().async { [weak self] in
            self?.database.child(Key.conversations).queryOrdered(byChild: conversationID).observeSingleEvent(of: .value, with: { snapshot in
                if let dict = snapshot.value as? DictDataType {
                    let conversations = dict.map { try! Conversation(from: $0.value) }
                    let conversation = conversations.filter { $0.id == conversationID }
                    guard let conversation = conversation.first else { return }
                        completion(conversation)
                }
            })
        }
    }
    /// Sends message to database by Message model with completion handler
    func sendMessage(conversationID: String, message: Message, completion: @escaping EmptyClosure) {
        let fullMessage = message
        let messageID = message.messageID
        let message = message.dictionary
        
        DispatchQueue.global().async { [weak self] in
            self?.database.child(Key.conversations).child(conversationID).child(Key.messages).child(messageID).setValue(message) { error, ref in
                if let error = error {
                    fatalError("Sending message error - \(error.localizedDescription)")
                } else {
                    self?.updateLastActionTime(conversationID: conversationID, time: fullMessage.time, message: fullMessage)
                    print(message ?? "123")
                    completion()
                }
            }
        }
    }
    /// Fetch current chat all messages and returns in completion Set of massages
    func startFetchingNewMessages(conversationID: String, completion: @escaping SimpleClosure<Set<Message>>) {
            DispatchQueue.global().async { [weak self] in
                self?.database.child(Key.conversations).child(conversationID).child(Key.messages).observe(.value, with: { snapshot in
                    if let dict = snapshot.value as? [String: [String: Any]] {
                        let users = dict.map { try! Message(from: $0.value) }
//                        let set = Set(users.sorted(by: {Time.stringToDate(string: $0.time) < Time.stringToDate(string: $1.time)} ))
                        let set = Set(users.sorted(by: {Time.timeIntervalToDate(time: $0.time) < Time.timeIntervalToDate(time: $1.time)} ))
                            completion(set)
                            print("Fetching new messanges")
                    }
                })
            }
        }
    /// Returns messages which are sorted and numerated
    func fetchMessages(conversationID: String, limit: UInt, completion: @escaping SimpleClosure<[Message]>) {
        DispatchQueue.global().async { [weak self] in
            self?.database.child(Key.conversations).child(conversationID).child(Key.messages).queryOrdered(byChild: Key.time).queryLimited(toLast: limit).observeSingleEvent(of: .value, with: { snapshot in
                if let dict = snapshot.value as? DictDataType {
                    let messages = dict.map { try! Message(from: $0.value) }
                    let sortedMessages = messages.sorted(by: { $0.time > $1.time })
                    completion(sortedMessages)
                }
            })
        }
    }
    /// Start fetching new messages with limit - 1
    func startFetchingNewMessage(conversationID: String, completion: @escaping SimpleClosure<Set<Message>>) {
        DispatchQueue.global().async { [weak self] in
            self?.database.child(Key.conversations).child(conversationID).child(Key.messages).queryOrdered(byChild: Key.time).queryLimited(toLast: 1).observe(.value, with: { snapshot in
                if let dict = snapshot.value as? DictDataType {
                    let message = dict.map { try! Message(from: $0.value) }
//                    guard let message = message.first else { return }
                    completion(Set(message))
                }
            })
        }
    }
    /// Stop fetching new messages with limit - 1
    func stopFetchingNewMessagesLimit(conversationID: String) {
        DispatchQueue.global().async { [weak self] in
            self?.database.child(Key.conversations).child(conversationID).child(Key.messages).queryOrdered(byChild: Key.time).queryLimited(toLast: 1).removeAllObservers()
        }
    }
    
    /// Stopps fetching new messages from current chat
    func stopFetchingNewMessages(conversationID: String) {
        DispatchQueue.global().async { [weak self] in
            self?.database.child(Key.conversations).child(conversationID).child(Key.messages).removeAllObservers()
            print("Fetching conversation stopped")
        }
    }
    ///Update conversation last action time with last message
    func updateLastActionTime(conversationID: String, time: TimeInterval, message: Message) {
        let messageToSave = message.dictionary
        DispatchQueue.global().async { [weak self] in
            self?.database.child(Key.conversations).child(conversationID).child(Key.lastActivity).setValue(time)
            self?.database.child(Key.conversations).child(conversationID).child(Key.lastMessage).setValue(messageToSave)
        }
    }
    /// Start fetching all chats
    func startFetchingAllChats(completion: @escaping SimpleClosure<[Conversation]>) {
        DispatchQueue.global().async { [weak self] in
            self?.database.child(Key.conversations).observe(.value, with: { snapshot in
                
                if let dict = snapshot.value as? DictDataType {
                    let conversations = dict.map { try! Conversation(from: $0.value) }
                     completion(conversations)
                    print("Conversations data updated")
                }
            })
        }
    }
    ///Stop fetching all chats
    func stopFetchingAllChats() {
        DispatchQueue.global().async { [weak self] in
            self?.database.child(Key.conversations).removeAllObservers()
            print("Fetching all chats stopped")
        }
    }
    /// Sends data to the database that the user has read the message
    func readMessage(conversationID: String, messageID: String) {
        DispatchQueue.global().async { [weak self] in
            self?.database.child(Key.conversations).child(conversationID).child(Key.messages).child(messageID).child(Key.isRead).setValue(true)
        }
    }
}
//MARK: BackGround and Foreground
extension FirebaseRealtimeDatabaseManager {
    
    /// Sets indicatior in database that user is online
    func goOnline() {
        let user = UserDefaults.standard.getUserData()
        DispatchQueue.global().async { [weak self] in
            if UserDefaults.standard.isLoggedIn {
                self?.database.child(Key.users).child(user.uid).child(Key.isOnline).setValue(true)
            }
        }
    }
    /// Sets indicatior in database that user is offnline
    func goOffline() {
        let user = UserDefaults.standard.getUserData()
        DispatchQueue.global().async { [weak self] in
            if UserDefaults.standard.isLoggedIn {
                self?.database.child(Key.users).child(user.uid).child(Key.isOnline).setValue(false)
            }
        }
    }
}
