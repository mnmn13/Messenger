//
//  RegisterViewController.swift
//  Messenger
//
//  Created by MN on 21.01.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
// 

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var password1TF: UITextField!
    @IBOutlet weak var password2TF: UITextField!
    @IBOutlet weak var alertLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    var viewModel: SignUpViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        registerKeyboardNotification()
    }
    deinit {
        removeKeyboardNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func setupTextFields() {
        
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        emailTF.delegate = self
        password1TF.delegate = self
        password2TF.delegate = self
        
        firstNameTF.autocorrectionType = .no
        firstNameTF.autocapitalizationType = .none
        firstNameTF.returnKeyType = .send
        firstNameTF.layer.cornerRadius = 15
        firstNameTF.isSecureTextEntry = false
        
        lastNameTF.autocorrectionType = .no
        lastNameTF.autocapitalizationType = .none
        lastNameTF.returnKeyType = .send
        lastNameTF.layer.cornerRadius = 15
        lastNameTF.isSecureTextEntry = false
        
        emailTF.autocapitalizationType = .none
        emailTF.autocorrectionType = .no
        emailTF.returnKeyType = .continue
        emailTF.layer.cornerRadius = 15
        
        password1TF.autocorrectionType = .no
        password1TF.autocapitalizationType = .none
        password1TF.returnKeyType = .send
        password1TF.layer.cornerRadius = 15
        password1TF.isSecureTextEntry = true
        
        password2TF.autocorrectionType = .no
        password2TF.autocapitalizationType = .none
        password2TF.returnKeyType = .send
        password2TF.layer.cornerRadius = 15
        password2TF.isSecureTextEntry = true
    }
    
    
    func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardShow(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let bottomSpace = self.view.frame.height - (registerButton.frame.origin.y + registerButton.frame.height)
            self.view.frame.origin.y -= keyboardHeight - bottomSpace + 10
        }
    }
    
    @objc private func keyboardHide() {
        self.view.frame.origin.y = 0
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        
//        alertLabel.text = viewModel.validate(email: emailTF.text, password1: password1TF.text, password2: password2TF.text, view: view)
        alertLabel.text = viewModel.validate(email: emailTF.text, password1: password1TF.text, password2: password2TF.text, firstName: firstNameTF.text, lastName: lastNameTF.text, view: view)
        
    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTF {
            password1TF.becomeFirstResponder()
        } else if textField == password1TF {
            password2TF.becomeFirstResponder()
            //            loginTappedExtension()
        } else if textField == password2TF {
            alertLabel.text = viewModel.validate(email: emailTF.text, password1: password1TF.text, password2: password2TF.text, firstName: firstNameTF.text, lastName: lastNameTF.text, view: view)
        }
        return true
    }
}
