//
//  SignInViewModel.swift
//  Messenger
//
//  Created by MN on 05.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

protocol SignInViewModelType {
    
    var onReload: EmptyClosure? { get set }
    
    func validate(email: String?, password: String?, view: UIView) -> String
    func signUp()
    func signIn()
}

class SignInViewModel: SignInViewModelType {
    
    var onReload: EmptyClosure?
    
    fileprivate let coordinator: SignInCoordinatorType
    private var userService: UserService
    private var progressHudService: ProgressHudService
    
    init(coordinator: SignInCoordinatorType, serviceHolder: ServiceHolder) {
        self.coordinator = coordinator
        self.userService = serviceHolder.get()
        self.progressHudService = serviceHolder.get()
    }
    
    deinit {
        print("\(type(of: self)) \(#function)")
    }
    
    //actions
    func validate(email: String?, password: String?, view: UIView) -> String {
        guard let email = email, !email.isEmpty, email.isEmail() else { return "Incorrect email" }
        guard let pass = password, !pass.isEmpty, pass.count >= 6 else { return "Incorrect password" }
        let alert: String = login(email: email, password: pass, view: view)
        return alert
    }
    
    func login(email: String, password: String, view: UIView) -> String {
        let alertMassage = ""
        progressHudService.progressViewActivate(view: view)
        userService.signIn(email: email, password: password) { [weak self] in
            guard let self = self else { return }
            self.progressHudService.progressViewDisable()
            self.coordinator.userDidLogin()
        }
        return alertMassage
    }
    
    func signUp() {
        coordinator.signUp()
    }
    func signIn() {
        coordinator.userDidLogin()
    }
}
