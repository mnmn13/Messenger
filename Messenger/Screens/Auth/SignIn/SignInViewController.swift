//
//  LoginViewController.swift
//  Messenger
//
//  Created by MN on 27.11.2022.
//

import UIKit

class SignInViewController: UIViewController  {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    var viewModel: SignInViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        setupTextFields()
    }
    	
  // UI
    private func setupTextFields() {
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        
        userNameTextField.autocapitalizationType = .none
        userNameTextField.autocorrectionType = .no
        userNameTextField.returnKeyType = .continue
        userNameTextField.layer.cornerRadius = 15
        
        passwordTextField.autocorrectionType = .no
        passwordTextField.autocapitalizationType = .none
        passwordTextField.returnKeyType = .send
        passwordTextField.layer.cornerRadius = 15
        passwordTextField.isSecureTextEntry = true
        
    }
    
// MARK: - Login
    @IBAction func loginTapped(_ sender: Any) {
        loginTappedExtension()
    }
    
    private func loginTappedExtension() {
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        statusLabel.text = viewModel.validate(email: userNameTextField.text, password: passwordTextField.text, view: view)
    }

    @IBAction func registerTapped(_ sender: Any) {
        viewModel.signUp()
    }
}

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == userNameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            loginTappedExtension()
        }
        
        
        return true
    }
    
}
