//
//  LoginViewController.swift
//  Messenger
//
//  Created by MN on 27.11.2022.
//

import UIKit
import FirebaseAuth
import RxSwift

class LoginViewController: UIViewController  {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        setupTextFields()
    }
    
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
    
    
    @IBAction func loginTapped(_ sender: Any) {
        loginTappedExtension()
    }
    
    private func loginTappedExtension() {
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        guard let login = userNameTextField.text, !login.isEmpty else { loginError(); return }
        guard let pass = passwordTextField.text, !pass.isEmpty, pass.count >= 6 else { passwordError(); return }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: login, password: pass) { AuthDataResult, Error in
            guard let result = AuthDataResult, Error == nil else {
                print("SingIn Error: \(String(describing: Error))")
                return
            }
            let user = result.user
            print("LoggedIn User: \(user)")
        }
        
    }
    
    private func loginError() {
        
        loginErrorLabel.text = "Login is incorrect"
        
    }
    
    private func passwordError() {
        
        passwordErrorLabel.text = "Password is incorrect"
    }
    

    @IBAction func registerTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Registration", bundle: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: "register")
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == userNameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            loginTappedExtension()
        }
        
        
        return true
    }
    
}
