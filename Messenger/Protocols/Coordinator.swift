//
//  Protocols.swift
//  Messenger
//
//  Created by MN on 27.11.2022.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
