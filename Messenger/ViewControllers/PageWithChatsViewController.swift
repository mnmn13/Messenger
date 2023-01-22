//
//  PageWithChatsViewController.swift
//  Messenger
//
//  Created by MN on 13.12.2022.
//  Copyright © 2022 Nikita Moshyn. All rights reserved.
//
// Storyborard id = pageWithChats
//

import UIKit

class PageWithChatsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setVC()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func setVC() {
        let authorized = UserDefaults.standard.bool(forKey: "authorized")
        
        if !authorized {
            let storyboard = UIStoryboard(name: "Login", bundle: .main)
            let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            let navController = UINavigationController(rootViewController: viewController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: false)
        }
    }
    
    
}
