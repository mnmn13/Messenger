//
//  SettingsUserView.swift
//  Messenger
//
//  Created by MN on 28.01.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation
import UIKit

class SettingsUserView: UIView {
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var changePhotoButton: UIButton!
    
    @IBOutlet var gesture: UITapGestureRecognizer!

    
    //    let settings: SettingsUserViewController!
    
//    let identifier = "settingsView"
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let xibView = Bundle.main.loadNibNamed("SettingsUserView", owner: self, options: nil)![0] as! UIView
        //        Bundle.main.loadNibNamed("SettingsUserView", owner: self)
        //        addSubview(UIView)
        
        
        xibView.frame = self.bounds
        addSubview(xibView)
        userImage.isUserInteractionEnabled = true
        
    }
    @IBAction func changePhotoTapped(_ sender: Any) {

    }
    
    @IBAction func changePhotoButtonTapped(_ sender: Any) {
        print("TapTap")
        let vc = NewChatViewController()

    }
    
    
}
