//
//  SignUp2ViewModel.swift
//  Messenger
//
//  Created by MN on 30.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

protocol SignUp2ViewModelType: AnyObject {
    func validate(firstName: String?, lastName: String?, view: UIView) -> String
}

class SignUp2ViewModel: SignUp2ViewModelType {
    
    fileprivate let coordinator: SignUp2CoordinatorType
    private var userService: UserService
    private var progressHudService: ProgressHudService
    private let email: String
    private let password: String
    
    init(coordinator: SignUp2CoordinatorType, serviceHolder: ServiceHolder, email: String, password: String) {
        self.coordinator = coordinator
        self.userService = serviceHolder.get()
        self.progressHudService = serviceHolder.get()
        self.email = email
        self.password = password
    }
    
    func validate(firstName: String?, lastName: String?, view: UIView) -> String {
        guard let firstName = firstName, !firstName.isEmpty, firstName.count > 2 else { return "First name must contain at least 2 symbols"}
        
        guard let lastName = lastName, !lastName.isEmpty, lastName.count > 4 else { return "LastName must contain at least 4 symbols"}
        
        signUp(email: email, password: password, fName: firstName, lName: lastName, view: view)
        
        return ""
    }
    
    private func signUp(email: String, password: String, fName: String, lName: String, view: UIView) {
        
        progressHudService.progressViewActivate(view: view)
        
        userService.signUp(email: email, password: password, firstName: fName, lastName: lName) { [weak self] in
            guard let self = self else { return }
            self.progressHudService.progressViewDisable()
            self.coordinator.nextClicked(email: "", password: "", firstName: "", lastName: "")
        }
    }
}
