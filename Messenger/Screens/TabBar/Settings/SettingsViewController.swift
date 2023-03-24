//
//  SettingsViewController.swift
//  Messenger
//
//  Created by MN on 23.01.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    var viewModel: SettingsViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        setupNav()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        didAutorized()
    }
    
    private func setupNav() {
//        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
    }
    
    @objc private func editTapped() {
        let storyboard = UIStoryboard(name: "UserSettings", bundle: .main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "settingsUser")
        let navController = UINavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    
    
    
    
    
    
    
    
    
    
//    private func didAutorized() {
//        if FirebaseAuth.Auth.auth().currentUser == nil {
//            tabBarController?.selectedIndex = 0
//        }
//    }
}
