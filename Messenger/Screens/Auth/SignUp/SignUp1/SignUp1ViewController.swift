//
//  SignUp1ViewController.swift
//  Messenger
//
//  Created by MN on 30.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

class SignUp1ViewController: UIViewController {
    
    var viewModel: SignUp1ViewModelType!
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var createPassTF: UITextField!
    @IBOutlet weak var confirmPassTF: UITextField!
    
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupErrorLabels()
        setupTF()
    }
    
    private func setupErrorLabels() {
        emailErrorLabel.text = ""
        passErrorLabel.text = ""
    }
    
    private func setupTF() {
        emailTF.delegate = self
        createPassTF.delegate = self
        confirmPassTF.delegate = self
        
        emailTF.autocorrectionType = .no
        emailTF.autocapitalizationType = .none
        emailTF.returnKeyType = .next
        emailTF.layer.cornerRadius = 15
        emailTF.isSecureTextEntry = false
        
        createPassTF.autocorrectionType = .no
        createPassTF.autocapitalizationType = .none
        createPassTF.returnKeyType = .next
        createPassTF.layer.cornerRadius = 15
        createPassTF.isSecureTextEntry = true
        
        confirmPassTF.autocorrectionType = .no
        confirmPassTF.autocapitalizationType = .none
        confirmPassTF.returnKeyType = .next
        confirmPassTF.layer.cornerRadius = 15
        confirmPassTF.isSecureTextEntry = true
    }
    
    @IBAction func nextClicked(_ sender: UIButton) {
        nextClickedExtension()
    }
    
    private func nextClickedExtension() {
        emailErrorLabel.text = viewModel.validateEmail(email: emailTF.text)
        passErrorLabel.text = viewModel.validatePass(pass1: createPassTF.text, pass2: confirmPassTF.text)
    }
}

extension SignUp1ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF {
            createPassTF.becomeFirstResponder()
            emailErrorLabel.text = viewModel.validateEmail(email: emailTF.text)
        } else if textField == createPassTF {
            confirmPassTF.becomeFirstResponder()
        } else if textField == confirmPassTF {
            nextClickedExtension()
        }
        return true
    }
}
