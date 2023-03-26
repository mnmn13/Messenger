//
//  SettingsViewModel.swift
//  Messenger
//
//  Created by MN on 06.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation

protocol SettingsViewModelType {
    func logOut()
}

class SettingsViewModel: SettingsViewModelType {
    
    fileprivate let coordinator: SettingsCoordinatorType
    private let userService: UserService
    private let chatService: ChatService
    
    
    
    
    init(coordinator: SettingsCoordinatorType, serviceHolder: ServiceHolder) {
        self.coordinator = coordinator
        self.userService = serviceHolder.get()
        self.chatService = serviceHolder.get()
    }
    
    
    func logOut() {
        userService.logout { bool in
            if bool {
                userService.stopFetchingMessages()
                chatService.stopFetchingAllChats()
                coordinator.logOut()
            }
        }
    }
    
    
}
