//
//  ProgressHudService.swift
//  Messenger
//
//  Created by MN on 06.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import JGProgressHUD

class ProgressHudService: Service {
    
    let loading = JGProgressHUD(style: .dark)
    
    func progressViewActivate(view: UIView) {
        loading.show(in: view, animated: true)
    }
    
    func progressViewDisable() {
        loading.dismiss()
    }
    
    func showError(view: UIView) {
        let error = JGProgressHUDErrorIndicatorView(contentView: view)
    }
}
