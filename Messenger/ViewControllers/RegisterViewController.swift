//
//  RegisterViewController.swift
//  Messenger
//
//  Created by MN on 21.01.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
// 

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var errorFirstNameLabel: UILabel!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var errorLastNameLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorEmailLabel: UILabel!
    
    @IBOutlet weak var createPasswordTextField: UITextField!
    @IBOutlet weak var errorCreatePasswordLabel: UILabel!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var errorConfirmPasswordLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        setupTextFields()
    }
    
    private func setupTextFields() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        createPasswordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        firstNameTextField.autocapitalizationType = .none
        firstNameTextField.autocorrectionType = .no
        firstNameTextField.returnKeyType = .continue
        firstNameTextField.layer.cornerRadius = 15
        
        lastNameTextField.autocapitalizationType = .none
        lastNameTextField.autocorrectionType = .no
        lastNameTextField.returnKeyType = .continue
        lastNameTextField.layer.cornerRadius = 15
        
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.returnKeyType = .continue
        emailTextField.layer.cornerRadius = 15
        
        createPasswordTextField.autocorrectionType = .no
        createPasswordTextField.autocapitalizationType = .none
        createPasswordTextField.returnKeyType = .continue
        createPasswordTextField.layer.cornerRadius = 15
        createPasswordTextField.isSecureTextEntry = true
        
        confirmPasswordTextField.autocapitalizationType = .none
        confirmPasswordTextField.autocorrectionType = .no
        confirmPasswordTextField.returnKeyType = .join
        confirmPasswordTextField.layer.cornerRadius = 15
        confirmPasswordTextField.isSecureTextEntry = true
        
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        registerExtension()
    }
    
    private func registerExtension() {
        
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        createPasswordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        
        guard let firstName = firstNameTextField.text, !firstName.isEmpty, firstName.count >= 2 else { firstNameError(); return }
        guard let lastName = lastNameTextField.text, !lastName.isEmpty, lastName.count >= 4 else { lastNameError(); return }
        guard let email = emailTextField.text, !email.isEmpty else { emailError() ; return }
        guard let pass = createPasswordTextField.text, !pass.isEmpty, pass.count >= 6 else { createPasswordError(); return }
        guard let confirmPass = createPasswordTextField.text, !confirmPass.isEmpty, confirmPass == pass else { confirmPasswordError(); return }
        
        // Firebase
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: confirmPass) { AuthDataResult, Error in
            guard let result = AuthDataResult, Error == nil else {
                print("Creting user error \(String(describing: Error))")
                return
            }
            let user = result.user
            print("Created User: \(user)")
        }
        
        
        
        
    }
    
    private func firstNameError() {
        errorFirstNameLabel.text = "Name must contain at least 2 characters"
    }
    
    private func lastNameError() {
        errorLastNameLabel.text = "Last name must contain at least 4 characters"
    }
    
    private func emailError() {
        errorEmailLabel.text = "Email is incorrect"
    }
    
    private func createPasswordError() {
        errorCreatePasswordLabel.text = "Password must contain at least 6 characters"
    }
    private func confirmPasswordError() {
        errorConfirmPasswordLabel.text = "Passwords do not match"
    }

}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            createPasswordTextField.becomeFirstResponder()
        } else if textField == createPasswordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else if textField == createPasswordTextField {
            registerExtension()
        }
        return true
    }
    
}
