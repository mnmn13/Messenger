//
//  SignUpViewModel.swift
//  Messenger
//
//  Created by MN on 06.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation
import UIKit

protocol SignUpViewModelType {
    var onReload: EmptyClosure? { get set }
    
    //actions
//    func validate(email: String?, password1: String?, password2: String?, view: UIView) -> String
    func validate(email: String?, password1: String?, password2: String?, firstName: String?, lastName: String?, view: UIView) -> String
//    func register(email: String, password: String, completion: @escaping SimpleClosure<String>)
    func signIn()
}

class SignUpViewModel: SignUpViewModelType {
    
    var onReload: EmptyClosure?
    
    fileprivate let coordinator: SignUpCoordinatorType
    private var userService: UserService
    private var progressHudService: ProgressHudService
    
    init(coordinator: SignUpCoordinatorType, serviceHolder: ServiceHolder) {
        self.coordinator = coordinator
        self.userService = serviceHolder.get()
        self.progressHudService = serviceHolder.get()
    }
    
    deinit {
        print("\(type(of: self)) \(#function)")
    }
    
    //actions
    func validate(email: String?, password1: String?, password2: String?, firstName: String?, lastName: String?, view: UIView) -> String {
        
        guard let email = email, !email.isEmpty, email.isEmail() else { return "Incorrect email" }
        guard let pass = password1, !pass.isEmpty, pass.count >= 6 else { return "Incorrect password" }
        guard let pass2 = password2, !pass2.isEmpty, pass2 == pass else { return "Passwords do not match"}
        guard let fName = firstName, !fName.isEmpty, fName.count >= 3 else { return "You need to insert your name" }
        
        var lasName = ""
        
        if let lName = lastName, !lName.isEmpty {
            lasName = lName
        } else {
            lasName = ""
        }
        
        let alert: String = register(email: email, password: pass2, firstName: fName, lastName: lasName, view: view)
        
        return alert
    }
    
    func register(email: String, password: String, firstName: String, lastName: String, view: UIView) -> String {
        var alertMassage = ""
        progressHudService.progressViewActivate(view: view)
        
        userService.signUp(email: email, password: password, firstName: firstName, lastName: lastName) { [weak self] in
            guard let self = self else { return }
            self.progressHudService.progressViewDisable()
            self.coordinator.userDidRegister()
        }
        return alertMassage
    }
    
    func signIn() {}
    
    
    
    
    
    
}

