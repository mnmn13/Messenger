//
//  SignUp2ViewController.swift
//  Messenger
//
//  Created by MN on 30.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

class SignUp2ViewController: UIViewController {
    var viewModel: SignUp2ViewModelType!
    
    @IBOutlet weak var fNameTF: UITextField!
    @IBOutlet weak var lNameTF: UITextField!
    
    @IBOutlet weak var fNameErrorLabel: UILabel!
    @IBOutlet weak var lNameErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupErrorLabels()
        setupTF()
    }
    
    private func setupErrorLabels() {
        fNameErrorLabel.text = ""
        lNameErrorLabel.text = ""
    }
    
    private func setupTF() {
        fNameTF.delegate = self
        lNameTF.delegate = self
        
        fNameTF.autocorrectionType = .no
        fNameTF.autocapitalizationType = .none
        fNameTF.returnKeyType = .next
        fNameTF.layer.cornerRadius = 15
        fNameTF.isSecureTextEntry = false
        
        lNameTF.autocorrectionType = .no
        lNameTF.autocapitalizationType = .none
        lNameTF.returnKeyType = .next
        lNameTF.layer.cornerRadius = 15
        lNameTF.isSecureTextEntry = false
    }

    @IBAction func signUpTapped(_ sender: UIButton) {
        signUpTappedExtention()
    }
    
    private func signUpTappedExtention() {
        lNameErrorLabel.text = viewModel.validate(firstName: fNameTF.text, lastName: lNameTF.text, view: view)
    }
}

extension SignUp2ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fNameTF {
            lNameTF.becomeFirstResponder()
        } else if textField == lNameTF {
            signUpTappedExtention()
            //action
        }
        return true
    }
}
