//
//  SignUp1ViewModel.swift
//  Messenger
//
//  Created by MN on 30.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

protocol SignUp1ViewModelType: AnyObject {
    func validateEmail(email: String?) -> String
    func validatePass(pass1: String?, pass2: String?) -> String
}

class SignUp1ViewModel: SignUp1ViewModelType {
    fileprivate let coordinator: SignUp1CoordinatorType
    private var userService: UserService
    private var emailSave = ""
    
    init(coordinator: SignUp1CoordinatorType, serviceHolder: ServiceHolder) {
        self.coordinator = coordinator
        self.userService = serviceHolder.get()
    }
    
    func validateEmail(email: String?) -> String {
        if let email = email {
            if email.isEmpty {
                return "Email cannot be empty"
            } else if !email.isEmail() {
                return "Incorrect email"
            } else {
                emailSave = email
                return ""
            }
        }
        return ""
    }
    
    func validatePass(pass1: String?, pass2: String?) -> String {
        if let pass1 = pass1, let pass2 = pass2 {
            if pass1.isEmpty {
                return "Password cannot be empty"
            } else if pass1 != pass2 {
                return "Passwords do not match"
            } else if pass1.count < 6 {
                return "Password must be at least 6 characters"
            } else {
                next(pass: pass1)
                //action
            }
        }
        return ""
    }
    
    private func next(pass: String) {
        guard !emailSave.isEmpty else { return }
        coordinator.nextClicked(email: emailSave, password: pass, firstName: nil, lastName: nil)
    }
}
