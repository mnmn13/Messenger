//
//  UIStoryboardExtensions.swift
//  Messenger
//
//  Created by MN on 05.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

struct Storyboard {
    static let auth = UIStoryboard(name: "Auth", bundle: nil)
    static let conversations = UIStoryboard(name: "Conversations", bundle: nil)
    static let contacts = UIStoryboard(name: "Contacts", bundle: nil)
    static let settings = UIStoryboard(name: "Settings", bundle: nil)
    static let chat = UIStoryboard(name: "Chat", bundle: nil)
}

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self.self)
    }
}

extension UIStoryboard {
    
    func controller<T: UIViewController>(withClass: T.Type) -> T? {
        let identifier = withClass.identifier
        return instantiateViewController(withIdentifier: identifier) as? T
    }
    
    func instantiateViewController<T: StoryboardIdentifiable>() -> T? {
        return instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T
    }
}

extension UIViewController: StoryboardIdentifiable { }
