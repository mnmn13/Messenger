//
//  SettingsViewModel.swift
//  Messenger
//
//  Created by MN on 06.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation

protocol SettingsViewModelType {
    
}

class SettingsViewModel: SettingsViewModelType {
    
    fileprivate let coordinator: SettingsCoordinatorType
    
    
    
    
    init(coordinator: SettingsCoordinatorType, serviceHolder: ServiceHolder) {
        self.coordinator = coordinator
    }
    
    
    
    
    
}
